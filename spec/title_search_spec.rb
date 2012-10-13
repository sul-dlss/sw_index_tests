require 'spec_helper'
require 'rspec-solr'

describe "Title Search" do
  
  it "780t, 758t included in title search: japanese journal of applied physics" do
    resp = solr_resp_doc_ids_only(title_search_args('japanese journal of applied physics'))    
    resp.should include(["365562", "491322", "491323", "7519522", "7519487", "460630", "787934"]).in_first(8).results
    resp = solr_resp_doc_ids_only(title_search_args('japanese journal of applied physics').merge({:fq => 'format:"Journal/Periodical"'}))
    resp.should include(["7519522", "365562", "491322", "491323"]).in_first(5).results
    pending "need include_at_least in rspec-solr"
    resp.should include_at_least(4).of(["7519522", "365562", "491322", "491323", "7519487"]).in_first(5).results
  end
  
  it "780t, 758t included in title search: japanese journal of applied physics PAPERS" do
    resp = solr_resp_doc_ids_only(title_search_args('japanese journal of applied physics papers'))    
    resp.should include(["365562", "491322", "7519522", "8207522"]).in_first(8).results
    resp = solr_resp_doc_ids_only(title_search_args('japanese journal of applied physics papers').merge({:fq => 'format:"Journal/Periodical"'}))    
    resp.should include(["365562", "491322", "7519522", "8207522"]).in_first(5).results
  end
  
  it "780t, 758t included in title search: japanese journal of applied physics LETTERS" do
    resp = solr_resp_doc_ids_only(title_search_args('japanese journal of applied physics letters'))    
    resp.should include(["365562", "491323", "7519487", "8207522"]).in_first(8).results
    resp = solr_resp_doc_ids_only(title_search_args('japanese journal of applied physics letters').merge({:fq => 'format:"Journal/Periodical"'}))    
    resp.should include(["365562", "491323", "7519487", "8207522"]).in_first(5).results
  end

  it "780t, 758t included in title search: journal of marine biotechnology" do
    resp = solr_resp_doc_ids_only(title_search_args('journal of marine biotechnology'))    
    resp.should include(["4450293", "1963062", "4278409"]).in_first(3).results
    resp = solr_resp_doc_ids_only(title_search_args('journal of marine biotechnology').merge({:fq => 'format:"Journal/Periodical"'}))    
    resp.should include(["4450293", "1963062", "4278409"]).in_first(3).results
  end
  
end