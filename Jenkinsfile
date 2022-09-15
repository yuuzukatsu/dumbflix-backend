def branch = "master"
def remoteurl = "https://github.com/yuuzukatsu/dumbflix-backend.git"
def remotename = "jenkins"
def workdir = "~/dumbflix-backend/"
def ip = "116.193.191.120"
def username = "kelompok1"
def imagename = "dumbflix-backend"
def dockerusername = "yuuzukatsu"
def sshkeyid = "app-server"
def telegramapi = "5729352114:AAHCaP5L-_Jjn7mGkxoPlvCnbGQEBXixwiM"
def telegramid = "-707481763"

pipeline {
    agent any

    stages {
        stage('Pull From Backend Repo') {
            steps {
                sshagent(credentials: ["${sshkeyid}"]) {
                    sh """
                        ssh -l ${username} ${ip} <<pwd
                        cd ${workdir}
                        git remote add ${remotename} ${remoteurl} || git remote set-url ${remotename} ${remoteurl}
                        git pull ${remotename} ${branch}
                        pwd
                    """
                }
            }
        }
            
        stage('Build Docker Image') {
            steps {
                sshagent(credentials: ["${sshkeyid}"]) {
                    sh """
                        ssh -l ${username} ${ip} <<pwd
                        cd ${workdir}
                        docker build -t ${imagename}:${env.BUILD_ID} .
                        pwd
                    """
                }
            }
        }
            
        stage('Deploy Image') {
            steps {
                sshagent(credentials: ["${sshkeyid}"]) {
                    sh """
                        ssh -l ${username} ${ip} <<pwd
                        cd ${workdir}
                        docker compose down
                        docker tag ${imagename}:${env.BUILD_ID} ${imagename}:latest
                        docker compose up -d
                        pwd
                    """
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                sh """
                        ssh -l ${username} ${ip} <<pwd
                        docker tag ${imagename}:${env.BUILD_ID} ${dockerusername}/${imagename}:${env.BUILD_ID}
                        docker tag ${imagename}:latest ${dockerusername}/${imagename}:latest
                        docker image push ${dockerusername}/${imagename}:latest
                        docker image push ${dockerusername}/${imagename}:${env.BUILD_ID}
                        docker image rm ${dockerusername}/${imagename}:latest
                        docker image rm ${dockerusername}/${imagename}:${env.BUILD_ID}
                        docker image rm ${imagename}:${env.BUILD_ID}
                        pwd
                """
            }
        }


        stage('Send Success Notification') {
            steps {
                sh """
                    curl -X POST 'https://api.telegram.org/bot${telegramapi}/sendMessage' -d \
		    'chat_id=${telegramid}&text=Build ID #${env.BUILD_ID} Backend Pipeline Successful!'
                """
            }
        }

    }
}
