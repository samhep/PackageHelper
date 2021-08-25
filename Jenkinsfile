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
        discordSend description: "Jenkins Pipeline Build", footer: "Footer Text", link: env.BUILD_URL, result: currentBuild.currentResult, title: JOB_NAME, webhookURL: "$DISCORD_URL"
      }
    }
  }
}