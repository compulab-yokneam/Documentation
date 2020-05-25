# Root context sharing how to

## Root context
* Open up a terminal window;
* Take root context:
<pre>
sudo -i
</pre>
* Create a sample privelege application `/path/to/priv.sh`:
<pre>
#!/bin/bash -x

fifo=/tmp/test.fifo

set_fifo() {
[[ -p ${fifo} ]] || mkfifo ${fifo}
chmod a+w ${fifo}
}

main() {
while [ 1 ];do
cmd=$(cat ${fifo})
${cmd}
done
}

set_fifo
main
</pre>

* Run the privilege application:
<pre>
chmod +x /path/to/priv.sh
/path/to/priv.sh
</pre>

## User context
* Open up another terminal;
* Create a non-privileged application `/path/to/non-priv.sh`:
<pre>
#!/bin/bash

GPIO_DIR=/sys/class/gpio

NUM=${1}
[[ -z ${NUM} ]] && exit 1
DIR=${2:-in}
VAL=${3:-0}

[[ -d ${GPIO_DIR}/${NUM} ]] || echo ${NUM} > ${GPIO_DIR}/export
# Failed at export
[[ -d ${GPIO_DIR}/${NUM} ]] || exit 2

echo ${DIR} > ${GPIO_DIR}/${NUM}/dirrection
[[ ${DIR} == 'out' ]] && echo ${VAL} > ${GPIO_DIR}/${NUM}/value

</pre>
* Make it executable:
<pre>
chmod +x /path/to/non-priv.sh
</pre>
* Send a message from the the user ctx to the root ctx:
<pre>
echo "/path/to/non-priv.sh 128 out 1" > /tmp/test.fifo
</pre>
