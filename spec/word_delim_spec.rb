require 'spec_helper'
require 'rspec-solr'

describe "Terms with Letters and Numbers or other oddities" do
  
  it "q of 'Two3' should have excellent results", :jira => 'VUF-386' do
    resp = solr_resp_doc_ids_only({'q'=>'Two3'})
    resp.should have_at_most(10).documents
    resp.should include("5732752").as_first_result
    resp.should include("8564713").in_first(2).results
    resp.should_not include("5727394")
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'two3'}))
    resp.should have_fewer_results_than(solr_resp_doc_ids_only({'q'=>'two 3'}))
  end

end