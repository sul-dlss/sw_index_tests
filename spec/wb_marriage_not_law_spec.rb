# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'rspec-solr'

describe "Chinese: Word Breaks - Marriage NOT Marriage Law", :chinese => true, :fixme => true, :wordbreak => true do

  # cjk1 (indexUnigrams true, agenphraseq false)     searchworks-dev
  # cjk2 (indexUnigrams true, agenphraseq true)      searchworks-dev:3000
  # cjk3 (indexUnigrams false, agenphraseq false)   
  # cjk4 (as cjk1, but mm=2)         
  # cjk5 (add CJKBigram filter to textNoStem, indexUnigrams true, agenphraseq false)   searchworks-dev:3001

  context " 婚姻法 (marriage law) in sirsi dict, but 婚姻 (marriage) is what we wanted" do
    #  妇女 (woman)  婚姻 (marriage) dictionary length-first match misses (but should match):
    #   4200804   woman 245c, 710a;  marriage 245a, 710a  (245 first 3 chars 婚姻法 are indexed together)
    
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