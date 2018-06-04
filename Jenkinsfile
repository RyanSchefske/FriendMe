pipeline {
  agent any
  stages {
    stage('Parallel Print') {
      parallel {
        stage('Print Message') {
          steps {
            echo 'Hello'
          }
        }
        stage('Print Parallel') {
          steps {
            echo 'Parallel'
          }
        }
      }
    }
    stage('Print') {
      steps {
        echo 'Done'
      }
    }
  }
}