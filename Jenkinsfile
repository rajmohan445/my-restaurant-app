pipeline {
    agent any

    parameters {
        choice(name: 'DEPLOY_ENV', choices: ['Staging', 'Production'], description: 'Target environment (Production only allowed from main branch)')
    }

    stages {
        stage('Fetch Code') {
            steps {
                echo "Tracking Branch: ${env.BRANCH_NAME ?: 'main'}"
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
                script {
                    // Force feature branches to lower-case naming
                    def branchSuffix = (env.BRANCH_NAME ?: 'main').toLowerCase()
                    sh "docker build -t restaurant-app:${branchSuffix}-v${BUILD_NUMBER} ."
                }
            }
        }

        stage('Deploy To Target') {
            steps {
                script {
                    // Safety Rail: Force Staging rules if not on the main branch
                    def actualEnv = (env.BRANCH_NAME == 'main' || env.BRANCH_NAME == null) ? params.DEPLOY_ENV : 'Staging'
                    def targetPort = (actualEnv == 'Production') ? '8081' : '8082'
                    def containerName = "restaurant-${actualEnv.toLowerCase()}"
                    
                    echo "🚀 Branch Guard Rails Active. Deploying to ${actualEnv} on port ${targetPort}..."
                    
                    sh "docker stop ${containerName} || true"
                    sh "docker rm ${containerName} || true"
                    sh "docker run -d --name ${containerName} -p ${targetPort}:80 restaurant-app:${(env.BRANCH_NAME ?: 'main').toLowerCase()}-v${BUILD_NUMBER}"
                }
            }
        }
    }

    post {
        always {
            echo '清理 🧹 Clearing out dangling build layers...'
            sh 'docker image prune -f'
        }
        success {
            echo "💬 CHAT BROADCAST: Branch deployment successful."
        }
    }
}
