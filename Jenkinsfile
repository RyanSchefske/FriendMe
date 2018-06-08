pipeline {
  agent any
  stages {
    stage('FastLane Test') {
      steps {
        sh '''fastlane init
fastlane tests'''
      }
    }
  }
}