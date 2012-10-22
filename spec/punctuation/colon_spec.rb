require 'spec_helper'
require 'rspec-solr'

describe "colons in queries" do
  it "surrounded by spaces inside phrase should be ignored" do
    resp = solr_resp_doc_ids_only({'q'=>'"Alice in Wonderland : a serie[s]"'})
    resp.should have_at_least(2).documents
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'"Alice in Wonderland a serie[s]"'}))
  end
end