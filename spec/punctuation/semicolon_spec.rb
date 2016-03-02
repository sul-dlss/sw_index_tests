require 'spec_helper'

describe "semicolon in queries" do
  it "at end of query preceded by a space should be ignored" do
    resp = solr_resp_ids_from_query 'Lecture notes in statistics ;'
    expect(resp).to have_the_same_number_of_results_as(solr_resp_ids_from_query 'Lecture notes in statistics')
  end
end