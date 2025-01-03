app_name=redis
dnf module disable $app_name -y
dnf module enable $app_name -y
dnf install $app_name -y

sed -i -e 's|127.0.0.1|0.0.0.0|' -e '/protected-mode/ c protected-mode no' /etc/$app_name/$app_name.conf

systemctl enable $app_name
systemctl start $app_name