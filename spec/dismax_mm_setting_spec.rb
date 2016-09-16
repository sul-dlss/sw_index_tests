require 'spec_helper'

#I want to be able to use long multi-word queries
#In order to get great results which may not contain all the words in my queries
describe "mm threshold setting for dismax (6 as of 2012/08)" do

  # there are long queries in ampersand, colon and hyphen specs as well

  context "queries with many terms" do
    it ">6 terms should work (mm threshold is 6)" do
      resp = solr_resp_doc_ids_only({'q'=>'Bess : the life of Lady Ralegh, wife to Sir Walter'})
      expect(resp).to include('5587217')
      expect(resp).to have_the_same_number_of_documents_as(solr_resp_doc_ids_only({'q'=>'Bess : life Lady Ralegh, wife Sir Walter'}))
      expect(resp).to have_fewer_documents_than(solr_resp_doc_ids_only({'q'=>'life Ralegh, Sir Walter'}))
    end

    it "5 terms should all matter: royal institution library of science", :jira => 'VUF-1685' do
      resp = solr_resp_doc_ids_only({'q'=>'royal institution library of science'})
      expect(resp.size).to be <= 200
      resp2 = solr_resp_doc_ids_only({'q'=>'royal institution library of science bragg'})
      expect(resp2).to have_documents
      expect(resp).to have_more_results_than(resp2)
      expect(resp).to have_fewer_documents_than(solr_resp_doc_ids_only({'q'=>'institution library of science'}))
    end

    it "6 terms should all matter: shanghai social life customs 20th century", :jira => 'VUF-1129' do
      resp = solr_resp_doc_ids_only({'q'=>'shanghai social life customs 20th century'})
      expect(resp.size).to be <= 50
      expect(resp).to have_fewer_documents_than(solr_resp_doc_ids_only({'q'=>'shanghai social life customs century'}))
    end
  end

end
