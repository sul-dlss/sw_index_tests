require 'spec_helper'

describe "Index Contents" do

  it "collection filter query for sirsi should contain all the MARC data from SIRSI (Symphony)" do
    resp = solr_resp_doc_ids_only({'fq'=>'collection:sirsi', 'rows'=>'0'})
    resp.should have_at_least(6900000).documents
  end
  
  context "DOR Digital Collections" do
    context "Kolb" do
      it "collection filter query should have at least 1150 total results" do
        resp = solr_resp_doc_ids_only({'fq'=>'collection:4084372', 'rows'=>'0'})
        resp.should have_at_least(1150).documents
      end
      it "item object should be retrieved via everything search" do
        resp = solr_resp_doc_ids_only({'q'=>'Addison Joseph'})
        resp.should include('vb267mw8946').in_first(10)
        # And I should see a portrait of a guy with big hair
      end      
    end

    context "Reid Dennis" do
      it "collection filter query should have at least 46 total results" do
        resp = solr_resp_doc_ids_only({'fq'=>'collection:6780453', 'rows'=>'0'})
        resp.should have_at_least(46).documents
      end
      it "item object should be retrieved via everything search" do
        resp = solr_resp_doc_ids_only({'q'=>'birds-eye view san francisco'})
        resp.should include(['pz572zt9333', 'nz525ps5073', 'bw260mc4853', 'mz639xs9677']).in_first(15)
      end       
    end
  end
  
end