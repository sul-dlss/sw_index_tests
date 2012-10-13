require 'spec_helper'
require 'rspec-solr'

describe "Subject Search" do
  
  it "Quoted individual subjects vs. Quoting the entire subject" do
    resp = solr_resp_doc_ids_only(subject_search_args('"Older people" "Abuse of"'))    
    resp.should have_documents
    resp.should have_more_documents_than(solr_resp_doc_ids_only(subject_search_args('"Older people Abuse of"')))
  end
  
end