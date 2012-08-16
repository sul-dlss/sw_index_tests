require 'spec_helper'
require 'rspec-solr'

describe "Default Request Handler" do
  
  it "q of 'Buddhism' should get 8,500-10,500 results" do
    resp = solr_resp_doc_ids_only({'q'=>'Buddhism'})
    resp.should have_at_least(8500).documents
    resp.should have_at_most(10500).documents
  end
  
  it "q of 'String quartets Parts' and variants should be plausible " do
    resp = solr_resp_doc_ids_only({'q'=>'String quartets Parts'})
    resp.should have_at_least(2000).documents
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'(String quartets Parts)'}))
    resp.should have_more_results_than(solr_resp_doc_ids_only({'q'=>'"String quartets Parts"'}))
  end
  
  it "q of 'french beans food scares' should get specific match and non-match" do
    resp = solr_resp_doc_ids_only({'q'=>'french beans food scares'})
    resp.should include("7716344").as_first_result
    resp.should_not include("69555562")
  end
  
  it "matches in title should sort first" do
    resp = solr_resp_doc_ids_only({'q'=>'waffle', 'rows'=>'20'})
    resp.should include("6720427").as_first_result
    resp.should include("6720427").before("7763651")
    resp.should include("4535360").before("7763651")
    resp.should include("2716658").before("6546657")
    resp.should include("5087572").before("6546657")
  end
  
  it "single result expected: 'jill kerr conway' " do
    resp = solr_resp_doc_ids_only({'q'=>'jill kerr conway'})
    resp.should have_at_most(3).results
    resp.should include("4735430").as_first_result
    resp2 = solr_resp_doc_ids_only({'q'=>'jill k. conway'})
    resp.should have_fewer_results_than(resp2)
  end
  
  it "single character as term: 'jill k conway' " do
    resp = solr_resp_doc_ids_only({'q'=>'jill k. conway'})
    resp.should include("4735430")
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'jill k conway'}))
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'k conway jill'}))
  end
  
  it "history of the jews by paul johnson", :jira => 'VUF-510' do
    resp = solr_resp_doc_ids_only({'q'=>'history of the jews by paul johnson'})
    resp.should include(["1665541", "3141358"]).in_first(3).results
  end

end