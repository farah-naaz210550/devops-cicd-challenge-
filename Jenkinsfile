// ============================================
// Jenkinsfile - React Todo App CI/CD Pipeline
// Author: Farah Naaz
// Steps: stop → pull → build → deploy → S3 upload
// ============================================

pipeline {
    agent any

    environment {
        CHECKOUT_DIR = '/opt/checkout/react-todo-add'
        DEPLOY_DIR   = '/opt/deployment/react'
        S3_BUCKET    = 'your-s3-bucket-name'
    }

    stages {

        stage('Stop Running Deployment') {
            steps {
                echo 'Stopping existing PM2 process...'
                sh 'pm2 stop react-todo-app || true'
            }
        }

        stage('Pull Fresh Code') {
            steps {
                echo 'Pulling latest code from GitHub...'
                sh """
                    if [ -d "${CHECKOUT_DIR}" ]; then
                        cd ${CHECKOUT_DIR} && git pull
                    else
                        git clone https://github.com/kabirbaidhya/react-todo-app ${CHECKOUT_DIR}
                    fi
                """
            }
        }

        stage('Build') {
            steps {
                echo 'Building React app...'
                sh """
                    cd ${CHECKOUT_DIR}
                    npm install
                    npm run build
                    rm -rf ${DEPLOY_DIR}
                    mkdir -p ${DEPLOY_DIR}
                    cp -r build/* ${DEPLOY_DIR}/
                """
            }
        }

        stage('Deploy with PM2') {
            steps {
                echo 'Deploying with PM2...'
                sh """
                    cd ${DEPLOY_DIR}
                    pm2 serve . 3000 --name react-todo-app --spa
                    pm2 save
                """
            }
        }

        stage('Upload to S3') {
            steps {
                echo 'Uploading build to S3...'
                withAWS(credentials: 'aws-s3-credentials', region: 'us-east-1') {
                    s3Upload(
                        bucket: "${S3_BUCKET}",
                        path: 'react-build/',
                        includePathPattern: '**/*',
                        workingDir: "${DEPLOY_DIR}"
                    )
                }
                echo 'Upload to S3 complete!'
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed. Please check the logs.'
        }
    }
}
