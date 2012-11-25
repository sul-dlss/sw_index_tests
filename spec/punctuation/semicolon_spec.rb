require 'spec_helper'

describe "semicolon in queries" do
  it "at end of query preceded by a space should be ignored" do
    resp = solr_resp_doc_ids_only({'q'=>'Lecture notes in statistics ;'})
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'Lecture notes in statistics'}))
  end
end