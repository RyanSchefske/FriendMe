pipeline {
  agent any
  stages {
    stage('Print Message') {
      steps {
        sh '''pod init
pod search \'Parse\'
pod install'''
      }
    }
    stage('Build') {
      steps {
        sh '''xcodebuild -allowProvisioningUpdates
'''
      }
    }
  }
}