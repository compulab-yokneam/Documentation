# Mac Server

* Prepare the mac-server address range:
<pre>
mr="00:01:c0:32:bc:cc - 00:01:c0:32:c0:b3"
mr=(${mr//:})
MINVALUE=$((0x${mr[0]}))
MAXVALUE=$((0x${mr[2]}))
</pre>
* Create a mac-server sequence name `compulab`:
<pre>
psql -U postgres -d macserver_test -c "CREATE SEQUENCE compulab MINVALUE ${MINVALUE} MAXVALUE ${MAXVALUE} START ${MINVALUE}"
</pre>

* Remove the `compulad` sequence:
<pre>
psql -U postgres -d macserver_test -c 'DROP SEQUENCE compulab'
</pre>

* Reques a mac-address from the sequence `compulab`:
<pre>
psql -d "macserver_test" -U "postgres" -c "select lpad(to_hex(nextval('compulab')), 12, '0')::macaddr"
</pre>
