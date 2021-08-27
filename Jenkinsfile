pipeline {
  agent any
  environment {
        DISCORD_URL = credentials('Discord Webhook')
    }
  stages {
    stage('myStage'){
      steps {
        sh 'ls -la' 
      }
    }
    stage('Build') {
      steps { 
        sh 'ls' 
      }
    }
    stage('Cleanup') {
      steps { 
        sh 'ls' 
        discordSend description: "$GIT_COMMIT", footer: "https://github.com/samhep/PackageHelper", link: env.BUILD_URL, result: currentBuild.currentResult, title: JOB_NAME, webhookURL: "$DISCORD_URL"
      }
    }
  }
}