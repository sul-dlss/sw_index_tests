require 'spec_helper'

describe "callnum search" do
  
  context "LC" do
    it "M452" do
      resp = solr_resp_doc_ids_only(callnum_search_args('M452'))
      resp.should have_at_least(2600).documents
      resp.should have_at_most(3000).documents
    end
    
    it "DC314 .L92 A4 1872", :jira => 'VUF-1940' do
      resp = solr_resp_doc_ids_only(callnum_search_args('"DC314 .L92 A4 1872"'))
      resp.should include('6425766').in_first(3)
    end
    it "DC314 .L92 A4", :jira => 'VUF-1940' do
      resp = solr_resp_doc_ids_only(callnum_search_args('"DC314 .L92 A4"'))
      resp.should include('6425766').in_first(3)
    end
    it "DC314 .L92", :jira => 'VUF-1940' do
      resp = solr_resp_doc_ids_only(callnum_search_args('"DC314 .L92"'))
      resp.should include('6425766').in_first(3)
    end
    
    it "QH185.3", :jira => 'VUF-1882' do
      resp = solr_resp_doc_ids_only(callnum_search_args('QH185.3'))
      resp.should include('9087723').in_first(3)
      resp.should have_at_most(3).documents
  	  # would like search for full call number to work:  QH185.3 .VIS 2010 F 
    end
  end # context LC
  
  context "SPEC (special collections) call number" do
    it "M1437", :jira => 'SW-78' do
      resp = solr_resp_doc_ids_only(callnum_search_args('M1437'))
      resp.should include('6972310')
    end
  end
  
  context "ALPHANUM" do
    it "ZDVD 12741", :jira => 'SW-436' do
      resp = solr_resp_doc_ids_only(callnum_search_args('"ZDVD 12741"'))
      resp.should include('6635999').as_first
      resp.should have_at_most(1).document
    end
    it "MFILM N.S. 3078", :jira => 'SW-1493' do
      resp = solr_resp_doc_ids_only(callnum_search_args('"MFILM N.S. 3078"'))
      resp.should include('580114').as_first
      resp.should have_at_most(1).document
    end
    it "ZCS ENG 57 TAPE", :jira => 'SW-436' do
      resp = solr_resp_doc_ids_only(callnum_search_args('"ZCS ENG 57 TAPE"'))
      resp.should include('3440375').as_first
      resp.should have_at_most(1).document
    end
  end 
  
end