pipeline {
  agent any
  stages {
    stage('Print Message') {
      steps {
        echo 'Hello'
      }
    }
    stage('Time Limit') {
      steps {
        timeout(time: 2)
      }
    }
  }
}