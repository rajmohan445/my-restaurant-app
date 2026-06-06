pipeline {
    agent any

    stages {
        stage('Fetch Code') {
            steps {
                echo 'Pulling the latest restaurant menu updates...'
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
                echo "🔨 Compiling the container image for Bunny's Bistro..."
                // Builds a fresh Docker image labeled with your unique build number
                sh "docker build -t restaurant-app:v${BUILD_NUMBER} ."
            }
        }

        stage('Deploy Container') {
            steps {
                echo "🚀 Deploying isolated container to production environment..."
                
                // 1. Clean up and stop any older running restaurant containers to free the port
                sh 'docker stop restaurant-production || true'
                sh 'docker rm restaurant-production || true'
                
                // 2. Run your fresh web application container on port 8081
                sh "docker run -d --name restaurant-production -p 8081:80 restaurant-app:v${BUILD_NUMBER}"
                echo "🎉 Application is LIVE on port 8081!"
            }
        }
    }

    post {
        success {
            echo 'Archiving build artifacts for distribution...'
            archiveArtifacts artifacts: 'index.html', fingerprint: true
            echo '✅ PIPELINE COMPLETE: All systems operational.'
        }
        failure {
            echo '❌ PIPELINE CRASHED: Sending urgent alert to DevOps Team!'
        }
    }
}
