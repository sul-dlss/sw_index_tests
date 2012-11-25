require 'spec_helper'

describe "Searches With Parens" do
  
  it "q of 'french beans food scares' has specific match and non-match" do
    resp = solr_resp_doc_ids_only({'q'=>'french beans food scares'})
    resp.should include("7716344").as_first_result
    resp.should_not include("69555562")
  end
  
end