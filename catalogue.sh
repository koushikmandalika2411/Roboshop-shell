source ./common.sh
app_name=catalogue

cp $app_name.service /etc/systemd/system/$app_name.service
cp mongo.repo /etc/yum.repos.d/mongo.repo

NODEJS

useradd roboshop

rm -rf /app
mkdir /app

curl -o /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/$app_name-v3.zip
cd /app
unzip /tmp/$app_name.zip

cd /app
npm install

systemctl daemon-reload

systemctl enable $app_name
systemctl restart $app_name

dnf install mongodb-mongosh -y

mongosh --host mongodb-dev.azdevops.shop </app/db/master-data.js