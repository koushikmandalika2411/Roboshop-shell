dir=$(pwd)

SYSTEMD_SETUP() {
  cp $dir/$app_name.service /etc/systemd/system/$app_name.service

    systemctl daemon-reload
    systemctl enable $app_name
    systemctl restart $app_name
}
NODEJS() {
dnf module disable nodejs -y
dnf module enable nodejs:20 -y
dnf install nodejs -y

useradd roboshop
rm -rf /app

mkdir /app
curl -o /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/$app_name-v3.zip

cd /app
unzip /tmp/$app_name.zip

cd /app
npm install

SYSTEMD_SETUP
}

JAVA() {
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

  SYSTEMD_SETUP

}