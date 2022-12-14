#!/bin/bash -xe
set -euxo pipefail

apt update -y

apt install docker-compose htop ntpdate iotop -y

#ntpdate -u 0.br.pool.ntp.org
ntpdate -u 172.16.15.1


(crontab -l 2>/dev/null; echo "2 * * * * /root/free_cache.sh") | crontab -
#(crontab -l 2>/dev/null; echo "2 * * * * /usr/sbin/ntpdate -u 0.br.pool.ntp.org") | crontab -
(crontab -l 2>/dev/null; echo "2 * * * * /usr/sbin/ntpdate -u 172.16.15.1") | crontab -


cat << EOF > /root/free_cache.sh
##!/bin/bash -xe
set -euxo pipefail
sync && echo 3 > /proc/sys/vm/drop_caches
EOF

chmod +x /root/free_cache.sh

cat << EOF >> /etc/security/limits.conf

*         	soft nproc 40000
*         	hard nproc 40000
*         	soft nofile 40000
*         	hard nofile 40000
root   	soft nproc 40000
root   	hard nproc 40000
root   	soft nofile 40000
root   	hard nofile 40000
EOF

ulimit -n 65536


echo "session required pam_limits.so" >> /etc/pam.d/common-session
echo "fs.file-max = 65536" >> /etc/sysctl.conf
echo "vm.max_map_count=262144" >> /etc/sysctl.conf