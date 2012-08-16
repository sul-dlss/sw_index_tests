# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'rspec-solr'

describe "Chinese Searching - Extraneous Spaces (from old RLIN records?)", :chinese => true do

  it "whitespace variants of 金瓶梅 should get similar results" do
    resp = solr_resp_doc_ids_only({'q'=>'金瓶梅'})
    resp.should have_at_least(160).documents
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'金瓶  梅'}))
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'金  瓶  梅'}))
  end
  
  it "whitespace variants of 三国演义 should get similar results" do
    resp = solr_resp_doc_ids_only({'q'=>'三 国演义'}) # 71 in prod
    resp.should have_at_least(100).documents
    resp.should have_at_most(125).documents
    resp.size.should be_within(5).of(solr_resp_doc_ids_only({'q'=>'三国  演义'}).size) # 0 in prod
    resp.size.should be_within(5).of(solr_resp_doc_ids_only({'q'=>'三国 演义'}).size) # 0 in prod
    resp.size.should be_within(5).of(solr_resp_doc_ids_only({'q'=>'三  国  演  义'}).size) # 0 in prod
  end
  
end