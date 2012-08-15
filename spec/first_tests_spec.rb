require 'spec_helper'
require 'rspec-solr'

describe "Get Tests Running" do
    
  context "testing" do

    it "search for night should have at least 17000 docs" do
      solr_response({'q'=>'night', 'fl'=>'id', 'facet'=>'false'}).should have_at_least(17000).documents
    end

  end  
end

