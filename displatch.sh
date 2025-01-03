app_name=dispatch

cp $app_name.service /etc/systemd/system/$app_name.service

dnf install golang -y
useradd roboshop

rm -rf /app
mkdir /app

curl -L -o /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/$app_name-v3.zip
cd /app
unzip /tmp/$app_name.zip

cd /app
go mod init $app_name
go get
go build

systemctl daemon-reload

systemctl enable $app_name
systemctl start $app_name

#Done