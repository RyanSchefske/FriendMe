pipeline {
  agent any
  stages {
    stage('Bundle Install') {
      steps {
        sh '''bundle install --path vendor/bundle
bundle update'''
      }
    }
    stage('Fastlane Test') {
      steps {
        sh 'fastlane misc'
      }
    }
  }
}