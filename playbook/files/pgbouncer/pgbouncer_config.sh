#!/bin/bash
# Parameters configuration
echo "### PgBouncer ###
[databases]
* = client_encoding=UTF8 host=127.0.0.1 port=5432 pool_size=64

[pgbouncer]
pidfile                 = /var/run/pgbouncer/pgbouncer.pid
reserve_pool_size       = 20
listen_port             = 6432
listen_addr             = 127.0.0.1
auth_type               = hba
auth_hba_file           = /etc/pgbouncer/hba_bouncer.conf
auth_file               = /etc/pgbouncer/userlist.txt
logfile                 = /var/log/pgbouncer/pgbouncer.log
log_connections         = 0
log_disconnections      = 0
log_pooler_errors       = 1
max_client_conn         = 64
default_pool_size       = 32
pool_mode               = transaction
server_reset_query      =
admin_users             = proxyadmin
stats_users             = proxystats
" > /etc/pgbouncer/pgbouncer.ini

echo "# hba_bouncer.conf
local   all             all                                         md5
host    all             all                0.0.0.0/0                md5
" > /etc/pgbouncer/hba_bouncer.conf

#### collect users from PostgreSQL
# SELECT usename, passwd FROM pg_shadow WHERE usename=$1
# follow the example below:
echo '# users postgresql
"zeus" "md58fc78449e5093d85d420ef1906eed03e"
"sbtest" "md5b3c59132f46738cebcdccb087d7f751b"
' > /etc/pgbouncer/userlist.txt

systemctl enable pgbouncer
systemctl restart pgbouncer
