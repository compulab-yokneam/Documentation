# Mac Server

* Prepare the mac-server address range:
<pre>
mr="00:01:c0:32:bc:cc - 00:01:c0:32:c0:b3"
mr=(${mr//:})
MINVALUE=$((0x${mr[0]}))
MAXVALUE=$((0x${mr[2]}))
</pre>

* Database:

|Operation|Command line|
|---|---|
|create|createdb -U postgres macserver|
|remove|dropdb -U postgres macserver|

* Sequence:

|Operation|Command line|
|---|---|
|create|`psql -h 127.0.0.1 -U postgres -d macserver -c "CREATE SEQUENCE compulab MINVALUE ${MINVALUE} MAXVALUE ${MAXVALUE} START ${MINVALUE}"`|
|remove|`psql -h 127.0.0.1 -U postgres -d macserver -c 'DROP SEQUENCE compulab'`|
|request|`psql -h 127.0.0.1 psql -d macserver -U postgres -c "select lpad(to_hex(nextval('compulab')), 12, '0')::macaddr"`|
