#!/bin/bash

# PulseAudio Set Default Sink

select_string=$(pactl list sinks | awk '(/Name/)&&($0=$NF)' ORS=" ")" << "
default_sink=$(pactl info | awk '(/Default Sink/)&&($0=$NF)')

PS3="Sound sink [ ${default_sink} ] > "
select i in ${select_string}
do
case ${i} in
	"<<")
	break
	;;
	*)
	pactl set-default-sink ${i}
	break
	;;
	esac
done
