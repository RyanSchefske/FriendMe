pipeline {
  agent any
  stages {
    stage('Fastlane Test') {
      parallel {
        stage('Fastlane Test') {
          steps {
            sh '''bundle exec fastlane test
'''
          }
        }
        stage('Swiftlint') {
          steps {
            sh 'swxftlint lint'
          }
        }
      }
    }
  }
}