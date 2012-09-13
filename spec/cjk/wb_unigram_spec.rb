# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'rspec-solr'

describe "Chinese: Word Breaks - Unigrams", :chinese => true, :fixme => true, :wordbreak => true do
  # see chinese_old_fiction_spec  for  "舊小說 (old fiction) becomes  舊 (unigram) and  小說 (bigram)
  # see women_and_literature_spec for  "婦女與文學 becomes  婦女 (women)  與 (and)   文學 (literature)
  
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