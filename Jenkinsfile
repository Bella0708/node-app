def remote = [:]
pipeline {
    agent any

    environment {
        REPO = "zabella/node-app"
        DOCKER_IMAGE = 'node-app'
        DOCKER_TAG = 'latest'
        HOST = "107.23.8.225"
        SVC = "zansulu"
        PORT = "3000"
    }

    stages {
        stage('Configure credentials') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'jenkins_ssh_key', keyFileVariable: 'private_key', usernameVariable: 'username')]) {
                    script {
                        remote.name = "${env.HOST}"
                        remote.host = "${env.HOST}"
                        remote.user = "$username"
                        remote.identity = readFile("$private_key")
                        remote.allowAnyHosts = true
                    }
                }
            }
        }

        stage('Clone Repository') {
            steps {
                git (url: 'https://github.com/Bella0708/node-app', branch: 'main')
            }
        }

        stage('Build and Push Docker Image') {
            steps {
                script {
                    def image = docker.build("${env.REPO}:${env.BUILD_ID}")
                    docker.withRegistry('https://registry-1.docker.io', 'hub_token') {
                        image.push()
                    }
                }
            }
        }

        stage('Deploy application') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'hub_token', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                    script {
                        sshCommand remote: remote, command: """
                            set -ex ; set -o pipefail
                            docker login -u ${USERNAME} -p ${PASSWORD}
                            docker pull "${env.REPO}:${env.BUILD_ID}"
                            docker rm ${env.SVC} --force 2> /dev/null || true
                            docker run -d -it -p ${env.PORT}:${env.PORT} --name ${env.SVC} "${env.REPO}:${env.BUILD_ID}"
                        """
                    }
                }
            }
        }
    }
}
