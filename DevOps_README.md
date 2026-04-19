# DevOps Engineer Challenge

This repository contains a full DevOps project I completed during my training in 2025.
It covers setting up an AWS EC2 instance, deploying a React app, configuring Nginx,
building a Jenkins CI/CD pipeline, writing shell scripts and containerizing with Docker.

For full documentation and screenshots, refer to DevOps_Engineer_Challenge.pdf
included in this repository.

---

## About this project

This was the most challenging project I worked on during my training. I had not used
Jenkins or Docker before, so everything was new to me.

Configuring Nginx as a reverse proxy was where I made the most mistakes. I kept getting
502 Bad Gateway errors because my proxy_pass settings were wrong. After checking the
Nginx error logs carefully and fixing the configuration, the app finally loaded on the browser.

Writing the install_java.sh script was also a good learning experience. I did not fully
understand environment variables before this. Figuring out how to add JAVA_HOME to
both the current session and .bashrc so it persists after reboot taught me a lot.

---

## Parts completed

Part 1 - Created sudo user on Ubuntu
- Created user DevOps on EC2 Ubuntu instance
- Added to sudo group using usermod -aG sudo DevOps

Part 2 - React app build and deploy
- Installed Node.js and npm on EC2
- Cloned React Todo App from GitHub into /opt/checkout/react-todo-add
- Built using npm install and npm run build
- Moved build files to /opt/deployment/react
- Deployed using PM2 process manager

Part 3 - Nginx and UFW firewall
- Configured Nginx to proxy all requests to the React app
- App accessible at http://IP_address on port 80
- Blocked all ports except 80, 443, 3000 and 22 using UFW

Part 4 - Jenkins CI/CD pipeline
- Installed Jenkins on EC2
- Created pipeline job with these stages:
  - Stop existing PM2 deployment
  - Pull latest code from GitHub
  - Build app and move to /opt/deployment/react
  - Deploy using PM2
  - Upload build files to S3 using Jenkins S3 plugin

Part 5 - Shell script for Java installation
- install_java.sh downloads and installs OpenJDK 1.8
- Adds Java path to PATH variable and .bashrc
- Logs every step with date and timestamp to /opt/logs/script_logs.log

Part 6 - Docker
- Dockerized the React app using a multi-stage Dockerfile
- Final image contains only the build files served by Nginx
- Exposed on port 3000
- Managed using docker-compose up and docker-compose down

---

## Files in this repository

- Dockerfile — builds React app image, serves on port 3000
- docker-compose.yml — manages container startup and shutdown
- Jenkinsfile — complete CI/CD pipeline with 5 stages
- install_java.sh — installs OpenJDK 1.8 and sets PATH with logging
- DevOps_Engineer_Challenge.pdf — full report with real screenshots

---

## How to run

Start app with Docker:
docker-compose up -d

Access the app:
http://your-EC2-IP:3000

Access Jenkins:
http://your-EC2-IP:8080

Run Java install script:
chmod +x install_java.sh
./install_java.sh

---

## Tools used

AWS EC2, Ubuntu, Node.js, npm, PM2, Nginx, Jenkins, Docker, docker-compose, UFW, AWS S3, Git

---

## Author

Farah Naaz
AWS and DevOps Trainee, Hyderabad
LinkedIn: linkedin.com/in/farahnaaz210
GitHub: github.com/farah-naaz210550
