require 'spec_helper'

#I want to be able to use long multi-word queries
#In order to get great results which may not contain all the words in my queries
describe "mm threshold setting for dismax (6 as of 2012/08)" do
  
  # there are long queries in ampersand, colon and hyphen specs as well
  
  context "queries with many terms" do
    it ">6 terms should work (mm threshold is 6)" do
      resp = solr_resp_doc_ids_only({'q'=>'Bess : the life of Lady Ralegh, wife to Sir Walter'})
      resp.should include('5587217')
      resp.should have_the_same_number_of_documents_as(solr_resp_doc_ids_only({'q'=>'Bess : life Lady Ralegh, wife Sir Walter'}))
      resp.should have_fewer_documents_than(solr_resp_doc_ids_only({'q'=>'life Ralegh, Sir Walter'}))
    end

    it "5 terms should all matter: royal institution library of science", :jira => 'VUF-1685' do
      resp = solr_resp_doc_ids_only({'q'=>'royal institution library of science'})
      resp.should have_at_most(85).documents
      resp2 = solr_resp_doc_ids_only({'q'=>'royal institution library of science bragg'})
      resp2.should have_documents
      resp.should have_more_results_than(resp2)
      resp.should have_fewer_documents_than(solr_resp_doc_ids_only({'q'=>'institution library of science'}))
    end
    
    it "6 terms should all matter: shanghai social life customs 20th century", :jira => 'VUF-1129' do
      resp = solr_resp_doc_ids_only({'q'=>'shanghai social life customs 20th century'})
      resp.should have_at_most(30).documents
      resp.should have_fewer_documents_than(solr_resp_doc_ids_only({'q'=>'shanghai social life customs century'}))
    end
  end
  
end
  
  
  
  
