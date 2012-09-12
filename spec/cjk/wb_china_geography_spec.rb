# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'rspec-solr'

describe "Chinese: Word Breaks", :chinese => true, :fixme => true, :wordbreak => true do

  context " 郑州 (a place in China)  地理 (geography)" do

    shared_context "search tests" do
      shared_examples "great search results for 郑州地理" do
        describe do
          it "should rank highest the documents with both words in 245a" do
            resp.should include("9612993").as_first.result  
          end
          it "should rank high the documents with one word in 245a" do
            #  地理 (geography) in 245a 490a, 830a;  郑州 (place in China) in 260a
            resp.should include("4203541").in_first(3).results
            #  地理 (geography) in 245a;  郑州 (place in China) in 260a
            resp.should include(["4197620", "4808042", "5809974", "6704074"]).in_first(8).results
          end
          it "should rank less high the documents with both words present but not in 245" do
            # 7833848	place 260a, geography 490a
            resp.should include("7833848")
            resp.should_not include("7833848").in_first(6).results
            # 5456407	all four characters in 260
            resp.should include("5456407")
            resp.should_not include("5456407").in_first(6).results
          end
        end
      end
    end
    include_context "search tests"

    context "no spaces  郑州地理" do
      # soc:                       2 : 9612993, 5456407
      # cjk1 (bigrams only):    2630 
      # cjk7 (unigrams only):  39598
      # cjk6cn (chinese dict):  2235 
      
      it_behaves_like "great search results for 郑州地理" do
        let (:resp) { solr_resp_doc_ids_only({'q'=>'郑州地理'}) }
      end
    end
    
    context "space between words 郑州 地理" do
      # soc:                      8
      #     9612993
      #     7833848
      #     5809974
      #     4808042
      #     4203541
      #     4197620
      #     5456407
      #     6704074
      # cjk1 (bigrams only):      2
      #    4203541   place 260a; geography 245a, 490a, 830a
      #    5809974   place 260a; geography 245a
      # cjk7 (unigrams only):  1323
      # cjk6cn (chinese dict):    2   (same as cjk1)

      it_behaves_like "great search results for 郑州地理" do
        let (:resp) { solr_resp_doc_ids_only({'q'=>'郑州 地理'}) }
      end
    end
          
    context "title search" do
      
      shared_context "title search tests" do
        shared_examples "great title search results for 郑州地理" do
          describe do
            it "should only retrieve the documents with both words in 245a" do
              resp.should include("9612993").as_first.result 
              resp.should have_at_most(1).document 
            end
          end
        end
      end
      include_context "title search tests"
      
      context "no spaces  郑州地理" do
        # soc:                        1 result
        #    9612993     郑州地理 never;  郑州  245a, 520a, 651a;   地理  245a (but two chars between), 520a
        #  (not avail in dev)
        # cjk1 (bigrams):         2,286
        #    6324746     郑州地理 never;  郑州 never;  地理 245a;   州地 (nonsense) 245a  (abcd - never, ab - never, cd - 245a; bc - 245a, bcd - 245a)
        #    5631095
        #    4188978
        #    6827354
        #    8720366
        #    4822107
        #    4703364
        #    ...
        # cjk7 (unigrams only):  31,543
        # cjk6cn (chinese dict):  2,016 

        it_behaves_like "great title search results for 郑州地理" do
          let (:resp) { solr_resp_doc_ids_only({'q'=>'郑州地理', 'qt'=>'search_title'}) }
        end
      end
      
      context "space between words 郑州 地理" do
        # soc:  1 result
        #    9612993     郑州地理 never;  郑州  245a, 520a, 651a;   地理  245a (but two chars between), 520a
        #   (not avail in dev)
        # cjk1 (bigrams only):           0 
        # cjk7 (unigrams only):        746
        # cjk6cn (chinese dict only):    0
        # cjk8 (chinese dict no pos):    0

        it_behaves_like "great title search results for 郑州地理" do
          let (:resp) { solr_resp_doc_ids_only({'q'=>'郑州 地理', 'qt'=>'search_title'}) }
        end
      end   
         
    end # context title_search
    
  end # context  (a place in China) (geography)
    
end