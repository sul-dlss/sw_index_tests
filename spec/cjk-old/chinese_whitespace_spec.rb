# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Chinese: Extraneous Spaces (from old RLIN records?)", :chinese => true, :fixme => true do

  it "whitespace variants of 金瓶梅 (golden lotus) should get similar results" do
    resp = solr_resp_ids_from_query '金瓶梅' # 169 in soc as of 2012-11
    resp.should have_at_least(165).documents
    resp.should have_at_most(200).documents
    resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query '金瓶  梅') # 169 in soc as of 2012-11
    resp.size.should be_within(5).of(solr_resp_ids_from_query('金  瓶  梅').size) # 169 in soc as of 2012-11
  end
  
  context "whitespace variants of 三国演义 (three kingdoms?) should get similar results" do
    before(:all) do
      @三国演义_resp = solr_resp_ids_from_query '三国演义' # 113 in soc as of 2013-08-15
    end
    it "should get expected number of results" do
      # 113 in soc as of 2013-08-15
      @三国演义_resp.should have_at_least(100).documents
      @三国演义_resp.should have_at_most(130).documents
    end
    it "三国演义 should match results for  '三国 演义'" do
      @三国演义_resp.size.should be_within(5).of(solr_resp_ids_from_query('三国 演义').size) # 113 in soc as of 2013-08-15
    end
    it "三国演义 should match results for  '三  国演义'", :fixme => true do
      @三国演义_resp.size.should be_within(5).of(solr_resp_ids_from_query('三 国演义').size) # 118 in soc as of 2013-08-15
    end
    it "三国演义 should match results for  '三  国  演  义'", :fixme => true do
      @三国演义_resp.size.should be_within(5).of(solr_resp_ids_from_query('三  国  演  义').size) # 207 in soc as of 2013-08-15
    end
  end
  
end