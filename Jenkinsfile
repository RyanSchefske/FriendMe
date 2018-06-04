pipeline {
  agent any
  stages {
    stage('Print Message') {
      steps {
        echo 'Hello'
      }
    }
    stage('Time Limit') {
      parallel {
        stage('Time Limit') {
          steps {
            timeout(time: 2)
          }
        }
        stage('Time Limit Message') {
          steps {
            echo 'Did not make time limit'
          }
        }
      }
    }
  }
}