require 'spec_helper'

describe "Index Contents" do

  it "collection filter query for sirsi should contain all the MARC data from SIRSI (Symphony)" do
    resp = solr_resp_doc_ids_only({'fq'=>'collection:sirsi', 'rows'=>'0'})
    resp.should have_at_least(6850000).documents
  end
  
  context "Image Gallery Collections" do
    context "Kolb" do
      it "collection filter query should have at least 1150 total results" do
        resp = solr_resp_doc_ids_only({'fq'=>'collection:"Leon Kolb Collection of Portraits"', 'rows'=>'0'})
        resp.should have_at_least(1150).documents
      end
      it "item object should be retrieved via everything search" do
        resp = solr_resp_doc_ids_only({'q'=>'Bourbon Antoine'})
        resp.should include('ikolb-0147').in_first(10)
        # And I should see a portrait of a guy with big hair
      end      
    end

    context "Reid Dennis" do
      it "collection filter query should have at least 1150 total results" do
        resp = solr_resp_doc_ids_only({'fq'=>'collection:"The Reid W. Dennis Collection of California Lithographs"', 'rows'=>'0'})
        resp.should have_at_least(46).documents
      end
      it "item object should be retrieved via everything search" do
        resp = solr_resp_doc_ids_only({'q'=>'birds-eye view san francisco'})
        resp.should include(['ird-250', 'ird-122', 'ird-316']).in_first(10)
      end       
    end
  end
  
end