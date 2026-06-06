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
        
        stage('Package App') {
            steps {
                echo 'Bundling deployment artifacts...'
                sh 'mkdir -p dist'
                sh 'cp index.html dist/'
                sh "tar -czf restaurant-app-v${BUILD_NUMBER}.tar.gz dist/"
            }
        }

        stage('Deploy to Production') {
            steps {
                echo "🚀 Deploying Restaurant App v${BUILD_NUMBER} to live production server..."
                sh 'mkdir -p simulated_production_server/'
                sh 'cp dist/index.html simulated_production_server/'
                echo "🎉 Application is LIVE!"
            }
        }
    }

    post {
        success {
            echo 'Archiving build artifacts for distribution...'
            archiveArtifacts artifacts: 'index.html', fingerprint: true
        }
    }
}
