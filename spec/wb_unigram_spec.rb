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
    # 舊 (old)  小說 (fiction)
    # symph title search 11 records
    # 
    # cjk1, 4 (no space) everything search 3102 records;   cjk2, 3  3 records  (3 records have 3 chars together)
    # cjk1, 2, 3, 4  舊  小說  0 records
    # 
    # no space
    # space
    # phrase no space
    # phrase space
    # AND query
    # OR query
    # positionfilter ...
    # overlapping tokens ...   what if they didn't overlap and were ANDed
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