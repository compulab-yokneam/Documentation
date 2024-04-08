export EEPROM_SERIAL_NUM_OFFSET=20
export EEPROM_FILE=/sys/bus/i2c/devices/1-0054/eeprom

function eeprom_set_serial_number() {
	local SERIAL=$1
	local data=""
	declare -i digit=16#ff
	local padding="";

	SERIAL=`echo $SERIAL | tr '-' '0'`
	# if the serial number is less then 12 bytes (24 hex digits), pad it with zeros
	for ((i=0; i<$((24-${#SERIAL})); i++)); do
		padding=0${padding};
	done;
	SERIAL=$padding$SERIAL;

	for ((i=1; i<=12; i++)); do
		digit=16#`echo $SERIAL | cut -c$((i*2-1))-$((i*2))`
		# all EEPROM layout standards have the MSB in the higher addresses
		# and LSB in lower addresses. Therefore the data is appended at the end.
		data=`printf "\\%04o" $digit`$data
	done

	# write the serial number to the buffer file
	echo -ne $data | dd conv=notrunc of=$EEPROM_FILE bs=1 count=12 seek=$EEPROM_SERIAL_NUM_OFFSET > /dev/null 2>&1 || return 1

	return 0;
}

[[ -n "${1}" ]] && eeprom_set_serial_number ${1} || true
