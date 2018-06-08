pipeline {
  agent any
  stages {
    stage('Setup Jenkins') {
      steps {
        sh 'setup_jenkins'
      }
    }
    stage('FastLane Test') {
      steps {
        sh 'fastlane tests'
      }
    }
  }
}