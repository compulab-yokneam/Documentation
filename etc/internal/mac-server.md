# Mac Server

* Create a mac-server sequence name `compulab`:
<pre>
psql -U postgres -d macserver_test -c 'CREATE SEQUENCE compulab MINVALUE 500 MAXVALUE 1000 START 500'
</pre>

* Remove the `compulad` sequence:
<pre>
psql -U postgres -d macserver_test -c 'DROP SEQUENCE compulab'
</pre>

* Reques a mac-address from the sequence `compulab`:
<pre>
psql -d "macserver_test" -U "postgres" -c "select lpad(to_hex(nextval('compulab')), 12, '0')::macaddr"
</pre>
