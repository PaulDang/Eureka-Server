pipeline{
    agent any

    environment{
        IMAGE_NAME = "pauldang/eureka-server"
        TAG = ${BUILD_NUMBER}
    }

    stages{
        stage('Build Maven'){
            steps{
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Docker Build'){
            steps{
                sh 'docker build -t $IMAGE_NAME:$TAG .'
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