# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Apostrophes", :jira => ['SW-648', 'SW-754'], :fixme => true do
  it "m'arthur" do
    resp = solr_resp_ids_from_query "m'arthur"
    expect(resp).to have_fewer_results_than(solr_resp_ids_from_query "marthur")
    expect(resp).not_to include("2402216").in_first(12).documents
    skip "need to implement have_same_first_result_as"
#    resp.should_not have_same_first_result_as(solr_resp_ids_from_query "m arthur" )
  end
  
  it "ministere l'education" do
    resp = solr_resp_ids_from_query "ministere l'education"
    expect(resp).to have_the_same_number_of_results_as(solr_resp_ids_from_query "ministere de l'education")
    expect(resp.size).to be >= 875
  end
  
end