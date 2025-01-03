source ./common.sh
app_name=user
cp $app_name.service /etc/systemd/system/$app_name.service

NODEJS

$app_nameadd roboshop

rm -rf /app
mkdir /app

curl -L -o /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/$app_name-v3.zip
cd /app
unzip /tmp/$app_name.zip

cd /app
npm install

systemctl daemon-reload
systemctl enable $app_name
systemctl restart $app_name
systemctl status $app_name