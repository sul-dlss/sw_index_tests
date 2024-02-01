# -*- encoding : utf-8 -*-
require 'spec_helper'

describe 'CJK Advanced Search' do
  # in a non-CJK aware world, the only matches are ones where the whitespace matches.
  # in a CJK-aware world, matches also include word boundaries that aren't denoted by whitespace
  # in a CJK-aware advanced search, we should get matches that are only in the desired fields
  #   AND the matches shouldn't require whitespace for word boundaries

  # NOTE:  title, author, subject and series  CJK qf and pf are tested elsewhere

  context 'Publication Info' do
    context 'Publisher: Akatsuki Shobō  曉書房' do
      before(:all) do
        @resp = cjk_adv_solr_resp({ 'q' => "#{cjk_pub_info_query('曉書房')}" }.merge(solr_args))
      end
      it 'num expected' do
        # there are only 2 exact matches as of 2013-10-25; these are the only ones found w/o cjk search fields
        expect(@resp.size).to be >= 3
        expect(@resp.size).to be <= 10 # 41 match everything search
      end
      it 'whitespace exact matches first' do
        exact_matches = %w(6321193 6355327)
        expect(@resp).to include(exact_matches).in_first(exact_matches.size + 2).documents
      end
      it 'matches without spaces present' do
        expect(@resp).to include('6668315').in_first(20).documents
      end
    end

    context 'Publisher: Mineruba Shobō  ミネルヴァ 書房' do
      before(:all) do
        @resp = cjk_adv_solr_resp({ 'q' => "#{cjk_pub_info_query('ミネルヴァ 書房')}" }.merge(solr_args))
      end
      it 'num expected' do
        # there are only 6 exact matches as of 2013-10-25; these are the only ones found w/o cjk search fields
        expect(@resp.size).to be >= 800
        everything_num = cjk_query_resp_ids('everything', 'ミネルヴァ 書房').size
        expect(@resp.size).to be <= everything_num - 1
      end
      it 'whitespace exact matches first' do
        exact_matches = %w(4196577 4203788 4199853 4198109 4203994 4197487)
        expect(@resp).to include(exact_matches).in_first(exact_matches.size).documents
      end
      it 'matches without spaces present', pending: :fixme do
        # exact matching no longer cares about whitespace.
        no_space_exact_matches = %w(4196577 12117527) # 2 out of many
        expect(@resp).to include(no_space_exact_matches).in_first(20).documents
      end
    end

    context 'Place:  Okinawa-ken Ginowan-shi  沖縄県宜野湾市' do
      before(:all) do
        @resp = cjk_adv_solr_resp({ 'q' => "#{cjk_pub_info_query('沖縄県宜野湾市')}" }.merge(solr_args))
      end
      it 'num expected' do
        # there are 14 exact matches as of 2013-10-25; these are the only ones found w/o cjk search fields
        expect(@resp.size).to be >= 15
        expect(@resp.size).to be <= 25 # 20 match everything search
      end
      it 'whitespace exact matches first' do
        exact_matches = %w(4230322 9392905 9350464 12817073)
        expect(@resp).to include(exact_matches).in_first(10).documents
      end
      it 'matches without spaces present' do
        inexact_matches = '8630944'
        expect(@resp).to include(inexact_matches).in_first(20).documents
      end
    end

    context 'Unigram' do
      it 'Place: Tsu (津):  num expected' do
        resp = cjk_adv_solr_resp({ 'q' => "#{cjk_pub_info_query('tsu 津')}" }.merge(solr_args))
        expect(resp.size).to be >= 20 # matches 19 wo cjk search fields
        expect(resp.size).to be <= 40 # 55 match everything search
      end
      it 'Place: 津  (no Tsu term): num expected' do
        resp = cjk_adv_solr_resp({ 'q' => "#{cjk_pub_info_query('津')}" }.merge(solr_args))
        expect(resp.size).to be >= 50 # matches 19 wo cjk search fields
        expect(resp.size).to be <= 4000 # 6560 match everything search
      end
    end
  end # Publication Info

  context 'Description (catchall only)' do
    it 'Ningxia Border Region ( 陝甘寧邊區) num expected' do
      resp = cjk_adv_solr_resp({ 'q' => "#{cjk_everything_query('陝甘寧邊區')}" }.merge(solr_args))
      expect(resp.size).to be >= 200 # 63 match whitespace (non-CJK aware search)
      expect(resp.size).to be <= 300
    end
    it 'Tsu (津):  num expected' do
      resp = cjk_adv_solr_resp({ 'q' => "#{cjk_everything_query('津')}" }.merge(solr_args))
      expect(resp.size).to be >= 30 # matches 22 wo cjk search fields
      expect(resp.size).to be <= 8000
    end
  end

  context 'combining fields' do
    context 'title + author' do
      context 'title Nihon seishin seisei shiron (日本精神生成史論), author Shigeo Suzuki (鈴木重雄)' do
        it 'AND' do
          resp = cjk_adv_solr_resp({ 'q' => "#{cjk_title_query('日本精神生成史論')} AND #{cjk_author_query('鈴木重雄')}" }.merge(solr_args))
          expect(resp.size).to be >= 1 # 1 with non-CJK aware fields
          expect(resp.size).to be <= 5
        end
        it 'OR' do
          resp = cjk_adv_solr_resp({ 'q' => "#{cjk_title_query('日本精神生成史論')} OR #{cjk_author_query('鈴木重雄')}" }.merge(solr_args))
          expect(resp.size).to be >= 5 # 4 with non-CJK aware fields
          expect(resp.size).to be <= 20
        end
      end
      context 'title Ji cu zhan shu (基礎戰術), author Mao, Zedong (毛澤東)' do
        it 'AND' do
          resp = cjk_adv_solr_resp({ 'q' => "#{cjk_title_query('基礎戰術')} AND #{cjk_author_query('毛澤東')}" }.merge(solr_args))
          expect(resp.size).to be >= 2 # 2 with non-CJK aware fields
          expect(resp.size).to be <= 5
        end
        it 'OR' do
          resp = cjk_adv_solr_resp({ 'q' => "#{cjk_title_query('基礎戰術')} OR #{cjk_author_query('毛澤東')}" }.merge(solr_args))
          expect(resp.size).to be >= 450 # 316 with non-CJK aware fields
          expect(resp.size).to be <= 650
        end
      end
    end # title + author
    context 'title + pub info' do
      context 'title Daily Report (日報), place Jinan (濟南)', jira:  'SW-974' do
        expected = %w(9617331 5175639 4822276)
        it 'AND' do
          resp = cjk_adv_solr_resp({ 'q' => "#{cjk_title_query('日報')} AND #{cjk_pub_info_query('濟南')}" }.merge(solr_args))
          expect(resp.size).to be >= 5 # none with non-CJK aware fields
          expect(resp.size).to be <= 15
          expect(resp).to include(expected)
        end
        it 'OR' do
          resp = cjk_adv_solr_resp({ 'q' => "#{cjk_title_query('日報')} OR #{cjk_pub_info_query('濟南')}" }.merge(solr_args))
          expect(resp.size).to be >= 5000 # almost 5000 with non-CJK aware fields
          expect(resp.size).to be <= 10_000
          # TODO: Needs some more analysis.
          # expect(resp).to include(expected)
        end
      end
      context 'unigram title Float (飄), place Shanghai (上海)' do
        it 'AND' do
          resp = cjk_adv_solr_resp({ 'q' => "#{cjk_title_query('飄')} AND #{cjk_pub_info_query('上海')}" }.merge(solr_args))
          expect(resp.size).to be >= 10 # 1 with non-CJK aware fields
          expect(resp.size).to be <= 20
        end
        it 'OR' do
          resp = cjk_adv_solr_resp({ 'q' => "#{cjk_title_query('飄')} OR #{cjk_pub_info_query('上海')}" }.merge(solr_args))
          expect(resp.size).to be >= 45_000 # over 36000 with non-CJK aware fields
          expect(resp.size).to be <= 50_000
        end
      end
    end # title + pub info
    context 'keyword + place' do
      context "Ningxia Border Region (陝甘寧邊區), place Yan'an (延安)" do
        it 'AND' do
          resp = cjk_adv_solr_resp({ 'q' => "#{cjk_everything_query('陝甘寧邊區')} AND #{cjk_pub_info_query('延安')}" }.merge(solr_args))
          expect(resp.size).to be >= 40 # 25 with non-CJK aware fields
          expect(resp.size).to be <= 65
        end
        it 'OR' do
          resp = cjk_adv_solr_resp({ 'q' => "#{cjk_everything_query('陝甘寧邊區')} OR #{cjk_pub_info_query('延安')}" }.merge(solr_args))
          expect(resp.size).to be >= 500 # 329 with non-CJK aware fields
          expect(resp.size).to be <= 650
        end
      end
    end
  end

private

  # send a GET request to the indicated Solr request handler with the indicated Solr parameters
  # @param solr_params [Hash] the key/value pairs to be sent to Solr as HTTP parameters
  # @param req_handler [String] the pathname of the desired Solr request handler (defaults to 'select')
  # @return [RSpecSolr::SolrResponseHash] object for rspec-solr testing the Solr response
  def cjk_adv_solr_resp(solr_params, req_handler = 'select')
    q_val = solr_params['q']
    if num_cjk_uni(q_val) == 0
      RSpecSolr::SolrResponseHash.new(solr_conn.send_and_receive(req_handler, method: :get, params: solr_params.merge(solr_args)))
    else
      if q_val =~ /\{(.*)\}(.*)/
        qf_pf_args = Regexp.last_match(1)
        terms = Regexp.last_match(2)
      end
      RSpecSolr::SolrResponseHash.new(solr_conn.send_and_receive(req_handler, method: :get,
                                                                              params: solr_params.merge(solr_args).merge(cjk_mm_qs_params(terms ? terms : q_val))))
    end
  end

  def cjk_everything_query(terms)
    '_query_:"{!edismax qf=$qf_cjk pf=$pf_cjk pf3=$pf3_cjk pf2=$pf2_cjk}' + terms + '"'
  end

  def cjk_title_query(terms)
    '_query_:"{!edismax qf=$qf_title_cjk pf=$pf_title_cjk pf3=$pf3_title_cjk pf2=$pf2_title_cjk}' + terms + '"'
  end

  def cjk_author_query(terms)
    '_query_:"{!edismax qf=$qf_author_cjk pf=$pf_author_cjk pf3=$pf3_author_cjk pf2=$pf2_author_cjk}' + terms + '"'
  end

  def cjk_subject_query(terms)
    '_query_:"{!edismax qf=$qf_subject_cjk pf=$pf_subject_cjk pf3=$pf3_subject_cjk pf2=$pf2_subject_cjk}' + terms + '"'
  end

  def cjk_pub_info_query(terms)
    '_query_:"{!edismax qf=$qf_pub_info_cjk pf=$pf_pub_info_cjk pf3=$pf3_pub_info_cjk pf2=$pf2_pub_info_cjk}' + terms + '"'
  end

  def number_query(terms)
    '_query_:"{!edismax qf=$qf_number pf=$pf_number pf3=$pf3_number pf2=$pf2_number}' + terms + '"'
  end

  def solr_args
    { 'defType' => 'lucene', 'testing' => 'sw_index_test' }.merge(doc_ids_only)
  end
end # describe CJK Advanced Search
