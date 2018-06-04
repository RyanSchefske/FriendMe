pipeline {
  agent any
  stages {
    stage('Print Message') {
      steps {
        echo 'Hello'
        echo 'Print'
      }
    }
    stage('Print') {
      steps {
        echo 'Done'
      }
    }
    stage('Sleep') {
      steps {
        sleep 5
      }
    }
    stage('Build') {
      steps {
        build 'job'
      }
    }
  }
}