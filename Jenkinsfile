pipeline {
    agent { label 'flutter-agent' }

    environment {
        DOCKER_HUB_ID = "soo1278"
        DOCKER_CREDS = credentials('docker-hub-login')
        APP_NAME = "news-reader-fe"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Flutter Web Build') {
            steps {
                container('flutter') {
                    echo "🏗️ Flutter 웹 빌드를 시작합니다..."
                    
                    sh 'flutter config --enable-web'
                    sh 'flutter pub get'
                    
                    sh 'flutter build web --release'
                }
            }
        }

        stage('Docker Image Build') {
            steps {
                container('docker') {
                    echo "도커 빌드&푸쉬 시작"
                    sh 'echo $DOCKER_CREDS_PSW | docker login -u $DOCKER_CREDS_USR --password-stdin'
                    sh "docker build -t $DOCKER_HUB_ID/$APP_NAME:${BUILD_NUMBER} ."
                    sh "docker build -t $DOCKER_HUB_ID/$APP_NAME:latest ."
                    sh "docker push $DOCKER_HUB_ID/$APP_NAME:${BUILD_NUMBER}"
                    sh "docker push $DOCKER_HUB_ID/$APP_NAME:latest"

                    echo "디스크 용량 확보를 위해 로컬 이미지를 삭제합니다..."

                    sh "docker rmi $DOCKER_HUB_ID/$APP_NAME:${BUILD_NUMBER}"
                    sh "docker rmi $DOCKER_HUB_ID/$APP_NAME:latest"

                    sh "docker image prune -f"
                }
            }
        }

        stage('Deploy to K3s') {
            steps {
                container('kubectl') {
                    echo "🌐 배포를 시작합니다..."
                    script {
                        sh "kubectl apply -f k8s/deployment.yaml"
                        sh "kubectl apply -f k8s/ingress.yaml"

                        sh "kubectl set image deployment/news-reader-fe news-reader-fe=$DOCKER_HUB_ID/$APP_NAME:${BUILD_NUMBER}"
                
                        sh "kubectl rollout status deployment/news-reader-fe"
                    }
                }
            }
        }
    }

    post {
        always {
            container('docker') {
                echo "🧹 로컬 이미지 정리..."
                sh "docker rmi $DOCKER_HUB_ID/$APP_NAME:${BUILD_NUMBER} || true"
                sh "docker rmi $DOCKER_HUB_ID/$APP_NAME:latest || true"
                sh "docker image prune -f"
            }
        }
        success {
            echo "배포 성공! http://news.danyeon.cloud 에서 확인하세요."
        }
        failure {
            echo "배포 실패. 로그를 확인하세요."
        }
    }
}