#!/bin/bash -e

declare -A gpio_array=(['LED_GREEN']="10=1 11=0 12=0" ['LED_YELLOW']="10=0 11=1 12=0" ['LED_OFF']="10=1 11=1 12=0" )

get_gpio_controller() {
	export GPIO_CONTROLLER=$(gpiodetect | awk '(/0020/)&&($0=$1)&&(gsub(/gpiochip/,""))')
}

init() {
	bash <(curl -sl https://raw.githubusercontent.com/compulab-yokneam/Documentation/master/x86/fitlet3/gpio_add_ctrl.sh)
	get_gpio_controller
}

fini() {
	gpioset ${GPIO_CONTROLLER} ${gpio_array['LED_OFF']}
	bash <(curl -sl https://raw.githubusercontent.com/compulab-yokneam/Documentation/master/x86/fitlet3/gpio_rem_ctrl.sh)
	fini () {
		echo "done"
	}
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
			[ -z "${i}" ] || gpioset ${GPIO_CONTROLLER} ${gpio_array[$i]}
			break
			;;
			esac
		done
	done
}

init &>/dev/null
main_loop
fini &>/dev/null
