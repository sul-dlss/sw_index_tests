# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'rspec-solr'

describe "Chinese Searching - Word Segmentation" do
  # TODO:  query time parsing  vs.   index time parsing
  
  it "should parse out 中国 (china)  经济 （economic)  政策 (policy)" do
    resp = solr_resp_doc_ids_only({'q'=>'中国经济政策'})
    resp.should have_at_least(85).documents
  end

  it "should parse out 中国 (china)  经济 （economic)  政策 (policy) - title search" do
    resp = solr_resp_doc_ids_only({'q'=>'中国经济政策', 'qt'=>'search_title'})
    resp.should have_at_least(50).documents
    resp.should have_at_most(75).documents
    resp.should have_fewer_results_than(solr_resp_doc_ids_only({'q'=>'中国经济政策'}))
  end
  
  it "should parse out  妇女 (woman) 婚姻 (marriage)" do
    resp = solr_resp_doc_ids_only({'q'=>'妇女  婚姻'})
    resp.should have_at_least(20).documents
  end

end