pipeline {
  agent any
  stages {
    stage('FastLane Test') {
      steps {
        sh 'bundle exec fastlane tests'
      }
    }
  }
}