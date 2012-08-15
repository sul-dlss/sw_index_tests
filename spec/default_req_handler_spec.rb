require 'spec_helper'
require 'rspec-solr'

describe "Default Request Handler" do
  it "'buddhism' should get 8,500-10,000 results" do
    solr_response({'q'=>'Buddhism'}.merge(doc_ids_only)).should have_at_least(8500).documents
    solr_response({'q'=>'Buddhism'}.merge(doc_ids_only)).should have_at_most(10000).documents
  end
end