# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'rspec-solr'

describe "Chinese: Single Character Searches", :chinese => true do
  
  it "title  飄 should get results", :vetted => 'vitus' do
    resp = solr_response(title_search_args('飄').merge({'fl'=>'id,vern_title_245a_display', 'facet'=>false})) 
    resp.should include('vern_title_245a_display'=>'飄').in_first(2).documents 
    resp.should include(["6701323", "7737681"]).in_first(2).documents
    resp.should have_at_least(110).documents # 117 title in soc, 154 everything in soc as of 2012-11
  end
  
  it "title  家 should get results" do
    resp = solr_response(title_search_args('家').merge({'fl'=>'id,vern_title_245a_display', 'facet'=>false}))
    resp.should include('vern_title_245a_display'=>'家').in_first(15).documents
    resp.should include("4172748") 
    resp.should have_at_least(17800).documents # 17815 title in soc as of 2012-11
  end

  it "title  禅 (zen) should get results" do
    resp = solr_response(title_search_args('禅').merge({'fl'=>'id,vern_title_245a_display', 'facet'=>false}))
    resp.should include('vern_title_245a_display'=>'禅').in_first(7).documents 
    resp.should include("6815304") 
    resp.should have_at_least(890).documents # 890 title in soc as of 2012-11
  end
  
# waiting for feedback from Vitus on whether these tests have any utility.
#  it "的 should not get many results as a single character" do
# yes, there are lots of cases where this alone is a valid word
#   searching this with another char should NOT match the single char
#   searching this alone -->  no one would use it as a search  
    # see http://www.opensourceconnections.com/2011/12/23/indexing-chinese-in-solr/
#    resp = solr_resp_ids_from_query '的' # 43400 in soc as of 2012-11
#    resp.should have_at_least(100).documents
#    resp.should have_at_most(9).documents # FIXME:  I need a decent number
#  end
  
  it "chars for reptile  爬蟲 should not retrieve results from individual chars climb  爬 and insect  蟲", :fixme => true do
    resp = solr_resp_ids_from_query ' 爬蟲'  # 7 in soc as of 2012-11
    resp.should have_at_least(5).documents
# FIXME?    
#    resp.should include("8443700") # has both simplified and traditional
#    resp.should include("8702994") # simplified only
    resp.should_not have_the_same_number_of_results_as(solr_resp_ids_from_query '爬  蟲')
  end
  
  it "chars for Hồ Chí Minh  胡志明 should not retrieve results from individual chars  胡 (recklessly), 志 (will), 明 (bright)" do
    resp = solr_resp_doc_ids_only({'q'=>'胡志明', 'rows'=>75})  # 60 in soc as of 2012-11
# FIXME? 
#    resp.should have_at_least(60).documents
    resp.should include(["6639990", "6639989"])  # title and subject
    resp.should include(["6639992", "4212852"])  # subject
    resp.should include(["6639996", "6639993"])  # subject and author
    resp.should include(["6639995", "6693163"]) # author
    resp.should include("4193803") # desired?
    resp.should_not have_the_same_number_of_results_as(solr_resp_ids_from_query '胡 志 明')   # 89 in soc as of 2012-11
  end
  
end