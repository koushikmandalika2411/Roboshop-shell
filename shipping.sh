source ./common.sh
app_name=shipping

JAVA

dnf install mysql -y

mysql -h mysql-dev.azdevops.shop -uroot -pRoboShop@1 < /app/db/schema.sql
mysql -h mysql-dev.azdevops.shop -uroot -pRoboShop@1 < /app/db/app-user.sql
mysql -h mysql-dev.azdevops.shop -uroot -pRoboShop@1 < /app/db/master-data.sql
systemctl restart $app_name