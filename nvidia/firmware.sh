#!/bin/bash -e

[[ -n ${dry_run:-""} ]] && DR="echo" || DR=""
restore=${restore:-"no"}
IWLWIFI_DIR=/lib/firmware/iwlwifi.d
IWLWIFI_PAT=/lib/firmware/iwlwifi-
IWLWIF_FW="iwlwifi-cc-a0-62.ucode iwlwifi-ty-a0-gf-a0-65.ucode"

main() {
cat << eof
${FUNCNAME[0]}
eof
	if [[ ! -d ${IWLWIFI_DIR} ]];then
		main_in
	else
		main_out
	fi
}

main_out() {
cat << eof
${FUNCNAME[0]} restore: [ ${restore} ] ...
eof
	[[ ! ${restore} = "no" ]] || return 0
	for _fw in ${IWLWIF_FW};do
		${DR} unlink $(dirname ${IWLWIFI_DIR})/${_fw}
	done
	${DR} mv ${IWLWIFI_DIR}/* ${IWLWIFI_DIR}/../
	${DR} rm -rf ${IWLWIFI_DIR}/
	for _fw in ${IWLWIF_FW};do
		${DR} stat -c %F:%n $(dirname ${IWLWIFI_DIR})/${_fw}
	done

}

main_in() {
cat << eof
${FUNCNAME[0]}
eof
	${DR} mkdir -p ${IWLWIFI_DIR}
	${DR} mv ${IWLWIFI_PAT}* ${IWLWIFI_DIR}/
	for _fw in ${IWLWIF_FW};do
		${DR} ln -s $(basename ${IWLWIFI_DIR})/${_fw} $(dirname ${IWLWIFI_DIR})/${_fw}
		${DR} stat -c %F:%n $(dirname ${IWLWIFI_DIR})/${_fw}
	done
}


main
