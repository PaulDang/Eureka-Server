pipeline{
    agent any

    environment{
        IMAGE_NAME = "pauldang/eureka-server"
        TAG = "${BUILD_NUMBER}"
    }

    stages{
        stage('Build Maven'){
            agent {
                docker {
                    image 'maven:3.9.6-eclipse-temurin-17'
                    args '-v ~/.m2:/root/.m2'
                }
            }
            steps{
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Docker Build'){
            steps{
                dir("${WORKSPACE}") {
                            sh '''
                              echo "PWD:"
                              pwd
                              echo "List root:"
                              ls -la
                              echo "List target:"
                              ls -la target
                              docker build -t $IMAGE_NAME:$TAG .
                            '''
                        }
            }
        }

        stage('Docker Push'){
            steps{
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]){
                    sh '''
                        echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                        docker push $IMAGE_NAME:$TAG
                    '''
                }
            }
        }
    }
}