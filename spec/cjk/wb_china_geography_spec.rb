# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'rspec-solr'

describe "Chinese: Word Breaks - a place in China geography", :chinese => true, :fixme => true, :wordbreak => true do

  # cjk1 (indexUnigrams true, agenphraseq false)     searchworks-dev
  # cjk3 (indexUnigrams false, agenphraseq false)   
  # cjk6

  context " 郑州 (a place in China)  地理 (geography)" do
    context "title search" do
      it "郑州 地理 as two terms should have good search results" do
        resp = solr_resp_doc_ids_only({'q'=>'郑州 地理', 'qt'=>'search_title'})
        resp.should include("9612993").as_first.result
        resp.should have_at_most(1).documents
      end
      it "郑州地理 should have good search results" do
        resp = solr_resp_doc_ids_only({'q'=>'郑州地理', 'qt'=>'search_title'}) 
        resp.should include("9612993").as_first.result  # it's second
      end
      
      # 郑州地理 title search
      #  socrates:  1 result:  
      #    9612993     郑州地理 never;  郑州  245a, 520a, 651a;   地理  245a (but two chars between), 520a
      #  cjk1:    2305 results
      #    6324746     郑州地理 never;  郑州 never;  地理 245a;   州地 (nonsense) 245a  (abcd - never, ab - never, cd - 245a; bc - 245a, bcd - 245a)
      #    9612993 is 2nd
      #    ...
      #    
      #  郑州  地理 title search
      #  socrates:  1 result:   9612993
      #    cjk1:   1 result
      # 
      #   郑州地理  title search
      
    end
    
  end
    
end