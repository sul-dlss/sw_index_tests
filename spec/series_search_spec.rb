require 'spec_helper'

describe "Series Search" do
  
  it "lecture notes in computer science" do
    resp = solr_resp_doc_ids_only(series_search_args('lecture notes in computer science'))
    resp.should have_at_least(7000).results
    resp.should have_at_most(8000).results
  end
  
  it "Lecture notes in statistics (Springer-Verlag)", :jira => 'VUF-1221' do
    resp = solr_resp_doc_ids_only(series_search_args('Lecture notes in statistics (Springer-Verlag)'))
    resp.should have_at_least(175).results
    resp.should have_at_most(225).results
  end
  
  it "Japanese journal of applied physics" do
    resp = solr_resp_doc_ids_only(series_search_args('Japanese journal of applied physics'))
    resp.should have_at_least(15).results
    resp.should have_at_most(30).results
  end
  
  it "Studies in Modern Poetry", :jira => 'SW-688' do
    resp = solr_resp_doc_ids_only(series_search_args('Studies in Modern Poetry'))
    resp.should have_at_least(10).results
    resp.should have_at_most(20).results
  end
  
  it "Cahiers series", :jira => 'VUF-1031' do
    resp = solr_resp_doc_ids_only(series_search_args('"Cahiers series"'))
    resp.should have_at_least(5).results
    resp.should have_at_most(60).results
  end

end