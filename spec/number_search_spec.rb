require 'spec_helper'

describe "Number as Query String" do

  context "ISSN", :jira => 'VUF-169' do
    it "should work with or without the hyphen", :jira => 'VUF-404', :icu => true do
      expect(solr_resp_ids_from_query('1003-4730')).to include(['6210309']).in_first(1)
      resp = solr_resp_ids_from_query '10034730'  # we now go this high in ckeys
      expect(resp).to include(['6210309']).in_first(1)
    end

    it "'The Nation' ISSN 0027-8378 should get perfect results with and without a hyphen", :icu => true do
      resp = solr_resp_ids_from_query '0027-8378'
      expect(resp).to include(['464445', '497417', '3448713', '10039114']).in_first(6)
      #  additional ckeys:   1771808 (in 500a),  5724779  (in 776x)
      expect(resp).to include(['1771808', '5724779']).in_first(10)
      expect(resp).to have_the_same_number_of_results_as(solr_resp_ids_from_query '00278378')
    end

    it "'The Times' ISSN 0140-0460 should get great results with or without hyphen", :icu => true do
      expect(solr_resp_ids_from_query('0140-0460')).to include(['425948', '425951']).in_first(5)
      expect(solr_resp_ids_from_query('01400460')).to include(['425948', '425951']).in_first(5)
    end

    context "with X as last char" do
      before(:all) do
        @resp_w = solr_resp_ids_from_query '0046-225X'
      end
      it "should work with or without the hyphen", :icu => true do
        expect(@resp_w).to include('359795')
        expect(@resp_w).to have_the_same_number_of_results_as(solr_resp_ids_from_query '0046225X')
      end

      it "should not be case sensitive" do
        expect(@resp_w).to have_the_same_number_of_results_as(solr_resp_ids_from_query '0046-225x')
      end
    end
  end

  context "ISBN" do
    it "10 and 13 digit versions should both work" do
      resp = solr_resp_ids_from_query '0704322536'
      expect(resp).to include('1455294')
      expect(resp).to have_the_same_number_of_results_as(solr_resp_ids_from_query '9780704322530')
    end
    it "X as last char should not be case sensitive" do
      resp = solr_resp_ids_from_query '287009776X'
      expect(resp).to include('4705736')
      expect(resp).to have_the_same_number_of_results_as(solr_resp_ids_from_query '287009776x')
    end
  end

  it "ckey (doc id) as query should retrieve the record" do
    resp = solr_resp_ids_from_query '359795'
    expect(resp).to include('359795').as_first
    expect(resp.size).to be <= 3
  end

  it "barcode as query should work" do
    resp = solr_resp_ids_from_query '36105018139407'
    expect(resp).to include('6284429').as_first
    expect(resp.size).to be <= 1
  end

  context "OCLC number" do
    it "query of OCLC number should work" do
      resp = solr_resp_ids_from_query '61746916'
      expect(resp).to include('6283711').as_first
      expect(resp.size).to be <= 1
    end

    # the leading 0 is no longer returning items.
    it "leading zero shouldn't matter", :fixme => true do
      resp = solr_resp_ids_from_query '08313857'
      expect(resp).to include('7138571').as_first
      expect(resp.size).to be <= 1
    end
  end

=begin
  # LCCN no longer indexed
  context "LCCN" do
    it "10 digit LCCN should work" do
      resp = solr_resp_ids_from_query '2004005074'
      resp.should include('5666733').as_first
      resp.should have_at_most(1).documents
    end
    it "8 digit LCCN should work" do
      resp = solr_resp_ids_from_query '87017033'
      resp.should include('1726910').as_first
      resp.should have_at_most(1).documents
    end
  end
=end

end
