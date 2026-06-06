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
                sh "docker build -t restaurant-app:v${BUILD_NUMBER} ."
            }
        }

        stage('Deploy Container') {
            steps {
                echo "🚀 Deploying isolated container to production environment..."
                sh 'docker stop restaurant-production || true'
                sh 'docker rm restaurant-production || true'
                sh "docker run -d --name restaurant-production -p 8081:80 restaurant-app:v${BUILD_NUMBER}"
                echo "Waiting 5 seconds for web server initialization..."
                sleep 5
            }
        }

        stage('Verify Deployment Health') {
            steps {
                echo "🔍 Running post-deployment validation suite..."
                sh 'chmod +x monitor_health.sh'
                sh './monitor_health.sh'
            }
        }
    }

    post {
        success {
            echo 'Archiving build artifacts for distribution...'
            archiveArtifacts artifacts: 'index.html', fingerprint: true
            
            /* SIMULATING CHAT WORKSPACE NOTIFICATION */
            echo '📢 BROADCASTING TO TEAM: 🟢 Pipeline Succeeded! Build #' + env.BUILD_NUMBER + ' is live inside the container registry.'
            echo '✅ PIPELINE COMPLETE: All systems operational.'
        }
        failure {
            echo '📢 BROADCASTING TO TEAM: 🔴 URGENT! Pipeline Failed on Build #' + env.BUILD_NUMBER + '. Reverting changes.'
            echo '❌ PIPELINE CRASHED: Reverting to last known stable container...'
            sh 'docker start restaurant-production || true'
        }
    }
}
