# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'rspec-solr'

# passes with zh_dict_phrase;  
describe "Chinese Author Search (Fang, Baochuan)", :chinese => true, :fixme => true, :vetted => 'vitus' do

  shared_context "search tests" do
    shared_examples "great results" do
      describe do
        it "should get all the  方寶川 (traditional char) matches" do
          resp.should include(["5468624", "5482057", "5727562", "6650839", "9388854", "9728468"]).in_first(8).results
        end
        it "should get all the 方宝川 (simplified char) matches" do
          resp.should include(["4160175"]).in_first(8).results
        end
        it "should get an appropriate number of documents" do
          resp.should have_at_least(6).documents
          resp.should have_at_most(15).documents
          # there are lots more records with one of the three chars in an author field
        end
        # 8 in soc
        #   9388854 - in 700a, 245c  trad
        #   6650839 - in 700a, 245c  trad
        #   5727562 - in 700a, 245c  trad
        #   5482057 - in 700a, 245c  trad
        #   5468624 - in 700a, 245c  trad
        #   4160175 - in 700a, 245c  simplified
        #   9728468 - in 700a, 245c  trad
        #   8243512 - in 710, not adjacent simplified
      end
    end
  end
  include_context "search tests"
  
  context "traditional  方寶川" do
    it_behaves_like "great results" do
      let (:resp) { solr_resp_doc_ids_only(author_search_args('方寶川')) }
    end
  end
  
  context "simplified  方宝川" do
    it_behaves_like "great results" do
      let (:resp) { solr_resp_doc_ids_only(author_search_args('方宝川')) }
    end
  end   
    
end