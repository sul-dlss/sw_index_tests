# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "CJK Advanced Search" do
  
  context "Publication Info" do
    context "Publisher: Akatsuki Shobō" do
      before(:all) do
        @resp = cjk_adv_solr_resp({'q'=>"#{cjk_pub_info_query('曉書房')}"}.merge(solr_args))
      end
      it "num expected" do
        # there are only 2 exact matches as of 2013-10-25; these are the only ones found w/o cjk search fields
        @resp.should have_at_least(3).documents
        @resp.should have_at_most(10).documents  # 41 match everything search
      end
      it "exact matches first" do
        exact_matches = ['6321193', '6355327']
        @resp.should include(exact_matches).in_first(exact_matches.size).documents
      end
      it "inexact matches present" do
        @resp.should include('6668315').in_first(20).documents
      end
    end
    
    context "Publisher: Mineruva Shobō" do
      before(:all) do
        @resp = cjk_adv_solr_resp({'q'=>"#{cjk_pub_info_query('ミネルヴァ 書房')}"}.merge(solr_args))
      end
      it "num expected" do
        # there are only 6 exact matches as of 2013-10-25; these are the only ones found w/o cjk search fields
        @resp.should have_at_least(800).documents
        @resp.should have_at_most(914).documents  # 915 match everything search
      end
      it "exact matches first" do
        exact_matches = ['4196577', '4203788', '4199853', '4198109', '4203994', '4197487']
        @resp.should include(exact_matches).in_first(exact_matches.size).documents
      end
      it "matches without spaces present" do
        no_space_exact_matches = ['9714673', '9714675']  # 2 out of many
        @resp.should include(no_space_exact_matches).in_first(20).documents
      end
    end
    
    context "Place:  Okinawa-ken Ginowan-shi" do
      exact_matches = ['9392905', '9350464']
      before(:all) do
        @resp = cjk_adv_solr_resp({'q'=>"#{cjk_pub_info_query('沖縄県宜野湾市')}"}.merge(solr_args))
      end
      it "num expected" do
        # there are 14 exact matches as of 2013-10-25; these are the only ones found w/o cjk search fields
        @resp.should have_at_least(15).documents
        @resp.should have_at_most(16).documents # 17 match everything search
      end
      it "exact matches first" do
        @resp.should include(exact_matches).in_first(exact_matches.size).documents
      end
      it "inexact matches present" do
        inexact_matches = '8630944'
        @resp.should include(inexact_matches).in_first(20).documents
      end
    end
    
    context "Unigram" do
      it "Place: Tsu (津):  num expected" do
        resp = cjk_adv_solr_resp({'q'=>"#{cjk_pub_info_query('tsu 津')}"}.merge(solr_args))
        resp.should have_at_least(30).documents # matches 19 wo cjk search fields
        resp.should have_at_most(50).documents # 55 match everything search
      end
      it "Place: 津  (no Tsu term): num expected" do
        resp = cjk_adv_solr_resp({'q'=>"#{cjk_pub_info_query('津')}"}.merge(solr_args))
        resp.should have_at_least(30).documents # matches 19 wo cjk search fields
        resp.should have_at_most(3500).documents # 6560 match everything search
      end
    end
    
=begin    
    context "publication and title", :jira => 'SW-974' do
      expected = ['9617331', '5175639', '4822276']
      #  I put "济南“ (city name) in search query box for Publisher, place, year, and "日报” （daily newspaper) in the box for Title, 
    end
=end    
  end # Publication Info
  
  
  # send a GET request to the indicated Solr request handler with the indicated Solr parameters
  # @param solr_params [Hash] the key/value pairs to be sent to Solr as HTTP parameters
  # @param req_handler [String] the pathname of the desired Solr request handler (defaults to 'select') 
  # @return [RSpecSolr::SolrResponseHash] object for rspec-solr testing the Solr response 
  def cjk_adv_solr_resp(solr_params, req_handler='select')
    q_val = solr_params['q']
    if num_cjk_uni(q_val) == 0
      RSpecSolr::SolrResponseHash.new(solr_conn.send_and_receive(req_handler, {:method => :get, :params => solr_params.merge(solr_args)}))
    else
      RSpecSolr::SolrResponseHash.new(solr_conn.send_and_receive(req_handler, {:method => :get, :params => solr_params.merge(solr_args).merge(cjk_mm_qs_params(q_val))}))
    end # have CJK in query
  end
  
  
  def cjk_title_query terms
    '_query_:"{!edismax qf=$qf_title_cjk pf=$pf_title_cjk pf3=$pf3_title_cjk pf2=$pf2_title_cjk}' + terms + '"'
  end
  def cjk_author_query terms
    '_query_:"{!edismax qf=$qf_author_cjk pf=$pf_author_cjk pf3=$pf3_author_cjk pf2=$pf2_author_cjk}' + terms + '"'
  end
  def cjk_subject_query terms
    '_query_:"{!edismax qf=$qf_subject_cjk pf=$pf_subject_cjk pf3=$pf3_subject_cjk pf2=$pf2_subject_cjk}' + terms + '"'
  end
  def cjk_description_query terms
    '_query_:"{!edismax qf=$qf_description_cjk pf=$pf_description_cjk pf3=$pf3_description_cjk pf2=$pf2_description_cjk}' + terms + '"'
  end
  def cjk_summary_query terms
    '_query_:"{!edismax qf=$qf_summary_cjk pf=$pf_summary_cjk pf3=$pf3_summary_cjk pf2=$pf2_summary_cjk}' + terms + '"'
  end
  def cjk_pub_info_query(terms)
    '_query_:"{!edismax qf=$qf_pub_info_cjk pf=$pf_pub_info_cjk pf3=$pf3_pub_info_cjk pf2=$pf2_pub_info_cjk}' + terms + '"'
  end
  def number_query terms
    '_query_:"{!edismax qf=$qf_number pf=$pf_number pf3=$pf3_number pf2=$pf2_number}' + terms + '"'
  end
  def solr_args
    {"defType"=>"lucene", "testing"=>"sw_index_test"}.merge(doc_ids_only)
  end
  
  
end