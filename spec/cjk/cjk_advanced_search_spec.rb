# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "CJK Advanced Search" do
  # in a non-CJK aware world, the only matches are ones where the whitespace matches.
  # in a CJK-aware world, matches also include word boundaries that aren't denoted by whitespace
  # in a CJK-aware advanced search, we should get matches that are only in the desired fields 
  #   AND the matches shouldn't require whitespace for word boundaries
  
  # NOTE:  title, author, subject and series  CJK qf and pf are tested elsewhere
  
  context "Publication Info" do
    context "Publisher: Akatsuki Shobō  曉書房" do
      before(:all) do
        @resp = cjk_adv_solr_resp({'q'=>"#{cjk_pub_info_query('曉書房')}"}.merge(solr_args))
      end
      it "num expected" do
        # there are only 2 exact matches as of 2013-10-25; these are the only ones found w/o cjk search fields
        @resp.should have_at_least(3).documents
        @resp.should have_at_most(10).documents  # 41 match everything search
      end
      it "whitespace exact matches first" do
        exact_matches = ['6321193', '6355327']
        @resp.should include(exact_matches).in_first(exact_matches.size + 2).documents
      end
      it "matches without spaces present" do
        @resp.should include('6668315').in_first(20).documents
      end
    end
    
    context "Publisher: Mineruva Shobō  ミネルヴァ 書房" do
      before(:all) do
        @resp = cjk_adv_solr_resp({'q'=>"#{cjk_pub_info_query('ミネルヴァ 書房')}"}.merge(solr_args))
      end
      it "num expected" do
        # there are only 6 exact matches as of 2013-10-25; these are the only ones found w/o cjk search fields
        @resp.should have_at_least(800).documents
        @resp.should have_at_most(914).documents  # 915 match everything search
      end
      it "whitespace exact matches first" do
        exact_matches = ['4196577', '4203788', '4199853', '4198109', '4203994', '4197487']
        @resp.should include(exact_matches).in_first(exact_matches.size).documents
      end
      it "matches without spaces present" do
        no_space_exact_matches = ['9714673', '9714675']  # 2 out of many
        @resp.should include(no_space_exact_matches).in_first(20).documents
      end
    end
    
    context "Place:  Okinawa-ken Ginowan-shi  沖縄県宜野湾市" do
      exact_matches = ['9392905', '9350464']
      before(:all) do
        @resp = cjk_adv_solr_resp({'q'=>"#{cjk_pub_info_query('沖縄県宜野湾市')}"}.merge(solr_args))
      end
      it "num expected" do
        # there are 14 exact matches as of 2013-10-25; these are the only ones found w/o cjk search fields
        @resp.should have_at_least(15).documents
        @resp.should have_at_most(16).documents # 17 match everything search
      end
      it "whitespace exact matches first" do
        @resp.should include(exact_matches).in_first(exact_matches.size).documents
      end
      it "matches without spaces present" do
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
  
  context "Summary/ToC" do
    context "ToC: Haiku futabashū  俳句二葉集" do
      before(:all) do
        @resp = cjk_adv_solr_resp({'q'=>"#{cjk_summary_query('俳句二葉集')}"}.merge(solr_args))
      end
      it "num expected" do
        # there is only 1 exact match as of 2013-10-25; these are the only ones found w/o cjk search fields
        @resp.should have_at_least(1).documents
        @resp.should have_at_most(5).documents  # 3 match everything search
      end
      it "whitespace exact matches first" do
        exact_matches = ['6626123']
        @resp.should include(exact_matches).in_first(exact_matches.size).documents
      end
      it "matches without spaces present" do
        no_space_exact_matches = ['6305856', '6626759'] 
        @resp.should include(no_space_exact_matches).in_first(5).documents
      end
    end
    context "Ningxia Border Region  陝甘寧邊區" do
      before(:all) do
        @resp = cjk_adv_solr_resp({'q'=>"#{cjk_summary_query('陝甘寧邊區')}"}.merge(solr_args))
      end
      no_space_exact_matches = ['6326387', '6328507', '8795876', '9134891', '6514338', '6723694', '6723782', '6298281'] 
      it "num expected" do
        # there are 0 exact matches as of 2013-10-29; these are the only ones found w/o cjk search fields
        @resp.should have_at_least(no_space_exact_matches.size).documents
        @resp.should have_at_most(20).documents  # 180 match everything search
      end
      it "matches without spaces present" do
        @resp.should include(no_space_exact_matches).in_first(10).documents
      end
    end
  end
  
  context "Description (catchall only)" do
    it "Ningxia Border Region ( 陝甘寧邊區) num expected" do
      resp = cjk_adv_solr_resp({'q'=>"#{cjk_description_query('陝甘寧邊區')}"}.merge(solr_args))
      resp.should have_at_least(150).documents # 63 match whitespace (non-CJK aware search)
      resp.should have_at_most(250).documents
    end
    it "Tsu (津):  num expected" do
      resp = cjk_adv_solr_resp({'q'=>"#{cjk_description_query('津')}"}.merge(solr_args))
      resp.should have_at_least(30).documents # matches 22 wo cjk search fields
      resp.should have_at_most(8000).documents 
    end
  end
  
  context "combining fields" do
    context "title + author" do
      context "title Nihon seishin seisei shiron (日本精神生成史論), author Shigeo Suzuki (鈴木重雄)" do
        it "AND" do
          resp = cjk_adv_solr_resp({'q'=>"#{cjk_title_query('日本精神生成史論')} AND #{cjk_author_query('鈴木重雄')}"}.merge(solr_args))
          resp.should have_at_least(1).documents # 1 with non-CJK aware fields
          resp.should have_at_most(5).documents
        end
        it "OR" do
          resp = cjk_adv_solr_resp({'q'=>"#{cjk_title_query('日本精神生成史論')} OR #{cjk_author_query('鈴木重雄')}"}.merge(solr_args))
          resp.should have_at_least(5).documents # 4 with non-CJK aware fields
          resp.should have_at_most(20).documents
        end
      end
      context "title Ji cu zhan shu (基礎戰術), author Mao, Zedong (毛澤東)" do
        it "AND" do
          resp = cjk_adv_solr_resp({'q'=>"#{cjk_title_query('基礎戰術')} AND #{cjk_author_query('毛澤東')}"}.merge(solr_args))
          resp.should have_at_least(2).documents # 2 with non-CJK aware fields
          resp.should have_at_most(5).documents
        end
        it "OR" do
          resp = cjk_adv_solr_resp({'q'=>"#{cjk_title_query('基礎戰術')} OR #{cjk_author_query('毛澤東')}"}.merge(solr_args))
          resp.should have_at_least(350).documents # 316 with non-CJK aware fields
          resp.should have_at_most(500).documents
        end
      end
    end # title + author
    context "title + pub info" do
      context "title Daily Report (日報), place Jinan (濟南)" do
        it "AND" do
          resp = cjk_adv_solr_resp({'q'=>"#{cjk_title_query('日報')} AND #{cjk_pub_info_query('濟南')}"}.merge(solr_args))
          resp.should have_at_least(5).documents # none with non-CJK aware fields
          resp.should have_at_most(15).documents
        end
        it "OR" do
          resp = cjk_adv_solr_resp({'q'=>"#{cjk_title_query('日報')} OR #{cjk_pub_info_query('濟南')}"}.merge(solr_args))
          resp.should have_at_least(5000).documents # almost 5000 with non-CJK aware fields
          resp.should have_at_most(10000).documents
        end
      end
      context "unigram title Float (飄), place Shanghai (上海)" do
        it "AND" do
          resp = cjk_adv_solr_resp({'q'=>"#{cjk_title_query('飄')} AND #{cjk_pub_info_query('上海')}"}.merge(solr_args))
          resp.should have_at_least(10).documents # 1 with non-CJK aware fields
          resp.should have_at_most(20).documents
        end
        it "OR" do
          resp = cjk_adv_solr_resp({'q'=>"#{cjk_title_query('飄')} OR #{cjk_pub_info_query('上海')}"}.merge(solr_args))
          resp.should have_at_least(40000).documents # over 36000 with non-CJK aware fields
          resp.should have_at_most(45000).documents
        end
      end
    end # title + pub info
    context "keyword + place" do
      context "Ningxia Border Region (陝甘寧邊區), place Yan'an (延安)" do
        it "AND" do
          resp = cjk_adv_solr_resp({'q'=>"#{cjk_description_query('陝甘寧邊區')} AND #{cjk_pub_info_query('延安')}"}.merge(solr_args))
          resp.should have_at_least(30).documents # 25 with non-CJK aware fields
          resp.should have_at_most(40).documents
        end
        it "OR" do
          resp = cjk_adv_solr_resp({'q'=>"#{cjk_description_query('陝甘寧邊區')} OR #{cjk_pub_info_query('延安')}"}.merge(solr_args))
          resp.should have_at_least(375).documents # 329 with non-CJK aware fields
          resp.should have_at_most(500).documents
        end
      end
    end
  end
  
  
private  
  
  # send a GET request to the indicated Solr request handler with the indicated Solr parameters
  # @param solr_params [Hash] the key/value pairs to be sent to Solr as HTTP parameters
  # @param req_handler [String] the pathname of the desired Solr request handler (defaults to 'select') 
  # @return [RSpecSolr::SolrResponseHash] object for rspec-solr testing the Solr response 
  def cjk_adv_solr_resp(solr_params, req_handler='select')
    q_val = solr_params['q']
    if num_cjk_uni(q_val) == 0
      RSpecSolr::SolrResponseHash.new(solr_conn.send_and_receive(req_handler, {:method => :get, :params => solr_params.merge(solr_args)}))
    else
      if q_val =~ /\{(.*)\}(.*)/
        qf_pf_args = $1
        terms = $2
      end
      RSpecSolr::SolrResponseHash.new(solr_conn.send_and_receive(req_handler, {:method => :get, 
        :params => solr_params.merge(solr_args).merge(cjk_mm_qs_params(terms ? terms : q_val))}))
    end
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
end # describe CJK Advanced Search