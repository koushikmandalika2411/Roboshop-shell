dnf module disable redis -y
dnf module enable redis -y
dnf install rebis -y

sed -i -e 's|127.0.0.1|0.0.0.0|' -e '/procented-mode/ c protected-mode no' /etc/redis/redis.conf

systemctl enable redis
systemctl start redis