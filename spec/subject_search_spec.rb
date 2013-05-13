require 'spec_helper'

describe "Subject Search" do
  
  it "Quoted individual subjects vs. Quoting the entire subject", :jira => 'SW-196' do
    resp = solr_resp_doc_ids_only(subject_search_args('"Older people" "Abuse of"'))
    resp.should have_documents
    resp.should_not include("7631176")
    resp.should have_more_documents_than(solr_resp_doc_ids_only(subject_search_args('"Older people Abuse of"')))
  end
  
  it "'Archaeology and literature' vs. 'Archaeology in literature'", :jira => 'SW-372' do
    resp = solr_resp_doc_ids_only(subject_search_args('"Archaeology and literature"'))
    resp.should have_at_most(5).results
    resp.should include(["8517619", "6653471"])
    resp.should_not include("9388767")  # only has 'in
    resp.should_not include("8545853")  # has neither
    resp = solr_resp_doc_ids_only(subject_search_args('"Archaeology in literature"').merge({:rows => 25}))
    resp.should have_at_least(15).results
    resp.should have_at_most(25).results
    resp.should include(["8517619", "9388767"])
    resp.should_not include("6653471")   #  only has 'and'
    resp.should_not include("8545853")  # has neither
  end

  it "china women history", :jira => 'VUF-873' do
    resp = solr_resp_doc_ids_only(subject_search_args('China women history').merge({:fq => 'language:English'}))
    resp.should have_at_least(170).results
    resp.should have_at_most(250).results
  end
  
  it "Rock music 1951-1960", :jira => 'VUF-388' do
    resp = solr_resp_doc_ids_only(subject_search_args('Rock music 1951-1960'))
    resp.should have_at_least(20).results
    resp.should have_at_most(35).results
  end
  
end