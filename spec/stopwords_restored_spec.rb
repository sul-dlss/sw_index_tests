require 'spec_helper'

describe "Stopwords such as 'the' 'a' 'or' should now work" do

  it "A Zukofsky", :jira => 'SW-501' do
    resp = solr_resp_doc_ids_only({'q'=>'A Zukofsky'}) 
    resp.should include(["9082824", "1398728"]).in_first(20).results
  end
  
  it 'Zukofsky "A" (with quotes)', :jira => 'SW-501' do
    resp = solr_resp_doc_ids_only({'q'=>'"A" Zukofsky'}) 
    resp.should include(["9082824", "1398728"]).in_first(20).results
  end

  it "Search for OR spektrum (must be with lowercase 'or', otherwise boolean without first clause)", :jira => 'SW-483' do
    resp = solr_resp_doc_ids_only({'q'=>'or spektrum'}) 
    resp.should include("490100").in_first(3).results
    resp = solr_response({'q'=>'or spektrum', 'fq' => 'format:"Journal/Periodical"', 'fl' => 'id', 'facet' => 'false'}) 
    resp.should include("490100").in_first(1).results
  end

  it "'to be or not to be' should get results", :jira => 'SW-613' do
    resp = solr_resp_doc_ids_only({'q'=>'to be or not to be'}) 
    resp.should have_documents
  end
  
  it "'the one'", :jira => 'SW-613' do
    resp = solr_resp_doc_ids_only({'q'=>'the one'}) 
    resp.should include("4805489").in_first(3).results
    resp.should_not include("2860701")
  end

  it '"IT and Society"', :jira => 'SW-500' do
    resp = solr_resp_doc_ids_only({'q'=>'"IT and Society"'}) 
    resp.should include("8167359").in_first(7).results
  end

  it '"IT *and* Society" qt=advanced, description qf', :jira => 'SW-500', :fixme => [true, 'used to work'] do
    resp = solr_resp_doc_ids_only({'q'=>'{!qf=$qf_description pf=$qf_description}(IT and Society)', 'qt'=>'advanced'}) 
#    resp = solr_resp_doc_ids_only({'q'=>'{!qf=all_search pf=all_search^10}(IT and Society)', 'qt'=>'advanced'}) 
    resp.should include("8167359").in_first(7).results
  end

  it '"IT *&* Society" qt=advanced, description qf', :jira => 'SW-500', :fixme => [true, 'used to work'] do
    resp = solr_resp_doc_ids_only({'q'=>'{!qf=$qf_description pf=$qf_description}(IT & Society)', 'qt'=>'advanced'}) 
    resp.should include("8167359").in_first(7).results
    resp = solr_resp_doc_ids_only({'q'=>'{!qf=$qf_description pf=$qf_description}(IT&Society)', 'qt'=>'advanced'}) 
    resp.should include("8167359").in_first(7).results
  end
  
  it "query stopwords should not be dropped in subject searches", :jira => 'SW-372' do
    resp = solr_resp_doc_ids_only(subject_search_args('"Archaeology in literature"'))
    resp.should include("8517619")
    resp.should_not include(["8545853", "6653471"])
  end
  
  
end