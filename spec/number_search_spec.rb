require 'spec_helper'

describe "Number as Query String" do
  
  context "ISSN", :jira => 'VUF-169' do
    it "should work with or without the hyphen", :jira => 'VUF-404' do
      resp = solr_resp_doc_ids_only({'q'=>'1003-4730'})
      resp.should include('6210309')
      resp = solr_resp_doc_ids_only({'q'=>'10034730'})  # we now go this high in ckeys
      resp.should include('6210309').as_first
    end
    
    it "'The Nation' ISSN should get perfect results with and without a hyphen" do
      resp = solr_resp_doc_ids_only({'q'=>'0027-8378'})
      resp.should include(['464445', '497417', '3448713', '10039114']).in_first(6)
      #  additional ckeys:   1771808 (in 500a),  5724779  (in 776x)
      resp.should include(['1771808', '5724779']).in_first(10)
      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'00278378'}))
    end
    
    it "X as last char should not be case sensitive" do
      resp = solr_resp_doc_ids_only({'q'=>'0046-225X'})
      resp.should include('359795')
      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'0046-225x'}))
    end    
  end
  
  context "ISBN" do
    it "10 and 13 digit versions should both work" do
      resp = solr_resp_doc_ids_only({'q'=>'0704322536'})
      resp.should include('1455294')
      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'9780704322530'}))
    end
    it "X as last char should not be case sensitive" do
      resp = solr_resp_doc_ids_only({'q'=>'287009776X'})
      resp.should include('4705736')
      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'287009776x'}))
    end
  end
  
  it "ckey (doc id) as query should retrieve the record" do
    resp = solr_resp_doc_ids_only({'q'=>'359795'})
    resp.should include('359795').as_first
    resp.should have_at_most(3).documents
  end

  it "barcode as query should work" do
    resp = solr_resp_doc_ids_only({'q'=>'36105018139407'})
    resp.should include('6284429').as_first
    resp.should have_at_most(1).documents
  end

  context "OCLC number" do
    it "query of OCLC number should work" do
      resp = solr_resp_doc_ids_only({'q'=>'61746916'})
      resp.should include('6283711').as_first
      resp.should have_at_most(1).documents
    end
    
    # the leading 0 is no longer returning items.
    it "leading zero shouldn't matter", :fixme => true do
      resp = solr_resp_doc_ids_only({'q'=>'08313857'})
      resp.should include('7138571').as_first
      resp.should have_at_most(1).documents
    end
  end

=begin  
  # LCCN no longer indexed
  context "LCCN" do
    it "10 digit LCCN should work" do
      resp = solr_resp_doc_ids_only({'q'=>'2004005074'})
      resp.should include('5666733').as_first
      resp.should have_at_most(1).documents
    end
    it "8 digit LCCN should work" do
      resp = solr_resp_doc_ids_only({'q'=>'87017033'})
      resp.should include('1726910').as_first
      resp.should have_at_most(1).documents
    end
  end
=end
  
end