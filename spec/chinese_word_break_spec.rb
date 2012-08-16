# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'rspec-solr'

describe "Chinese: Word Breaks", :chinese => true do
  # TODO:  query time parsing  vs.   index time parsing
  
  it "should parse out 中国 (china)  经济 （economic)  政策 (policy)" do
    resp = solr_resp_doc_ids_only({'q'=>'中国经济政策'}) # 0 in prod, 88 in soc
    resp.should have_at_least(85).documents
    resp.size.should be_within(5).of(solr_resp_doc_ids_only({'q'=>'中国  经济  政策'}).size) # 0 in prod, 194 in soc
  end

  it "should parse out 中国 (china)  经济 （economic)  政策 (policy) - title search" do
    resp = solr_resp_doc_ids_only({'q'=>'中国经济政策', 'qt'=>'search_title'}) # 0 in prod, 51 in soc
    resp.should have_at_least(50).documents
    resp.should have_at_most(75).documents
    resp.size.should be_within(5).of(solr_resp_doc_ids_only({'q'=>'中国  经济  政策', 'qt'=>'search_title'}).size) # 0 in prod, 51 in soc
    resp.should have_fewer_results_than(solr_resp_doc_ids_only({'q'=>'中国经济政策'})) # 0 in prod, 88 in soc
  end
  
  it "should parse out  妇女 (woman) 婚姻 (marriage)" do
    resp = solr_resp_doc_ids_only({'q'=>'妇女  婚姻'}) # 0 in prod, # 20 in soc
    resp.should have_at_least(20).documents
    resp.size.should be_within(3).of(solr_resp_doc_ids_only({'q'=>'妇女婚姻'}).size) # 0 in prod, 12 in soc
  end

end