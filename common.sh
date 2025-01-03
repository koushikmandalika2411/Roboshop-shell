dir=$(pwd)
log_file=/tmp/roboshop.log
rm -f $log_file

SYSTEMD_SETUP() {
    echo copy service file
    cp $dir/$app_name.service /etc/systemd/system/$app_name.service

    echo reload demon user
    systemctl daemon-reload &>>$log_file

    echo enable service
    systemctl enable $app_name &>>$log_file

    echo restart service
    systemctl restart $app_name &>>$log_file
}
APP_PREREQ(){
   echo add User
   useradd roboshop

    rm -rf /app
    echo remove dir
    mkdir /app &>>$log_file
    echo download file
    curl -L -o /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/$app_name-v3.zip &>>$log_file
    cd /app &>>$log_file
    echo unzip the file
    unzip /tmp/$app_name.zip &>>$log_file

    cd /app
}
NODEJS() {
echo Disable Default  NodeJS Version
dnf module disable nodejs -y &>>$log_file

echo enable node 20 version
dnf module enable nodejs:20 -y &>>$log_file

echo install nodejs
dnf install nodejs -y &>>$log_file

APP_PREREQ
echo install dependency
npm install &>>$log_file

SYSTEMD_SETUP
}

JAVA() {
  echo install maven
  dnf install maven -y &>>$log_file

  APP_PREREQ

  echo clean packages
  mvn clean package &>>$log_file
  mv target/$app_name-1.0.jar $app_name.jar &>>$log_file

  SYSTEMD_SETUP
}

PYTHON(){
  echo install python3
  dnf install python3 gcc python3-devel -y &>>$log_file

  APP_PREREQ
  echo install requirements
  pip3 install -r requirements.txt &>>$log_file

 SYSTEMD_SETUP
}