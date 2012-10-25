# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'rspec-solr'

# need these to work -- CJKBigram approach could interfere with that
describe "Japanese: Single Character Searches", :japanese => true, :fixme => true do
  
  # TODO:  want  hiragana, katakana?  but only matters if we bigram?
  
  it "title  乱 (modern) should get results" do
    resp = solr_response(title_search_args('乱').merge({'fl'=>'id,vern_title_245a_display', 'facet'=>false})) 
    resp.should include('vern_title_245a_display'=>'乱').in_first(4).documents 
    resp.should include("6260985") # famous movie by Akira Kurosawa
    resp.should have_at_least(695).documents # 4 in prod, 695 title in soc
  end

  it "title Zen  禅 (modern) should get results" do
    resp = solr_response(title_search_args('禅').merge({'fl'=>'id,vern_title_245a_display', 'facet'=>false})) 
    resp.should include('vern_title_245a_display'=>'禅').in_first(6).documents 
    resp.should include("4193363") 
    resp.should have_at_least(890).documents # 6 in prod, 890 title in soc
  end
  
end