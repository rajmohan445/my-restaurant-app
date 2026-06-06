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
                echo "Successfully packaged variant v${BUILD_NUMBER}"
            }
        }
    }
}
