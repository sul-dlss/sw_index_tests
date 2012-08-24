# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'rspec-solr'

describe "Chinese: Word Breaks", :chinese => true, :fixme => true, :wordbreak => true do

  # cjk1 (indexUnigrams true, agenphraseq false)     searchworks-dev
  # cjk2 (indexUnigrams true, agenphraseq true)      searchworks-dev:3000
  # cjk3 (indexUnigrams false, agenphraseq false)   
  # cjk4 (as cjk1, but mm=2)         
  # cjk5 (add CJKBigram filter to textNoStem, indexUnigrams true, agenphraseq false)   searchworks-dev:3001

  context "some test" do
    # no space
    # space
    # phrase no space
    # phrase space
    # AND query - request handler needed
    # OR query
    # positionfilter ...
    # overlapping tokens ...   what if they didn't overlap and were ANDed
    
    # ultimately, traditional vs simplified chars, too.
  end

  
  # TODO:  two char terms.  three char terms.  longer terms.  phrase vs. non-phrase searching.
  # TODO:  phrase searches for bigram pieces in query.   Tests for single last character, too.


  # 中国地方志集成   breaks up to   中国  地方志   集成  (people's republic of china ?)
  # 
  # 245  9206370  5 char in sub a   is 2 + 1 + 2


end