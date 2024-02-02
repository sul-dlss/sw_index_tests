pipeline {
  agent any

  triggers {
      cron('@daily')
  }

  environment {
      LC_ALL = 'en_US.UTF-8'
      LANG    = 'en_US.UTF-8'
      LANGUAGE = 'en_US.UTF-8'
  }

  stages {
    stage('Build') {
      steps {
        checkout scm

        sh '''#!/bin/bash -l
        rvm use 3.2.2@sw_index_tests --create
        gem install bundler
        bundle install
        '''
      }
    }

    stage('Test - Production') {
      steps {
        sh '''#!/bin/bash -l
        rvm use 3.2.2@sw_index_tests
        bundle exec rake URL=https://sul-solr.stanford.edu/solr/searchworks-prod/
        '''
      }
    }

    stage('Test - Gryphonsearch') {
      steps {
        catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
          sh '''#!/bin/bash -l
          rvm use 3.2.2@sw_index_tests
          bundle exec rake URL=https://sul-solr.stanford.edu/solr/searchworks-gryphon-search/
          '''
        }
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
