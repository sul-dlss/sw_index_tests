# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'rspec-solr'

describe "Chinese: Extraneous Spaces (from old RLIN records?)", :chinese => true, :fixme => true do

  it "whitespace variants of 金瓶梅 should get similar results" do
    resp = solr_resp_doc_ids_only({'q'=>'金瓶梅'}) # 0 in prod, 169 in soc
    resp.should have_at_least(165).documents
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'金瓶  梅'})) # 0 in prod, 169 in soc
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'金  瓶  梅'})) # 0 in prod, 169 in soc
  end
  
  it "whitespace variants of 三国演义 should get similar results" do
    resp = solr_resp_doc_ids_only({'q'=>'三 国演义'}) # 71 in prod, 113 in soc
    resp.should have_at_least(100).documents
    resp.should have_at_most(125).documents
    resp.size.should be_within(5).of(solr_resp_doc_ids_only({'q'=>'三国 演义'}).size) # 0 in prod, 110 in soc
    resp.size.should be_within(5).of(solr_resp_doc_ids_only({'q'=>'三  国  演  义'}).size) # 0 in prod, 183 in soc
  end
  
end