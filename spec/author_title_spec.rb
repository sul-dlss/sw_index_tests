# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Author-Title Search" do
  
  it "author-title search for Steinbeck Pearl" do
    # it is made into a phrase search in spec_helper
    q = "Steinbeck, John, 1902-1968. Pearl"
    resp = solr_response(author_title_search_args(q).merge!({'fl'=>'id,author_person_display', 'facet'=>false}))
    resp.should have_at_least(100).documents
    resp.should have_at_most(130).documents
    resp.should include("author_person_display" => /Steinbeck/i).in_each_of_first(20).documents
    resp.should_not include("author_person_display" => /Yong/i).in_each_of_first(20).documents
  end
  
  it "author-title search for Beethoven violin concerto", :jira => 'SW-778' do
    # it is made into a phrase search in spec_helper
    q = "Beethoven, Ludwig van, 1770-1827. Concertos, violin, orchestra, op. 61, D major"
    resp = solr_response(author_title_search_args(q).merge!({'fl'=>'id,author_person_display', 'facet'=>false}))
    resp.should have_at_least(90).documents
    resp.should have_at_most(160).documents
    resp.should include("author_person_display" => /Beethoven/i).in_each_of_first(5).documents
    resp.should_not include("author_person_display" => /Stowell/i).in_each_of_first(20).documents
  end
  
end