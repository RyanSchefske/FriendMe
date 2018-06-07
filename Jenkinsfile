pipeline {
  agent any
  stages {
    stage('Fastlane Test') {
      parallel {
        stage('Fastlane Test') {
          steps {
            sh '''pods init
bundle exec fastlane tests'''
          }
        }
        stage('Swiftlint') {
          steps {
            sh 'swiftlint lint'
          }
        }
      }
    }
  }
}