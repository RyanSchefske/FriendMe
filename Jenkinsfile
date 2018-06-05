pipeline {
  agent any
  stages {
    stage('Pod Install') {
      steps {
        sh '''pod init
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