node {
  lock('sw_index_tests') {
    stage ('Clean') {
      deleteDir()
    }

    stage('Build') {
      checkout scm

      sh '''#!/bin/bash -l
      rvm use 2.4.4@sw_index_tests --create
      gem install bundler
      bundle install
      '''
    }

    stage('Test') {
      sh '''#!/bin/bash -l
      rvm use 2.4.4@sw_index_tests
      bundle exec rake passing URL=http://searchworks-solr-lb.stanford.edu:8983/solr/
      '''
    }
  }
}
