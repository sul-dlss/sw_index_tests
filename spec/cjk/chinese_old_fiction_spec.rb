# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'rspec-solr'

describe "Chinese Old Fiction:  舊 (old) and  小說 (fiction)", :chinese => true, :fixme => true, :wordbreak => true, :vetted => 'vitus' do

  shared_context "old fiction results" do
    shared_examples "great search results for 舊小說" do
      describe do
        it "gets the traditional char matches" do
          # the first 4 lines are redundant, but split out for ease of diagnostics
          resp.should include(["9262744", "6797638", "6695967"]) # in 245a
          resp.should include("6696790") # in 245a but not adjacent
          resp.should include("6695904") # three characters in 245a, but in a different order 
          resp.should include("6699444") # in 245a and b
          resp.should include(["9262744", "6797638", "6695967"]).before(["6696790", "6695904", "6699444"])
          resp.should include("6695904").before("6699444")
        end
        it "gets the simplified char matches" do
          # 旧小说
          resp.should include("8834455") #  旧小说 in 245a
          resp.should include("4192734")  # diff word order in 245a  小说旧
          resp.should include("8834455").before("4192734")
        end
        it "ranks highest the documents with adjacent words in 245a" do
          #   9262744 - old fiction: 245a
          #   6797638 - old fiction: 245a
          #   6695967 - old fiction: 245a
          #   8834455 - translated to simplified, all three in 245a
          resp.should include(["9262744", "6797638", "6695967", "8834455"]).in_first(5).results
        end
        it "ranks very high the documents with both words in 245a but not adjacent" do
          #   4192734 - diff word order in 245a  小说旧
          resp.should include(["4192734"]).in_first(6).results
        end
        it "ranks high the documents with one word in 245a and the other in 245b" do
          #   6695904 - fiction 245a; old 245a
          #   6699444 - old 245a; fiction 245b
          #   6696790 - old 245a; fiction 245a
          #   7198256 - old 245b; fiction: 245a  (Korean also in record)
          #   6793760 - old (simplified) 245a; fiction 245b
          resp.should include(["6695904", "6699444", "6696790", "7198256", "6793760"]).in_first(12).results
        end
        it "includes other relevant results" do
          #   6288832 - old 505t; fiction 505t x2
          #   7699186 - 1st character in simplified in 245a, 2nd and 3rd in 490 and 830, 3rd character in simplified
          #   6204747 - old 245a; fiction 490a; 830a
          #   6698466 - old 245a; fiction 490a, 830a
          resp.should include(["6288832", "7699186", "6204747", "6698466"])
        end
      end # describe
    end
  end # shared_context old fiction results

  context "title search" do
    shared_context "ts" do
      shared_examples "great title search results for 舊小說" do
        describe do
          it "gets a reasonable number of results" do
            resp.should have_at_least(8).documents
            resp.should have_at_most(15).documents
          end
        end 
      end
    end
    include_context "old fiction results"
    include_context "ts"

    context "traditional  舊小說 no spaces" do
      before(:all) do
        @resp = solr_resp_doc_ids_only(title_search_args('舊小說').merge({'rows'=>'25'}))
      end
      it_behaves_like "great search results for 舊小說" do
        let (:resp) { @resp }
      end
      it_behaves_like "great title search results for 舊小說" do
        let (:resp) { @resp }
      end
    end

    context "traditional  舊 小說  with space" do
      before(:all) do
        @resp = solr_resp_doc_ids_only(title_search_args('舊 小說').merge({'rows'=>'25'}))
      end
      it_behaves_like "great search results for 舊小說" do
        let (:resp) { @resp }
      end
      it_behaves_like "great title search results for 舊小說" do
        let (:resp) { @resp }
      end
    end
    
    context "simplified  旧小说 no spaces" do
      before(:all) do
        @resp = solr_resp_doc_ids_only(title_search_args('旧小说').merge({'rows'=>'25'}))
      end
      it_behaves_like "great search results for 舊小說" do
        let (:resp) { @resp }
      end
      it_behaves_like "great title search results for 舊小說" do
        let (:resp) { @resp }
      end
    end
    
    context "simplified  旧 小说  with space" do
      before(:all) do
        @resp = solr_resp_doc_ids_only(title_search_args('旧 小说').merge({'rows'=>'25'}))
      end
      it_behaves_like "great search results for 舊小說" do
        let (:resp) { @resp }
      end
      it_behaves_like "great title search results for 舊小說" do
        let (:resp) { @resp }
      end
    end
    
  end # context title search

  context "everything search" do
    shared_context "es" do
      shared_examples "great everything search results for 舊小說" do
        describe do
          it "gets a reasonable number of results" do
            resp.should have_at_least(20).documents
            resp.should have_at_most(40).documents
          end
        end 
      end
    end
    include_context "es"

    context "traditional  舊小說 no spaces" do
      before(:all) do
        @resp = solr_resp_doc_ids_only({'q'=>'舊小說', 'rows'=>'25'})
      end
      it_behaves_like "great search results for 舊小說" do
        let (:resp) { @resp }
      end
      it_behaves_like "great everything search results for 舊小說" do
        let (:resp) { @resp }
      end
    end

    context "traditional  舊 小說  with space" do
      before(:all) do
        @resp = solr_resp_doc_ids_only({'q'=>'舊 小說', 'rows'=>'25'})
      end
      it_behaves_like "great search results for 舊小說" do
        let (:resp) { @resp }
      end
      it_behaves_like "great everything search results for 舊小說" do
        let (:resp) { @resp }
      end
    end
    
    context "simplified  旧小说 no spaces" do
      before(:all) do
        @resp = solr_resp_doc_ids_only({'q'=>'旧小说', 'rows'=>'25'})
      end
      it_behaves_like "great search results for 舊小說" do
        let (:resp) { @resp }
      end
      it_behaves_like "great everything search results for 舊小說" do
        let (:resp) { @resp }
      end
    end
    
    context "simplified  旧 小说  with space" do
      before(:all) do
        @resp = solr_resp_doc_ids_only({'q'=>'旧 小说', 'rows'=>'25'})
      end
      it_behaves_like "great search results for 舊小說" do
        let (:resp) { @resp }
      end
      it_behaves_like "great everything search results for 舊小說" do
        let (:resp) { @resp }
      end
    end
    
  end # context everything search

end