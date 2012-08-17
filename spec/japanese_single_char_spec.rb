# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'rspec-solr'

describe "Japanese: Single Character Searches", :japanese => true, :fixme => true do
  
  it "title  乱 should get results" do
    resp = solr_response({'q'=>'乱', 'fl'=>'id,vern_title_245a_display', 'qt'=>'search_title', 'facet'=>false}) 
    resp.should include('vern_title_245a_display'=>'乱').in_first(4).documents 
    resp.should include("6260985") # famous movie by Akira Kurosawa
    resp.should have_at_least(695).documents # 4 in prod, 695 title in soc
  end
  
  it "title  禪 (zen) should get results" do
    resp = solr_response({'q'=>'禪', 'fl'=>'id,vern_title_245a_display', 'qt'=>'search_title', 'facet'=>false}) 
    resp.should include('vern_title_245a_display'=>'禪').in_first(6).documents 
    resp.should include("6667691") 
    resp.should have_at_least(890).documents # 6 in prod, 890 title in soc
  end
  
end