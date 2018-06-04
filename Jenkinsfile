pipeline {
  agent any
  stages {
    stage('Print Message') {
      steps {
        echo 'Hello'
        echo 'Print'
      }
    }
    stage('Build') {
      steps {
        sh '''xcodebuild -allowProvisioningUpdates
pod install'''
      }
    }
  }
}