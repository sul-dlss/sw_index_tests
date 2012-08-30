# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'rspec-solr'

describe "Chinese: Word Breaks - Unigrams", :chinese => true, :fixme => true, :wordbreak => true do

  # cjk1 (indexUnigrams true, agenphraseq false)     searchworks-dev
  # cjk2 (indexUnigrams true, agenphraseq true)      searchworks-dev:3000
  # cjk3 (indexUnigrams false, agenphraseq false)   
  # cjk4 (as cjk1, but mm=2)         
  # cjk5 (add CJKBigram filter to textNoStem, indexUnigrams true, agenphraseq false)   searchworks-dev:3001
  
  context "舊小說 (old fiction) becomes  舊 (unigram) and  小說 (bigram)" do

    it "舊小說 (no spaces) should have good search results" do
      resp = solr_resp_doc_ids_only({'q'=>'舊小說', 'rows'=>'20'}) 
      resp.should include(["9262744", "6797638", "6695967"]).as_first(3).results
      resp.should include(["6695904", "6696790"]).in_first(5).documents # both words in 245a
      resp.should include(["7198256", "6699444"]).in_first(8).documents  # both words in 245
      # soc:  24 results
      # cjk1 (bigrams and unigrams):  3,087 results
      # cjk3 (bigrams only):          3,087 results
      # cjk7 (unigrams only):        27,879 results
      # cjk6cn (chinese dict only):  4,980 results
      # cjk6ja (japanese dict only): 19,599 results
    end
    it "舊 小說 (space) should have good search results" do
      resp = solr_resp_doc_ids_only({'q'=>'舊 小說', 'rows'=>'20'}) 
      resp.should include(["9262744", "6797638", "6695967"]).as_first(3).results
      resp.should include(["6695904", "6696790"]).in_first(5).documents # both words in 245a
      resp.should include(["7198256", "6699444"]).in_first(8).documents  # both words in 245
      # soc:  35 results
      # cjk1 (bigrams and unigrams):  0 results 
      # cjk3 (bigrams only):          0 results
      # cjk7 (unigrams only):        73 results
      # cjk6cn (chinese dict only):  10 results
      # cjk6ja (japanese dict only): 68 results
    end
    context "title search" do
      it "舊小說 (no spaces) should have good search results" do
        resp = solr_resp_doc_ids_only({'q'=>'舊小說', 'rows'=>'20', 'qt'=>'search_title'}) 
        resp.should include(["9262744", "6797638", "6695967"]).as_first(3).results
        resp.should include(["6695904", "6696790"]).in_first(5).documents # both words in 245a
        resp.should include(["7198256", "6699444"]).in_first(8).documents  # both words in 245
        # soc:  11 results
        #   8834455  - ?? translated to simplified??
        #   7198256 - old 245b; fiction: 245a
        #   6793760 - ??
        #   6288832 - old 505t; fiction 505t x2
        #   4192734 - ??
        #   9262744 - old fiction: 245a
        #   6797638 - old fiction: 245a
        #   6695967 - old fiction: 245a
        #   6695904 - fiction 245a; old 245a
        #   6699444 - old 245a; fiction 245b
        #   6696790 - old 245a; fiction 245a
        # 
        # cjk1 (bigrams and unigrams):  2,862 results  
        # cjk3 (bigrams only):          2,862
        # cjk7 (unigrams only):        19,791 results
        # cjk6cn (chinese dict only):   4,576 results
        # cjk6ja (japanese dict only): 16,451 results
      end  
      it "舊 小說 (space) should have good search results" do
        resp = solr_resp_doc_ids_only({'q'=>'舊 小說', 'rows'=>'20', 'qt'=>'search_title'}) 
        resp.should include(["9262744", "6797638", "6695967"]).as_first(3).results
        resp.should include(["6695904", "6696790"]).in_first(5).documents # both words in 245a
        resp.should include(["7198256", "6699444"]).in_first(8).documents  # both words in 245
        # soc:  14 results
        #   8834455  - ?? translated to simplified??
        # NEW 7699186 - ??
        #   7198256 - old 245b; fiction: 245a
        #   6793760 - ??
        #   6288832 - old 505t; fiction 505t x2
        #   4192734 - ??
        # NEW 6204747 - old 245a; fiction 490a; 830a
        #   9262744 - old fiction: 245a
        #   6797638 - old fiction: 245a
        #   6695967 - old fiction: 245a
        #   6695904 - fiction 245a; old 245a
        #   6699444 - old 245a; fiction 245b
        # NEW 6698466 - old 245a; fiction 490a, 830a
        #   6696790 - old 245a; fiction 245a
        # 
        # cjk1 (bigrams and unigrams):  0 results <--  what???
        # cjk3 (bigrams only):          0 results
        # cjk7 (unigrams only):        46 results
        # cjk6cn (chinese dict only):   9 results
        #    8834455
        #    9262744
        #    6797638
        #    6695967
        #    6793760
        #    6699444
        #    6698466
        #    7198256
        #    6288832
        # 
        # cjk6ja (japanese dict only): 46 results
      end
      
    end
    
  end
  
  context "婦女與文學 becomes  婦女 (women)  與 (and)   文學 (literature)" do
    #  婦女與文學    has 17 hits in soc;  soc would put it in the 3 units
    #  婦女與文學    parses to  婦女 (women)  與 (and)   文學 (literature) 
    #   女與   (BC chars)  has no meaning
    #   與文   (CD chars)  has no meaning on its own
    
    # no space
    # space
    # phrase no space
    # phrase space
    # AND query
    # OR query
    # positionfilter ...
    # overlapping tokens ...   what if they didn't overlap and were ANDed
  end

  context " 三國誌 becomes  三國 (bigram) and  誌 (unigram)" do
    # no space
    # space
    # phrase no space
    # phrase space
    # AND query
    # OR query
    # positionfilter ...
    # overlapping tokens ...   what if they didn't overlap and were ANDed
  end
  
  
  
end