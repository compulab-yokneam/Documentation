#!/bin/bash

set -Eeuo pipefail

readonly BACKUP_ROOT=/boot/kernel-backup.d
readonly WORK_ROOT=/var/tmp

TAR_FILE=
work_dir=
stage_root=
boot_mount=
boot_device=
boot_mounted=0
boot_modified=0
install_complete=0
backup_dir=
backup_files_dir=
version=
new_image=
dtb_dir=

die() {
	printf 'ERROR: %s\n' "$*" >&2
	exit 1
}

warn() {
	printf 'WARNING: %s\n' "$*" >&2
}

canonical_mount_source() {
	local source=$1

	# findmnt appends a subvolume in brackets for some filesystems.
	source=${source%%\[*}
	readlink -f -- "$source"
}

source_for_path() {
	local source

	source=$(findmnt --noheadings --raw --output SOURCE --target "$1") || return 1
	canonical_mount_source "$source"
}

read_uboot_env() {
	local name=$1
	local value

	value=$(fw_printenv "$name") || return 1
	case $value in
		"$name="*) printf '%s\n' "${value#*=}" ;;
		*) return 1 ;;
	esac
}

validate_uboot_value() {
	local name=$1
	local value=$2

	[[ -n $value ]] || die "U-Boot variable '$name' is empty"
	[[ $value =~ ^[A-Za-z0-9._/+:-]+$ ]] ||
		die "U-Boot variable '$name' contains unsupported characters: $value"
}

clear_managed_boot_files() {
	local files=()

	mapfile -d '' files < <(
		find "$boot_mount" -mindepth 1 -maxdepth 1 \
			\( -type f -o -type l \) \
			\( -name 'Image*' -o -name '*.dtb*' -o \
			   -name 'kernel*' -o -name 'config*' \) -print0
	)

	((${#files[@]} == 0)) || rm -f -- "${files[@]}"
}

restore_boot_backup() {
	[[ -n $backup_files_dir && -d $backup_files_dir ]] || {
		warn 'Cannot roll back the boot partition: no verified backup is available'
		return 1
	}

	warn "Restoring the boot partition from $backup_files_dir"
	clear_managed_boot_files || return 1
	cp -a -- "$backup_files_dir"/. "$boot_mount"/ || return 1
	sync
}

cleanup() {
	local status=$?
	local cleanup_failed=0
	local unmount_failed=0

	trap - EXIT INT TERM
	set +e

	if ((status != 0 && boot_mounted && boot_modified && !install_complete)); then
		restore_boot_backup || cleanup_failed=1
	fi

	if ((boot_mounted)); then
		umount -- "$boot_mount" || {
			warn "Unable to unmount temporary boot mount $boot_mount"
			cleanup_failed=1
			unmount_failed=1
		}
		((unmount_failed)) || boot_mounted=0
	fi

	if ((!boot_mounted)) && [[ -n $work_dir && -d $work_dir ]]; then
		case $work_dir in
			/var/tmp/cl-kernel-install.*) rm -rf -- "$work_dir" ;;
			*) warn "Refusing to remove unexpected work directory: $work_dir" ;;
		esac
	fi

	if ((status == 0 && cleanup_failed)); then
		status=1
	fi
	exit "$status"
}

require_commands() {
	local command
	local missing=()

	for command in awk basename cat chmod cmp cp date df dirname du find findmnt \
		fw_printenv gzip ln lsblk mkdir mktemp mount mv readlink rm sync tar \
		umount uname; do
		command -v "$command" >/dev/null 2>&1 || missing+=("$command")
	done

	((${#missing[@]} == 0)) ||
		die "Required commands are missing: ${missing[*]}"
}

validate_archive() {
	local manifest=$work_dir/archive-members

	printf 'Validating archive %s\n' "$TAR_FILE"
	tar -tf "$TAR_FILE" >"$manifest" || die "Cannot read archive: $TAR_FILE"
	[[ -s $manifest ]] || die "Archive is empty: $TAR_FILE"

	if ! awk '
		/^\// || /(^|\/)\.\.(\/|$)/ {
			print "unsafe archive member: " $0 > "/dev/stderr"
			bad = 1
		}
		END { exit bad }
	' "$manifest"; then
		die 'Archive contains an absolute path or a parent-directory traversal'
	fi

	if awk '{ name=$0; sub(/^\.\//, "", name); if (name ~ /^boot\/kernel-backup\.d\//) found=1 } END { exit !found }' \
		"$manifest"; then
		die "Archive must not contain files below $BACKUP_ROOT"
	fi
}

select_dtb_directory() {
	local fdt_name=$1
	local candidate
	local relative
	local matches=()
	local preferred=()

	while IFS= read -r -d '' candidate; do
		relative=${candidate#"$stage_root"/}
		if [[ $relative == "$fdt_name" || $relative == */"$fdt_name" ]]; then
			matches+=("$candidate")
			if [[ $relative == *"/$version/"* || $relative == *"linux-image-$version/"* ]]; then
				preferred+=("$candidate")
			fi
		fi
	done < <(find "$stage_root" -type f -print0)

	if ((${#preferred[@]} == 1)); then
		candidate=${preferred[0]}
	elif ((${#matches[@]} == 1)); then
		candidate=${matches[0]}
	else
		die "Expected one device tree named '$fdt_name' for kernel $version; found ${#matches[@]}"
	fi

	dtb_dir=$(dirname -- "$candidate")
}

select_boot_payload() {
	local fdt_name=$1
	local images=()
	local compressed_images=()
	local candidate
	local payload_dir

	if [[ -d $stage_root/boot/efi ]]; then
		mapfile -d '' images < <(
			find "$stage_root/boot/efi" -mindepth 2 -maxdepth 2 \
				\( -type f -o -type l \) -name Image -print0
		)
	fi

	if ((${#images[@]} == 1)); then
		new_image=${images[0]}
		payload_dir=$(dirname -- "$new_image")
		version=$(basename -- "$payload_dir")
		[[ -s $new_image ]] || die "Packaged kernel Image is empty: $new_image"

		candidate=$payload_dir/$fdt_name
		if [[ -f $candidate ]]; then
			dtb_dir=$payload_dir
		else
			select_dtb_directory "$fdt_name"
		fi
	elif ((${#images[@]} > 1)); then
		die 'Archive contains more than one versioned boot/efi kernel Image'
	else
		if [[ -d $stage_root/boot ]]; then
			mapfile -d '' compressed_images < <(
				find "$stage_root/boot" -mindepth 1 -maxdepth 1 -type f \
					-name 'vmlinuz-*' -print0
			)
		fi
		((${#compressed_images[@]} == 1)) ||
			die "Expected one boot/vmlinuz-* file; found ${#compressed_images[@]}"

		candidate=${compressed_images[0]}
		version=${candidate##*/vmlinuz-}
		gzip -t -- "$candidate" || die "Packaged kernel is not a valid gzip file: $candidate"
		new_image=$work_dir/Image-$version
		gzip -dc -- "$candidate" >"$new_image"
		[[ -s $new_image ]] || die 'Decompressed kernel Image is empty'
		select_dtb_directory "$fdt_name"
	fi

	[[ $version =~ ^[A-Za-z0-9._+-]+$ ]] ||
		die "Invalid kernel release derived from archive: $version"
}

validate_boot_payload() {
	local fdt_name=$1
	local dtbs=()
	local names=()
	local file
	local name

	mapfile -d '' dtbs < <(
		find "$dtb_dir" -mindepth 1 -maxdepth 1 -type f \
			\( -name '*.dtb' -o -name '*.dtbo' \) -print0
	)
	((${#dtbs[@]} > 0)) || die "No device trees found in $dtb_dir"
	[[ -f $dtb_dir/$fdt_name ]] ||
		die "Required device tree '$fdt_name' is not in selected directory $dtb_dir"

	for file in "${dtbs[@]}"; do
		name=${file##*/}
		if [[ " ${names[*]-} " == *" $name "* ]]; then
			die "Duplicate device-tree filename in boot payload: $name"
		fi
		names+=("$name")
	done

	printf 'Selected kernel release: %s\n' "$version"
	printf 'Selected device-tree directory: %s\n' "$dtb_dir"
}

resolve_boot_device() {
	local root_source
	local root_device
	local root_part
	local parent_name
	local candidates=()
	local candidate
	local path_source

	root_source=$(findmnt --noheadings --raw --output SOURCE --target /) ||
		die 'Cannot determine the root filesystem device'
	root_device=$(canonical_mount_source "$root_source") ||
		die "Cannot resolve root filesystem source: $root_source"
	[[ -b $root_device ]] || die "Root filesystem source is not a block device: $root_device"

	root_part=$(lsblk --nodeps --noheadings --raw --output PARTN "$root_device") ||
		die "Cannot determine partition number for $root_device"
	[[ $root_part == 2 ]] ||
		die "Root filesystem must be partition 2; $root_device is partition ${root_part:-unknown}"

	parent_name=$(lsblk --nodeps --noheadings --raw --output PKNAME "$root_device") ||
		die "Cannot determine parent device for $root_device"
	[[ -n $parent_name ]] || die "No parent block device found for $root_device"

	mapfile -t candidates < <(
		lsblk --list --paths --noheadings --output NAME,PARTN "/dev/$parent_name" |
			awk '$2 == 1 { print $1 }'
	)
	((${#candidates[@]} == 1)) ||
		die "Expected one partition 1 on /dev/$parent_name; found ${#candidates[@]}"
	boot_device=$(readlink -f -- "${candidates[0]}")
	[[ -b $boot_device ]] || die "Boot partition is not a block device: $boot_device"
	[[ $boot_device != "$root_device" ]] || die 'Boot and root devices resolve to the same partition'

	for candidate in /boot "$WORK_ROOT"; do
		path_source=$(source_for_path "$candidate") || die "Cannot determine filesystem for $candidate"
		[[ $path_source == "$root_device" ]] ||
			die "$candidate must reside on root partition $root_device (found $path_source)"
	done

	printf 'Root partition: %s\n' "$root_device"
	printf 'Boot partition: %s\n' "$boot_device"
}

mount_boot_partition() {
	mkdir -p -- "$boot_mount"
	mount -- "$boot_device" "$boot_mount"
	boot_mounted=1

	local mounted_source
	mounted_source=$(source_for_path "$boot_mount") || die 'Cannot verify temporary boot mount'
	[[ $mounted_source == "$boot_device" ]] ||
		die "Unexpected device mounted at $boot_mount: $mounted_source"
}

create_boot_backup() {
	local current_kernel=$1
	local current_image_name=$2
	local current_fdt_name=$3
	local current_files=()
	local source
	local destination
	local stamp

	mkdir -p -- "$BACKUP_ROOT"
	stamp=$(date -u +%Y%m%d%H%M%S)
	backup_dir=$BACKUP_ROOT/${current_kernel}-${stamp}
	if [[ -e $backup_dir ]]; then
		backup_dir=$(mktemp -d "$BACKUP_ROOT/${current_kernel}-${stamp}.XXXXXX")
	else
		mkdir -- "$backup_dir"
	fi
	chmod 700 "$backup_dir"
	backup_files_dir=$backup_dir/files
	mkdir -- "$backup_files_dir"

	mapfile -d '' current_files < <(
		find "$boot_mount" -mindepth 1 -maxdepth 1 \
			\( -type f -o -type l \) \
			\( -name 'Image*' -o -name '*.dtb*' -o \
			   -name 'kernel*' -o -name 'config*' \) -print0
	)
	((${#current_files[@]} > 0)) || die 'No current kernel or device-tree files found on boot partition'
	[[ -s $boot_mount/$current_image_name ]] ||
		die "Current kernel image is missing or empty: $current_image_name"
	[[ -s $boot_mount/$current_fdt_name ]] ||
		die "Current device tree is missing or empty: $current_fdt_name"

	cp -a -- "${current_files[@]}" "$backup_files_dir"/

	for source in "${current_files[@]}"; do
		destination=$backup_files_dir/${source##*/}
		if [[ -L $source ]]; then
			[[ -L $destination && $(readlink -- "$source") == $(readlink -- "$destination") ]] ||
				die "Backup verification failed for $source"
		else
			cmp -s -- "$source" "$destination" || die "Backup verification failed for $source"
		fi
	done
	sync
	printf 'Verified boot backup: %s\n' "$backup_dir"
}

create_recovery_script() {
	local current_kernel=$1
	local current_image_name=$2
	local current_fdt_name=$3
	local recovery_image=$backup_files_dir/$current_image_name
	local recovery_fdt=$backup_files_dir/$current_fdt_name
	local boot_input=$backup_dir/boot.in
	local boot_script=$backup_dir/boot.scr

	printf 'setenv image %s\nsetenv fdtfile %s\nsetenv boot_part 2\nsetenv part 2\n' \
		"$recovery_image" "$recovery_fdt" >"$boot_input"

	if command -v mkimage >/dev/null 2>&1; then
		mkimage -C none -O Linux -A arm -T script -d "$boot_input" "$boot_script"
		cp -a -- "$boot_script" "$boot_mount/boot.$current_kernel.scr"
	else
		warn 'mkimage is unavailable; the verified backup was saved without a U-Boot recovery script'
	fi
}

check_boot_space() {
	local current_files=()
	local required_kb
	local available_kb
	local reclaimable_kb=0
	local file

	mapfile -d '' current_files < <(
		find "$boot_mount" -mindepth 1 -maxdepth 1 \
			\( -type f -o -type l \) \
			\( -name 'Image*' -o -name '*.dtb*' -o \
			   -name 'kernel*' -o -name 'config*' \) -print0
	)
	required_kb=$(du -sk -- "$new_image" "$dtb_dir" | awk '{ total += $1 } END { print total + 0 }')
	available_kb=$(df -Pk -- "$boot_mount" | awk 'NR == 2 { print $4 }')
	for file in "${current_files[@]}"; do
		reclaimable_kb=$((reclaimable_kb + $(du -sk -- "$file" | awk '{ print $1 }')))
	done

	((required_kb <= available_kb + reclaimable_kb)) ||
		die "New boot payload needs ${required_kb} KiB; only $((available_kb + reclaimable_kb)) KiB is available after cleanup"
}

install_staged_rootfs() {
	local required_kb
	local available_kb
	local entry
	local boot_entry

	required_kb=$(du -sk -- "$stage_root" | awk '{ print $1 }')
	available_kb=$(df -Pk -- / | awk 'NR == 2 { print $4 }')
	((required_kb <= available_kb)) ||
		die "Staged package needs up to ${required_kb} KiB; root filesystem has ${available_kb} KiB free"

	# boot/efi is the staged boot payload. It is installed separately onto the
	# real boot partition and must not be copied through a possibly mounted path.
	shopt -s dotglob nullglob
	for entry in "$stage_root"/*; do
		if [[ ${entry##*/} == boot && -d $entry && ! -L $entry ]]; then
			mkdir -p /boot
			for boot_entry in "$entry"/*; do
				[[ ${boot_entry##*/} == efi ]] && continue
				cp -a -- "$boot_entry" /boot/
			done
		else
			cp -a -- "$entry" /
		fi
	done
	shopt -u dotglob nullglob
	sync
}

install_boot_payload() {
	local dtbs=()
	local file
	local installed_image=$boot_mount/Image-$version

	mapfile -d '' dtbs < <(
		find "$dtb_dir" -mindepth 1 -maxdepth 1 -type f \
			\( -name '*.dtb' -o -name '*.dtbo' \) -print0
	)

	boot_modified=1
	clear_managed_boot_files
	cp -a -- "$new_image" "$installed_image"
	if ! ln -sfn -- "Image-$version" "$boot_mount/Image" 2>/dev/null; then
		rm -f -- "$boot_mount/Image"
		mv -- "$installed_image" "$boot_mount/Image"
	fi
	cp -a -- "${dtbs[@]}" "$boot_mount"/
	sync

	cmp -s -- "$new_image" "$boot_mount/Image" || die 'Installed kernel Image failed verification'
	for file in "${dtbs[@]}"; do
		cmp -s -- "$file" "$boot_mount/${file##*/}" ||
			die "Installed device tree failed verification: ${file##*/}"
	done
	install_complete=1
}

main() {
	local current_kernel
	local current_image
	local current_fdt
	local current_image_name
	local current_fdt_name

	[[ $EUID -eq 0 ]] || die 'This installer must be run as root'
	[[ $# -eq 1 ]] || die "Usage: $0 /path/to/linux-compulab.tar.bz2"
	TAR_FILE=$1
	[[ -f $TAR_FILE && -r $TAR_FILE ]] || die "Archive is not a readable regular file: $TAR_FILE"

	require_commands
	current_kernel=$(uname -r)
	current_image=$(read_uboot_env image) || die "Cannot read U-Boot variable 'image'"
	current_fdt=$(read_uboot_env fdtfile) || die "Cannot read U-Boot variable 'fdtfile'"
	validate_uboot_value image "$current_image"
	validate_uboot_value fdtfile "$current_fdt"
	current_image_name=${current_image##*/}
	current_fdt_name=${current_fdt##*/}

	resolve_boot_device
	work_dir=$(mktemp -d "$WORK_ROOT/cl-kernel-install.XXXXXX")
	trap cleanup EXIT
	trap 'exit 130' INT
	trap 'exit 143' TERM
	stage_root=$work_dir/root
	boot_mount=$work_dir/boot-partition
	mkdir -- "$stage_root" "$boot_mount"

	validate_archive
	printf 'Extracting archive into staging directory\n'
	tar --numeric-owner -xf "$TAR_FILE" -C "$stage_root"
	select_boot_payload "$current_fdt_name"
	validate_boot_payload "$current_fdt_name"

	mount_boot_partition
	create_boot_backup "$current_kernel" "$current_image_name" "$current_fdt_name"
	create_recovery_script "$current_kernel" "$current_image_name" "$current_fdt_name"
	check_boot_space

	printf 'Installing staged root-filesystem content\n'
	install_staged_rootfs
	printf 'Replacing boot-partition kernel and device trees\n'
	install_boot_payload

	umount -- "$boot_mount"
	boot_mounted=0
	rm -rf -- "$work_dir"
	work_dir=
	trap - EXIT INT TERM

	cat <<EOF
Kernel $version deployed successfully.
Verified boot backup: $backup_dir
Reboot the system and issue: run bsp_bootcmd
EOF
}

main "$@"
