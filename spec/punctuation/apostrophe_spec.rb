# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'rspec-solr'

describe "Apostrophes", :jira => ['SW-648', 'SW-754'], :fixme => true do
  it "m'arthur" do
    resp = solr_resp_doc_ids_only({'q'=>"m'arthur"})
    resp.should have_fewer_results_than(solr_resp_doc_ids_only({'q'=>"marthur"}))
    # to be implemented
#    resp.should_not have_same_first_result_as(solr_resp_doc_ids_only({'q'=>"m arthur"}))
    resp.should_not include("2402216").in_first(12).documents
  end
  
end