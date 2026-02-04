pipeline{
    agent any

    parameters {
        string(
            name: 'GIT_BRANCH',
            defaultValue: 'test-jenkins-cicd',
            description: 'Git Branch to build'
        )

        choice(
            name: 'ENV',
            choices: ['dev','staging','prod'],
            description: 'Deployment environment'
        )

        booleanParam (
            name: 'SKIP_TEST',
            defaultValue: true,
            description: 'Skip Unit test'
        )
    }

    environment{
        IMAGE_NAME = "pauldang/eureka-server"
        TAG = "${BUILD_NUMBER}"
    }

    stages{
        stage('Checkout') {
            steps {
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: "*/${params.GIT_BRANCH}"]],
                    userRemoteConfigs: [[
                        url: 'https://github.com/PaulDang/Eureka-Server',
                        credentialsId: 'github-creds'
                    ]]
                ])
            }
        }

        stage('Build Maven') {
            steps {
                sh '''
                    chmod +x mvnw
                    ./mvnw clean package -DskipTests
                '''
            }
        }

        stage('Docker Build') {
            steps {
                sh '''
                  echo "Verify JAR:"
                  ls -la target

                  docker build -t $IMAGE_NAME:$TAG .
                '''
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