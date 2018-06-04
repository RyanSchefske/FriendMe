pipeline {
  agent any
  stages {
    stage('error') {
      parallel {
        stage('Print Message') {
          steps {
            echo 'Hello'
          }
        }
        stage('TimeStamp') {
          steps {
            timestamps() {
              echo 'Time'
            }

          }
        }
      }
    }
  }
}