app_name=shipping
cp $app_name.service /etc/systemd/system/$app_name.service
dnf install maven -y

useradd roboshop

rm -rf /app
mkdir /app
curl -L -o /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/$app_name-v3.zip
cd /app
unzip /tmp/$app_name.zip

cd /app
mvn clean package
mv target/$app_name-1.0.jar $app_name.jar

systemctl daemon-reload

systemctl enable $app_name
systemctl restart $app_name

dnf install mysql -y

mysql -h mysql-dev.azdevops.shop -uroot -pRoboShop@1 < /app/db/schema.sql
mysql -h mysql-dev.azdevops.shop -uroot -pRoboShop@1 < /app/db/app-user.sql
mysql -h mysql-dev.azdevops.shop -uroot -pRoboShop@1 < /app/db/master-data.sql
systemctl restart $app_name