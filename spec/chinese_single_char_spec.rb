# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'rspec-solr'

describe "Chinese: Single Character Searches", :chinese => true, :fixme => true do
  
  it "title  飄 should get results" do
    resp = solr_response({'q'=>'飄', 'fl'=>'id,vern_title_245a_display', 'qt'=>'search_title', 'facet'=>false}) 
    resp.should include('vern_title_245a_display'=>'飄').in_first(2).documents 
    resp.should include("6701323")
    resp.should have_at_least(110).documents # 2 in prod, 117 title in soc, 154 everything in soc
  end
  
  it "title  家 should get results" do
    resp = solr_response({'q'=>'家', 'fl'=>'id,vern_title_245a_display', 'rows'=>20, 'qt'=>'search_title', 'facet'=>false}) 
    resp.should include('vern_title_245a_display'=>'家').in_first(15).documents
    resp.should include("4172748") 
    resp.should have_at_least(17800).documents # 81 in prod, 17815 title in soc, 
  end

  it "title  禅 (zen) should get results" do
    resp = solr_response({'q'=>'禅', 'fl'=>'id,vern_title_245a_display', 'qt'=>'search_title', 'facet'=>false}) 
    resp.should include('vern_title_245a_display'=>'禅').in_first(7).documents 
    resp.should include("6815304") 
    resp.should have_at_least(890).documents # 7 in prod, 890 title in soc
  end
  
end