# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'rspec-solr'

describe "Chinese Women and Literature:  婦女 (women)  與 (and)   文學 (literature)", :chinese => true, :fixme => true, :wordbreak => true do

  shared_context "results" do
    shared_examples "great search results for 婦女與文學" do
      describe do
        it "gets the traditional char matches" do
          resp.should include(["6343505", "8246653"]).as_first(2).documents
          resp.should include(["4724601", "8250645", "6343719", "6343720"]).in_first(6).documents  # script as is
          #resp.should include(["9262744", "6797638", "6695967"]) # in 245a
          #resp.should include(["6695904", "6699444", "6696790"]) # in 245a and b
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
          #   7198256 - old 245b; fiction: 245a
          resp.should include(["6695904", "6699444", "6696790", "7198256"]).in_first(12).results
        end
        it "includes other relevant results" do
          #   7198256 - only 2nd and 3rd characters found in 245a
          #   6793760 - only 2nd and 3rd characters found in 245a, 3rd character in simplified
          #   6288832 - old 505t; fiction 505t x2
          #   7699186 - 1st character in simplified in 245a, 2nd and 3rd in 490 and 830, 3rd character in simplified
          #   6204747 - old 245a; fiction 490a; 830a
          #   6698466 - old 245a; fiction 490a, 830a
          resp.should include(["7198256", "6793760", "6288832", "7699186", "6204747", "6698466"])
        end
      end # describe
    end

    #  婦女與文學    parses to  婦女 (women)  與 (and)   文學 (literature) 
    #   女與   (BC chars)  has no meaning
    #   與文   (CD chars)  has no meaning on its own
    # simplified:   妇女 与	文学

    # title  婦女與文學
    # # soc:                  11
    #    8802530
    #    8234101
    #    7944106
    #    7833961
    #    8250645
    #    8246653
    #    5930857
    #    4724601
    #    6343719
    #    6343505
    #    6343720
    # cjk1 (bigrams):         6,723
    # cjk7 (unigrams):      102,211
    # cjk6cn (chinese dict): 32,505  
    
    # title spaces  婦女 與 文學
    # soc:                    11
    #    8802530
    #    8234101
    #    7944106
    #    7833961
    #    8250645
    #    8246653
    #    5930857
    #    4724601
    #    6343719
    #    6343505
    #    6343720
    # cjk1 (bigrams):          0
    # cjk7 (unigrams):        61
    # cjk6cn (chinese dict):  13
    

    #  婦女與文學   
    # soc:                        17 
    # cjk1 (bigrams):          7,201
    # cjk7 (unigrams):       117,716
    # cjk6cn (chinese dict):  34,601

    # "婦女 與 文學 (spaces)
    # soc:                    21
    # cjk1 (bigrams):          0
    # cjk7 (unigrams):       107
    # cjk6cn (chinese dict):  15
    

  end # shared_context results



  context "婦女與文學 becomes  婦女 (women)  與 (and)   文學 (literature)" do
    
    it "婦女與文學 (no spaces) should have good search results" do
      resp = solr_resp_doc_ids_only({'q'=>'婦女與文學', 'rows'=>'20'}) 
    end
    it "婦女 與 文學 (spaces) should have good search results" do
      resp = solr_resp_doc_ids_only({'q'=>'婦女 與 文學', 'rows'=>'20'}) 
    end
    
    context "title search" do
      it "婦女與文學 (no spaces) should have good search results" do
        resp = solr_resp_doc_ids_only({'q'=>'婦女與文學', 'rows'=>'20', 'qt'=>'search_title'}) 

      end
      it "婦女 與 文學 (spaces) should have good search results" do
        resp = solr_resp_doc_ids_only({'q'=>'婦女 與 文學', 'rows'=>'20', 'qt'=>'search_title'}) 
      end
  
    end  # title search
    
  end # women and literature




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
        @resp = solr_resp_doc_ids_only({'q'=>'舊小說', 'qt'=>'search_title', 'rows'=>'25'})
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
        @resp = solr_resp_doc_ids_only({'q'=>'舊 小說', 'qt'=>'search_title', 'rows'=>'25'})
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
        @resp = solr_resp_doc_ids_only({'q'=>'旧小说', 'qt'=>'search_title', 'rows'=>'25'})
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
        @resp = solr_resp_doc_ids_only({'q'=>'旧 小说', 'qt'=>'search_title', 'rows'=>'25'})
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