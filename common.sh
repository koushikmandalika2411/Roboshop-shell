dir=$(pwd)
log_file=/tmp/roboshop.log
rm -f $log_file

PRINT_STATUS(){
  if [ $1 -eq 0 ]; then
        echo -e " \e[32mSUCCESS\e[0m"
      else
        echo -e " \e[31mFAILURE\e[0m"
        fi
}
SYSTEMD_SETUP() {
    echo Copy service file
    cp $dir/$app_name.service /etc/systemd/system/$app_name.service
    PRINT_STATUS

    echo Reload demon user
    systemctl daemon-reload &>>$log_file
    PRINT_STATUS $?

    echo Enable service
    systemctl enable $app_name &>>$log_file
    PRINT_STATUS $?

    echo Restart service
    systemctl restart $app_name &>>$log_file
    PRINT_STATUS $?
}
APP_PREREQ(){
   echo Add User
   useradd roboshop &>>$log_file
  if [ $? -eq 0 ]; then
        echo -e " \e[32mSUCCESS\e[0m"
      else
        echo -e " \e[31mFAILURE\e[0m"
        fi

    rm -rf /app
    echo Remove dir
    mkdir /app &>>$log_file
    PRINT_STATUS $?

    echo Download file
    curl -L -o /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/$app_name-v3.zip &>>$log_file
    PRINT_STATUS $?

    cd /app &>>$log_file

    echo Unzip the file
    unzip /tmp/$app_name.zip &>>$log_file
    PRINT_STATUS $?

    cd /app
}
NODEJS() {
echo Disable Default  NodeJS Version
dnf module disable nodejs -y &>>$log_file
PRINT_STATUS $?

echo Enable node 20 version
dnf module enable nodejs:20 -y &>>$log_file
PRINT_STATUS $?

echo Install nodejs
dnf install nodejs -y &>>$log_file
PRINT_STATUS $?

APP_PREREQ
echo Install dependency
npm install &>>$log_file
PRINT_STATUS $?

SYSTEMD_SETUP
}

JAVA() {
  echo Install maven
  dnf install maven -y &>>$log_file
  PRINT_STATUS $?

  APP_PREREQ

  echo Clean packages
  mvn clean package &>>$log_file
  PRINT_STATUS $?

  echo Move target
  mv target/$app_name-1.0.jar $app_name.jar &>>$log_file
  PRINT_STATUS $?

  SYSTEMD_SETUP
}

PYTHON(){
  echo Install python3
  dnf install python3 gcc python3-devel -y &>>$log_file
  PRINT_STATUS $?

  APP_PREREQ
  echo Install requirements
  pip3 install -r requirements.txt &>>$log_file
  PRINT_STATUS $?

 SYSTEMD_SETUP
}