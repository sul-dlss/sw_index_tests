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
      # soc:                             24 results
      # cjk1 (bigrams and unigrams):  3,087
      # cjk3 (bigrams only):          3,087
      # cjk7 (unigrams only):        27,879
      # cjk6cn (chinese dict only):   4,980 
      # cjk6ja (japanese dict only): 19,599 
      # cjk8 (chinese dict no pos):   4,980
    end
    it "舊 小說 (space) should have good search results" do
      resp = solr_resp_doc_ids_only({'q'=>'舊 小說', 'rows'=>'20'}) 
      resp.should include(["9262744", "6797638", "6695967"]).as_first(3).results
      resp.should include(["6695904", "6696790"]).in_first(5).documents # both words in 245a
      resp.should include(["7198256", "6699444"]).in_first(8).documents  # both words in 245
      # soc:                         35 results
      # cjk1 (bigrams and unigrams):  0 
      # cjk3 (bigrams only):          0 
      # cjk7 (unigrams only):        73 
      # cjk6cn (chinese dict only):  10 
      # cjk6ja (japanese dict only): 68 
      # cjk8 (chinese dict no pos):  10
    end
    context "title search" do
      it "舊小說 (no spaces) should have good search results" do
        resp = solr_resp_doc_ids_only({'q'=>'舊小說', 'rows'=>'20', 'qt'=>'search_title'}) 
        resp.should include(["9262744", "6797638", "6695967"]).as_first(3).results
        resp.should include(["6695904", "6696790"]).in_first(5).documents # both words in 245a
        resp.should include(["7198256", "6699444"]).in_first(8).documents  # both words in 245
        # soc:                             11 results
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
        # cjk1 (bigrams and unigrams):  2,862
        # cjk3 (bigrams only):          2,862
        # cjk7 (unigrams only):        19,791
        # cjk6cn (chinese dict only):   4,576 
        # cjk6ja (japanese dict only): 16,451 
        # cjk8 (chinese dict no pos):   4,576
      end  
      it "舊 小說 (space) should have good search results" do
        resp = solr_resp_doc_ids_only({'q'=>'舊 小說', 'rows'=>'20', 'qt'=>'search_title'}) 
        resp.should include(["9262744", "6797638", "6695967"]).as_first(3).results
        resp.should include(["6695904", "6696790"]).in_first(5).documents # both words in 245a
        resp.should include(["7198256", "6699444"]).in_first(8).documents  # both words in 245
        # soc:                        14 results
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
        # cjk1 (bigrams and unigrams):  0 results
        # cjk3 (bigrams only):          0 
        # cjk7 (unigrams only):        46 
        # cjk6cn (chinese dict only):   9 
        #    8834455
        #    9262744
        #    6797638
        #    6695967
        #    6793760
        #    6699444
        #    6698466
        #    7198256
        #    6288832
        # cjk6ja (japanese dict only): 46
        # cjk8 (chinese dict no pos):   9
      end
      
    end # title search    
  end # old fiction
  
  context "婦女與文學 becomes  婦女 (women)  與 (and)   文學 (literature)" do
    #  婦女與文學    has 17 hits in soc;  soc would put it in the 3 units
    #  婦女與文學    parses to  婦女 (women)  與 (and)   文學 (literature) 
    #   女與   (BC chars)  has no meaning
    #   與文   (CD chars)  has no meaning on its own
    # simplified:   妇女 与	文学
    
    it "婦女與文學 (no spaces) should have good search results" do
      resp = solr_resp_doc_ids_only({'q'=>'婦女與文學', 'rows'=>'20'}) 
      resp.should include(["6343505", "8246653"]).as_first(2).documents
      resp.should include(["4724601", "8250645", "6343719", "6343720"]).in_first(6).documents  # script as is
      # soc:                              17 hits
      # cjk1 (bigrams and unigrams):   7,201
      # cjk3 (bigrams only):           7,201 
      # cjk7 (unigrams only):        117,716
      # cjk6cn (chinese dict only):   34,601
      # cjk8 (chinese dict no pos):   34,601
    end
    it "婦女 與 文學 (spaces) should have good search results" do
      resp = solr_resp_doc_ids_only({'q'=>'婦女 與 文學', 'rows'=>'20'}) 
      # soc:                           21
      # cjk1 (bigrams and unigrams):    0
      # cjk3 (bigrams only):            0
      # cjk7 (unigrams only):         107
      # cjk6cn (chinese dict only):    15
      # cjk8 (chinese dict no pos):    15
    end
    
    context "title search" do
      it "婦女與文學 (no spaces) should have good search results" do
        resp = solr_resp_doc_ids_only({'q'=>'婦女與文學', 'rows'=>'20', 'qt'=>'search_title'}) 
        # soc:                            11
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
        # cjk1 (bigrams and unigrams):   6,723
        # cjk3 (bigrams only):           6,723
        # cjk7 (unigrams only):        102,211
        # cjk6cn (chinese dict only):   32,505  
        # cjk8 (chinese dict no pos):   32,505
      end
      it "婦女 與 文學 (spaces) should have good search results" do
        resp = solr_resp_doc_ids_only({'q'=>'婦女 與 文學', 'rows'=>'20', 'qt'=>'search_title'}) 
        # soc:                           11
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
        # cjk1 (bigrams and unigrams):    0
        # cjk3 (bigrams only):            0
        # cjk7 (unigrams only):          61
        # cjk6cn (chinese dict only):    13
        # cjk8 (chinese dict no pos):    13
      end
  
    end  # title search
    
    # AND query
    # OR query
    # positionfilter ...
    # overlapping tokens ...   what if they didn't overlap and were ANDed
  end # women and literature

  context " 三國誌 becomes  三國 (bigram) and  誌 (unigram)" do
    it "三國誌 (no spaces) should have good search results" do
      resp = solr_resp_doc_ids_only({'q'=>'三國誌', 'rows'=>'20'}) 
      resp.should include(["6343505", "8246653"]).as_first(2).documents
      resp.should include(["4724601", "8250645", "6343719", "6343720"]).in_first(6).documents  # script as is
      # soc:                           242 
      # cjk1 (bigrams and unigrams):   365
      # cjk3 (bigrams only):           365
      # cjk7 (unigrams only):       71,926
      # cjk6cn (chinese dict only):    218
      # cjk8 (chinese dict no pos):    218
    end
    it "三國 誌 (space) should have good search results" do
      resp = solr_resp_doc_ids_only({'q'=>'三國 誌', 'rows'=>'20'}) 
      # soc:                           247
      # cjk1 (bigrams and unigrams):     0
      # cjk3 (bigrams only):             0 
      # cjk7 (unigrams only):          943
      # cjk6cn (chinese dict only):  1,048   
      # cjk8 (chinese dict no pos):  1,048
    end
    
    context "title search" do
      it "三國誌 (no spaces) should have good search results" do
        resp = solr_resp_doc_ids_only({'q'=>'三國誌', 'rows'=>'20', 'qt'=>'search_title'}) 
        # soc:                           162
        # cjk1 (bigrams and unigrams):   315
        # cjk3 (bigrams only):           315
        # cjk7 (unigrams only):       54,939 
        # cjk6cn (chinese dict only):    150
        # cjk8 (chinese dict no pos):    150
      end
      it "三國 誌 (space) should have good search results" do
        resp = solr_resp_doc_ids_only({'q'=>'三國 誌', 'rows'=>'20', 'qt'=>'search_title'}) 
        # soc:                           162
        # cjk1 (bigrams and unigrams):     0
        # cjk3 (bigrams only):             0 
        # cjk7 (unigrams only):          592   
        # cjk6cn (chinese dict only):    407 
        # cjk8 (chinese dict no pos):    407
      end

    # AND query
    # OR query
    # positionfilter ...
    # overlapping tokens ...   what if they didn't overlap and were ANDed
    end # title search
  end
  
  context "飄" do
    
    it "does something" do
      # best result:  6701323
      # 飄  single char search
      #   cjk6cn - chinese dict -->   69 results, but the best one is not at top
      #   cjk6ja  69, but it is at the top   also  7737681
      #   cjk8 - chinese dict but no position filter --  69 results, best at 2 top
      pending "to be implemented"
    end
    
  end
end