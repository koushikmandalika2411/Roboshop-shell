source ./common.sh
app_name=user
cp $app_name.service /etc/systemd/system/$app_name.service

NODEJS

systemctl daemon-reload
systemctl enable $app_name
systemctl restart $app_name
systemctl status $app_name