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
  
=begin  
# waiting for feedback from Vitus on whether these tests have any utility.
  it "的 should not get many results as a single character" do
# yes, there are lots of cases where this alone is a valid word
#   searching this with another char should NOT match the single char
#   searching this alone -->  no one would use it as a search  
    # see http://www.opensourceconnections.com/2011/12/23/indexing-chinese-in-solr/
    resp = solr_resp_doc_ids_only({'q'=>'的'})  # 90 in prod, 43400 in soc
    resp.should have_at_least(100).documents
    resp.should have_at_most(9).documents # FIXME:  I need a decent number
  end
  
  it "chars for reptile  爬蟲 should not retrieve results from individual chars climb  爬 and insect  蟲" do
    resp = solr_resp_doc_ids_only({'q'=>'爬蟲'})  # 0 in prod, 7 in soc
    resp.should have_at_least(5).documents
    8443700 # has both simplified and traditional
    8702994 # simplified only
    
    resp.should have_fewer_results_than(solr_resp_doc_ids_only({'q'=>'爬  蟲'})) # FIXME:  true?  false?
  end
  
  it "chars for Hồ Chí Minh  胡志明 should not retrieve results from individual chars  胡 (recklessly), 志 (will), 明 (bright)" do
    resp = solr_resp_doc_ids_only({'q'=>'胡志明'})  # 16 in prod, 60 in soc
    resp.should include["6639990", "6639989"]  # title and subject
    resp.should include["6639992", "4212852"]  # subject
    resp.should include["6639996", "6639993"]  # subject and author
    resp.should include["6639995", "6693163"] # author
# is 4193803  desired?        
    resp2 = solr_resp_doc_ids_only({'q'=>'胡 志 明'})  # 0 in prod, 89 in soc
    resp.should have_fewer_results_than(resp2)  # FIXME:  true?  false?
  end
=end
  
end