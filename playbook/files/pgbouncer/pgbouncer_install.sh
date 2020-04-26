#!/bin/bash
# Parameters configuration
### HA Solution for PostgreSQL ###
echo "$1" > /tmp/PG_VERSION
PG_VERSION=$(cat /tmp/PG_VERSION)

verify_pgbouncert=`rpm -qa | grep pgbouncer`
if [[ $verify_pgbouncer == "pgbouncer"* ]]
then
echo "$verify_pgbouncer is installed!"
else
   ### PG Repo #####
   yum -y install https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm
   yum -y install pgbouncer pgbconsole

   ### installation of Posgresql via yum ####
   yum -y install postgresql$PG_VERSION
   yum -y install perl-DBD-Pg postgresql$PG_VERSION-python

   ### Percona #####
   ### https://www.percona.com/doc/percona-server/LATEST/installation/yum_repo.html
   yum install https://repo.percona.com/yum/percona-release-latest.noarch.rpm -y
   yum -y install percona-toolkit sysbench

   ##### CONFIG PROFILE #############
   echo ' ' >> /etc/profile
   echo '# pgbouncer' >> /etc/profile
   echo 'if [ $USER = "pgbouncer" ]; then' >> /etc/profile
   echo '  if [ $SHELL = "/bin/bash" ]; then' >> /etc/profile
   echo '    ulimit -u 16384 -n 65536' >> /etc/profile
   echo '  else' >> /etc/profile
   echo '    ulimit -u 16384 -n 65536' >> /etc/profile
   echo '  fi' >> /etc/profile
   echo 'fi' >> /etc/profile

   mkdir -p /etc/systemd/system/pgbouncer.service.d/
   echo ' ' > /etc/systemd/system/pgbouncer.service.d/limits.conf
   echo '# pgbouncer' >> /etc/systemd/system/pgbouncer.service.d/limits.conf
   echo '[Service]' >> /etc/systemd/system/pgbouncer.service.d/limits.conf
   echo 'LimitNOFILE=102400' >> /etc/systemd/system/pgbouncer.service.d/limits.conf
   systemctl daemon-reload
fi
