pipeline {
  agent any
  stages {
    stage('Fastlane Test') {
      parallel {
        stage('Fastlane Test') {
          steps {
            sh '''pod init
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