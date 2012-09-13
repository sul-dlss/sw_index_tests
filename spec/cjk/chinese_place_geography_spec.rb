# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'rspec-solr'

describe "Chinese: 郑州 (a place in China)  地理 (geography)", :chinese => true, :fixme => true, :wordbreak => true do

  shared_context "st" do
    shared_examples "great search results in title for 郑州地理" do
      # 119747:  trad  鄭州  in 245a;  
      # 9612993:  both words in 245a, but separated;  record not in cjk batch
      describe do
        it "should only retrieve the documents with both words in 245a" do
          resp.should include("9612993").as_first.result 
        end
      end
    end
  end
  include_context "st"

  context "title search" do
    shared_context "ts" do
      shared_examples "great title search results for 郑州地理" do
        describe do
          it "should have an appropriate number of results" do
            resp.should have_at_most(1).document 
          end
        end
      end
    end
    include_context "ts"
    
    # cjk9:
    #  郑州地理 title 1
    #  郑州 地理 title 0
    #  郑州 title: 1
    #  地理  title:  19

    context "trad  鄭州地理 (no space)" do
      before(:all) do
        @resp = solr_resp_doc_ids_only({'q'=>'鄭州地理', 'qt'=>'search_title'})
      end
      it_behaves_like "great search results in title for 郑州地理" do
        let (:resp) { @resp }
      end
      it_behaves_like "great title search results for 郑州地理" do
        let (:resp) { @resp }
      end
    end
    
    context "trad  鄭州 地理 (space)" do
      before(:all) do
        @resp = solr_resp_doc_ids_only({'q'=>'鄭州 地理', 'qt'=>'search_title'})
      end
      it_behaves_like "great search results in title for 郑州地理" do
        let (:resp) { @resp }
      end
      it_behaves_like "great title search results for 郑州地理" do
        let (:resp) { @resp }
      end
    end   
       
    context "simplified  郑州地理 (no space)" do
      before(:all) do
        @resp = solr_resp_doc_ids_only({'q'=>'郑州地理', 'qt'=>'search_title'})
      end
      it_behaves_like "great search results in title for 郑州地理" do
        let (:resp) { @resp }
      end
      it_behaves_like "great title search results for 郑州地理" do
        let (:resp) { @resp }
      end
    end
    
    context "simplified  郑州 地理 (space)" do
      before(:all) do
        @resp = solr_resp_doc_ids_only({'q'=>'郑州 地理', 'qt'=>'search_title'})
      end
      it_behaves_like "great search results in title for 郑州地理" do
        let (:resp) { @resp }
      end
      it_behaves_like "great title search results for 郑州地理" do
        let (:resp) { @resp }
      end
    end   

  end # context title_search

  context "everything search" do
    shared_context "s" do
      shared_examples "great search results for 郑州地理" do
        describe do
          # soc:  鄭州 地理 (trad) 8 results
          # soc:  郑州 地理  (simpl) 8 results
          #  9612993:  both words in 245a, but separated;  record not in cjk batch
          # 7833848	place 260a, geography 490a
          # 5809974   place 260a; geography 245a
          # 4808042	place 260a, geography 245a
          # 4203541   place 260a; geography 245a, 490a, 830a
          # 4197620	place 260a, geography 245a
          # 5456407:  place in 260a,  geography in 260b, 710b        
          # 6704074	place 260a, geography 245a
          # 518541  geography in 260b, 710b;   can't find place
          # 119747:  place trad  鄭州  in 245a;  can't find geography 
          it "should get a reasonable number of results" do
            resp.should have_at_least(8).documents 
            resp.should have_at_most(20).documents
          end
          it "should rank highest the documents with both words in 245a" do
            resp.should include("9612993").as_first.result  
          end
          # there are a LOT more of these --> socrates finds 1953 of them.
          it "should rank high the documents with one word in 245a" do
            #  地理 (geography) in 245a 490a, 830a;  郑州 (place in China) in 260a
            resp.should include("4203541").in_first(3).results
            #  地理 (geography) in 245a;  郑州 (place in China) in 260a
            resp.should include(["4197620", "4808042", "5809974", "6704074"]).in_first(8).results
          end
          it "should rank less high the documents with both words present but not in 245" do
            # 7833848	place 260a, geography 490a
            # 5456407:  place in 260a,  geography in 260b, 710b        
            resp.should include(["7833848", "5456407"])
            resp.should_not include(["7833848", "5456407"]).in_first(6).results
          end
        end
      end
    end
    include_context "s"

    context "trad  鄭州地理 (no space)" do
      before(:all) do
        @resp = solr_resp_doc_ids_only({'q'=>'鄭州地理'})
      end
      it_behaves_like "great search results in title for 郑州地理" do
        let (:resp) { @resp }
      end
      it_behaves_like "great search results for 郑州地理" do
        let (:resp) { @resp }
      end
    end
    
    context "trad  鄭州 地理 (space)" do
      before(:all) do
        @resp = solr_resp_doc_ids_only({'q'=>'鄭州 地理'})
      end
      it_behaves_like "great search results in title for 郑州地理" do
        let (:resp) { @resp }
      end
      it_behaves_like "great search results for 郑州地理" do
        let (:resp) { @resp }
      end
    end   
       
    context "simplified  郑州地理 (no space)" do
      # soc:                       2
      # cjk1 (bigrams only):    2630 
      # cjk7 (unigrams only):  39598
      # cjk6cn (chinese dict):  2235 
      before(:all) do
        @resp = solr_resp_doc_ids_only({'q'=>'郑州地理'})
      end
      it_behaves_like "great search results in title for 郑州地理" do
        let (:resp) { @resp }
      end
      it_behaves_like "great search results for 郑州地理" do
        let (:resp) { @resp }
      end
    end
    
    context "simplified  郑州 地理 (space)" do
      # soc:                      8
      # cjk1 (bigrams only):      2
      # cjk7 (unigrams only):  1323
      # cjk6cn (chinese dict):    2
      before(:all) do
        @resp = solr_resp_doc_ids_only({'q'=>'郑州 地理'})
      end
      it_behaves_like "great search results in title for 郑州地理" do
        let (:resp) { @resp }
      end
      it_behaves_like "great search results for 郑州地理" do
        let (:resp) { @resp }
      end
    end   
    
  end # context everything search

end