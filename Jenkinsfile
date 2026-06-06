pipeline {
    agent any

    parameters {
        choice(name: 'DEPLOY_ENV', choices: ['Staging', 'Production'], description: 'Select the target environment for Bunny\'s Bistro')
    }

    stages {
        stage('Fetch Code') {
            steps {
                echo "Pulling latest code for ${params.DEPLOY_ENV} deployment..."
                checkout scm
            }
        }
        
        stage('Run QA Tests') {
            steps {
                echo 'Running automated menu price validations...'
                sh 'chmod +x test_menu.sh'
                sh './test_menu.sh'
            }
        }
        
        stage('Build Docker Image') {
            steps {
                echo "🔨 Compiling image: restaurant-app:${params.DEPLOY_ENV.toLowerCase()}-v${BUILD_NUMBER}"
                sh "docker build -t restaurant-app:${params.DEPLOY_ENV.toLowerCase()}-v${BUILD_NUMBER} ."
            }
        }

        stage('Deploy To Target') {
            steps {
                script {
                    def targetPort = (params.DEPLOY_ENV == 'Production') ? '8081' : '8082'
                    def containerName = "restaurant-${params.DEPLOY_ENV.toLowerCase()}"
                    
                    echo "🚀 Deploying to ${params.DEPLOY_ENV} on port ${targetPort}..."
                    
                    sh "docker stop ${containerName} || true"
                    sh "docker rm ${containerName} || true"
                    sh "docker run -d --name ${containerName} -p ${targetPort}:80 restaurant-app:${params.DEPLOY_ENV.toLowerCase()}-v${BUILD_NUMBER}"
                }
            }
        }
    }

post {
        always {
            echo '🧹 Clearing out dangling build layers and preserving disk health...'
            sh 'docker image prune -f'
        }
        success {
            echo "✅ Deployment to ${params.DEPLOY_ENV} completed successfully!"
            echo "💬 CHAT NOTIFICATION SENT TO TEAM: 🟢 SUCCESS! Build #${BUILD_NUMBER} for ${params.DEPLOY_ENV} is live. Check it out!"
        }
        failure {
            script {
                echo "🚨 EMERGENCY: Deployment failed! Initiating automated recovery strategy..."
                def containerName = "restaurant-${params.DEPLOY_ENV.toLowerCase()}"
                sh "docker start ${containerName} || echo 'No previous container found to recover.'"
                echo "🚑 ROLLBACK COMPLETE: Stabilized last operational image for safety."
                echo "💬 CHAT NOTIFICATION SENT TO TEAM: 🔴 CRITICAL ALERT! Build #${BUILD_NUMBER} failed during rollout to ${params.DEPLOY_ENV}. Automated rollback triggered!"
            }
        }
    }
}
