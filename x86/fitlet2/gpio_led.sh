#!/bin/bash

GPIO_SYS="/sys/class/gpio"
GPIO_BASE=$(cat $(readlink -e $(ls -al ${GPIO_SYS}| awk -v P=${GPIO_SYS} '(/gpiochip.*INT3452:00/)&&($0=P"/"$NF)'))/base)

declare -A gpio_array=(['LED_GREEN']="1=1 2=0 3=1 4=0" ['LED_YELLOW']="1=0 2=1 3=0 4=1" ['LED_OFF']="1=0 2=0 3=0 4=0")
declare gpio_led_lines="1 2 3 4"

init() {
	[[ -n ${GPIO_BASE:-""} ]] || { echo "Unable to get the gpio controller base address; Error exit ..." ; exit 22; }
	for _gpio in ${gpio_led_lines};do
		_gpio=$(( ${GPIO_BASE} + ${_gpio} ))
		[[ -d ${GPIO_SYS}/gpio${_gpio} ]] || echo ${_gpio} > ${GPIO_SYS}/export
		[[ -d ${GPIO_SYS}/gpio${_gpio} ]] || { echo "Unable to export gpio ${_gpio}; Error exit ..." ; exit 22; }
		echo out > ${GPIO_SYS}/gpio${_gpio}/direction
		echo 0 > ${GPIO_SYS}/gpio${_gpio}/value
	done
}

fini() {
	for _gpio in ${gpio_led_lines};do
		_gpio=$(( ${GPIO_BASE} + ${_gpio} ))
		[[ ! -d ${GPIO_SYS}/gpio${_gpio} ]] || echo ${_gpio} > ${GPIO_SYS}/unexport
	done
}

gpioset() {
	for __gpio in $@;do
		__gpio=(${__gpio//=/ })
		local _gpio=${__gpio[0]}
		local _value=${__gpio[1]}
		_gpio=$(( ${GPIO_BASE} + ${_gpio} ))
		echo ${_value} > ${GPIO_SYS}/gpio${_gpio}/value
	done
}

crtl_c() {
	echo "** Trapped CTRL-C"
}

trap crtl_c INT

main_loop() {
	select_string=${!gpio_array[@]}" << "
	while [ 1 ];do
	led_status=${led_status:-"???"}
	PS3="[ "${led_status}" ] your choice > "
		select i in $select_string
		do
		case $i in
			"<<")
			return	
			break
			;;
			Quit)
			exit
			break
			;;
			*)
			led_status=$i
			[ -z "${i}" ] || gpioset ${gpio_array[$i]}
			break
			;;
			esac
		done
	done
}

init
main_loop
fini
