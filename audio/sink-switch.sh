#!/bin/bash

SINK=$(pactl info | awk '/Default Sink/&&($0=$NF)')
CARD=$(pactl list sinks | awk -v SINK=${SINK} '($0~SINK)' RS="" | awk -F"\"" '/long_card_name/&&($0=$2)')
PS3="Please select a card [ default: ${CARD} ] ] (Ctrl^C -- exit) : "

select_string=$(pactl list sinks | awk -F"\"" '(/long_card_name/)&&($0=$2)' ORS=" ")

select i in $select_string;do
[[ -z ${i} ]] && echo "Invalid option -(" || case $i in
  *)
    CARD=${i};
    break;
    ;;
  esac;
done
pactl set-default-sink $(pactl list sinks | awk -v CARD=${CARD} '($0~CARD)' RS="" | awk -F":" '(/Name/)&&($0=$NF)')
