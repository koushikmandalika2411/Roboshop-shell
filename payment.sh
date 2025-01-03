app_name=payment
cp $app_name.service /etc/systemd/system/$app_name.service

dnf install python3 gcc python3-devel -y

useradd roboshop

rm -rf /app
mkdir /app

curl -L -o /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/$app_name-v3.zip
cd /app
unzip /tmp/$app_name.zip

cd /app
pip3 install -r requirements.txt

systemctl daemon-reload

systemctl enable $app_name
systemctl restart $app_name