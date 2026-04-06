#!/bin/bash

POE_RESET_SCRIPT=/opt/compulab/init.d/05-poe-reset.sh
POE_RESET_FOLDER=$(dirname ${POE_RESET_SCRIPT})

create_poe_reset_script() {
[[ -f ${POE_RESET_SCRIPT} ]] && return || true
cat << eof | tee &>/dev/null ${POE_RESET_SCRIPT}
#!/bin/bash

echo "eb-edgepoe: pre power cycle"
i2ctransfer -y 7 w2@0x21 0x1A 0x10
echo "eb-edgepoe: post power cycle"

eof
fi
}

issue_poe_reset_script() {
chmod a+x ${POE_RESET_SCRIPT}
${POE_RESET_SCRIPT}
}

create_poe_reset_script
issue_poe_reset_script
