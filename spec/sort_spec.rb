require 'spec_helper'

describe "sorting results" do

  context "empty query" do
    it "default sort should be by pub date desc (not in Solr default of document id order)" do
      resp = solr_response({'fl'=>'id,pub_date', 'facet'=>false})
      resp.should_not include('1') # should not be in document id order
      year = Time.new.year
      # TODO:  waiting for gdor fix to Walters pub_date_sort values
  #    resp.should include("pub_date" => /(#{year}|#{year + 1}|#{year + 2})/).in_each_of_first(20).documents
    end

    it "with facet format:Book; default sort should be by pub date desc then title asc" do
      resp = solr_response({'fq'=>'format:Book', 'fl'=>'id,pub_date', 'facet'=>false})
      year = Time.new.year
      resp.should include("pub_date" => /(#{year}|#{year + 1}|#{year + 2})/).in_each_of_first(20).documents
      # _Applications of Microsoft Excel in analytical chemistry_  before  _Chemistry : a molecular approach_
      resp.should include('9937771').before('9937759')
    end
    
    it "with facet access:Online; default sort should be by pub date desc then title asc" do
      resp = solr_response({'fq'=>'access_facet:Online', 'fl'=>'id,pub_date', 'facet'=>false})
      resp.should_not include('7342') # Solidarité, 1902
    end    
  end # empty query

end