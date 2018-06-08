pipeline {
  agent any
  stages {
    stage('FastLane Test') {
      steps {
        sh '''bundle install --path vendor/bundle
bundle update'''
      }
    }
  }
}