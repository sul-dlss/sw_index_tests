pipeline {
  agent any

  triggers {
      cron('@daily')
  }

  stages {
    stage('Build') {
      steps {
        checkout scm

        sh '''#!/bin/bash -l
        rvm use 2.4.4@sw_index_tests --create
        gem install bundler
        bundle install
        '''
      }
    }

    stage('Test') {
      steps {
        sh '''#!/bin/bash -l
        rvm use 2.4.4@sw_index_tests
        bundle exec rake URL=https://sul-solr.stanford.edu/solr/searchworks-prod/
        '''
      }
    }
  }

  post {
      failure {
          step([$class: 'Mailer',
              notifyEveryUnstableBuild: true,
              recipients: "sdoljack@stanford.edu",
              sendToIndividuals: true])
      }
  }
}
