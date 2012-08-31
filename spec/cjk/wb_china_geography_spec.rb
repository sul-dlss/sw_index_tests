# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'rspec-solr'

describe "Chinese: Word Breaks - a place in China geography", :chinese => true, :fixme => true, :wordbreak => true do

  context " 郑州 (a place in China)  地理 (geography)" do
    it "郑州地理 should have good search results" do
      resp = solr_resp_doc_ids_only({'q'=>'郑州地理', 'qt'=>'search_title'}) 
      resp.should include("9612993").as_first.result  
      resp.should have_at_most(1).document
      # soc:                              2
      #   9612993
      #   5456407
      # cjk1 (bigrams and unigrams):   2630 
      # cjk3 (bigrams only):           2630 
      # cjk7 (unigrams only):         39598
      # cjk6cn (chinese dict only):    2235 
      # cjk6ja (japanese dict only):   7668
      # cjk8 (chinese dict no pos):    2235
    end
    
    it "郑州 地理 as two terms should have good search results" do
      resp = solr_resp_doc_ids_only({'q'=>'郑州 地理', 'qt'=>'search_title'})
      resp.should include("9612993").as_first.result
      resp.should have_at_most(1).document
      
      # soc:                           8
      #     9612993
      #     7833848
      #     5809974
      #     4808042
      #     4203541
      #     4197620
      #     5456407
      #     6704074
      # cjk1 (bigrams and unigrams):   2
      #    4203541   place 260a; geography 245a, 490a, 830a
      #    5809974   place 260a; geography 245a
      # cjk3 (bigrams only):           2 
      # cjk7 (unigrams only):       1323
      # cjk6cn (chinese dict only):    2   (same as cjk1)
      # cjk6ja (japanese dict only):  81
      # cjk8 (chinese dict no pos):    2
    end
    
    context "title search" do
      it "郑州地理 should have good search results" do
        resp = solr_resp_doc_ids_only({'q'=>'郑州地理', 'qt'=>'search_title'}) 
        resp.should include("9612993").as_first.result  
        resp.should have_at_most(1).document
        # soc:                       1 result
        #    9612993     郑州地理 never;  郑州  245a, 520a, 651a;   地理  245a (but two chars between), 520a
        #  (not avail in dev)
        # cjk1 (bigrams and unigrams): 2,286
        #    6324746     郑州地理 never;  郑州 never;  地理 245a;   州地 (nonsense) 245a  (abcd - never, ab - never, cd - 245a; bc - 245a, bcd - 245a)
        #    5631095
        #    4188978
        #    6827354
        #    8720366
        #    4822107
        #    4703364
        #    ...
        # cjk3 (bigrams only):         2,286
        # cjk7 (unigrams only):       31,543
        # cjk6cn (chinese dict only):  2,016 
        # cjk6ja (japanese dict only): 5,298
        # cjk8 (chinese dict no pos):  2,016
      end
      
      it "郑州 地理 as two terms should have good search results" do
        resp = solr_resp_doc_ids_only({'q'=>'郑州 地理', 'qt'=>'search_title'})
        resp.should include("9612993").as_first.result
        resp.should have_at_most(1).document
        
        # soc:  1 result
        #    9612993     郑州地理 never;  郑州  245a, 520a, 651a;   地理  245a (but two chars between), 520a
        #   (not avail in dev)
        # cjk1 (bigrams and unigrams):   0
        # cjk3 (bigrams only):           0 
        # cjk7 (unigrams only):        746
        # cjk6cn (chinese dict only):    0
        # cjk6ja (japanese dict only):  57 
        # cjk8 (chinese dict no pos):    0
      end
    end # context title_search
  end # context  (a place in China) (geography)
    
end