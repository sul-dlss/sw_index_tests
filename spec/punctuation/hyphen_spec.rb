# encoding: utf-8
require 'spec_helper'

describe "hyphen in queries" do

  # hyphens between characters (no spaces) are to be treated as a phrase search for surrounding terms,
  # so 'a-b' and '"a b"' are equivalent query strings
  shared_examples_for "hyphens without spaces imply phrase" do | query, exp_ids, first_x |
    before(:all) do
      q_as_phrase = "\"#{query}\""
      q_as_phrase_no_hyphen = "\"#{query.sub('-', ' ')}\""
      q_split = query.split('-')
      if q_split.size == 2
        term_before = q_split.first.split(' ').last
        start_of_query = q_split.first.split(term_before).first
        start_of_query.strip if start_of_query
        term_after = q_split.last.split(' ').first
        rest_of_query = q_split.last.split(term_after).last
        rest_of_query.strip if rest_of_query
        q_no_hyphen_phrase = "#{start_of_query} \"#{term_before} #{term_after}\" #{rest_of_query}"
      end
      @resp = solr_resp_ids_from_query(query)
      @presp = solr_resp_ids_from_query(q_no_hyphen_phrase)
      @tresp = solr_resp_doc_ids_only(title_search_args(query))
      @ptresp = solr_resp_doc_ids_only(title_search_args(q_no_hyphen_phrase))
      @resp_whole_phrase = solr_resp_ids_from_query(q_as_phrase)
      @resp_whole_phrase_no_hyphen = solr_resp_ids_from_query(q_as_phrase_no_hyphen)
      @tresp_whole_phrase = solr_resp_doc_ids_only(title_search_args(q_as_phrase))
      @tresp_whole_phrase_no_hyphen = solr_resp_doc_ids_only(title_search_args(q_as_phrase_no_hyphen))
    end
    it "should have great results for query" do
      expect(@resp).to include(exp_ids).in_first(first_x).documents
      expect(@presp).to include(exp_ids).in_first(first_x).documents
      expect(@tresp).to include(exp_ids).in_first(first_x).documents
      expect(@ptresp).to include(exp_ids).in_first(first_x).documents
      expect(@resp_whole_phrase).to include(exp_ids).in_first(first_x).documents
      expect(@resp_whole_phrase_no_hyphen).to include(exp_ids).in_first(first_x).documents
      expect(@tresp_whole_phrase).to include(exp_ids).in_first(first_x).documents
      expect(@tresp_whole_phrase_no_hyphen).to include(exp_ids).in_first(first_x).documents
    end
    it "should treat hyphen as phrase search for surrounding terms in everything searches" do
      expect(@resp).to have_the_same_number_of_documents_as(@presp)
    end
    it "should treat hyphen as phrase search for surrounding terms in title searches" do
      expect(@tresp).to have_the_same_number_of_documents_as(@ptresp)
    end
    it "phrase search for entire query should ignore hyphen" do
      expect(@resp_whole_phrase).to have_the_same_number_of_documents_as(@resp_whole_phrase_no_hyphen)
    end
    it "title phrase search for entire query should ignore hyphen" do
      expect(@tresp_whole_phrase).to have_the_same_number_of_documents_as(@tresp_whole_phrase_no_hyphen)
    end
  end # shared examples for no surrounding spaces

  shared_examples_for "hyphens ignored" do | query, exp_ids, first_x |
    before(:all) do
      q_no_hyphen = query.sub('-', ' ').sub(/\s+/, ' ')
      q_as_phrase = "\"#{query}\""
      q_as_phrase_no_hyphen = "\"#{q_no_hyphen}\""
      @resp = solr_resp_ids_from_query(query)
      @resp_no_hyphen = solr_resp_ids_from_query(q_no_hyphen)
      @tresp = solr_resp_doc_ids_only(title_search_args(query))
      @tresp_no_hyphen = solr_resp_doc_ids_only(title_search_args(q_no_hyphen))
      @resp_whole_phrase = solr_resp_ids_from_query(q_as_phrase)
      @resp_whole_phrase_no_hyphen = solr_resp_ids_from_query(q_as_phrase_no_hyphen)
      @tresp_whole_phrase = solr_resp_doc_ids_only(title_search_args(q_as_phrase))
      @tresp_whole_phrase_no_hyphen = solr_resp_doc_ids_only(title_search_args(q_as_phrase_no_hyphen))
    end
    it "should have great results for query" do
      expect(@resp).to include(exp_ids).in_first(first_x).documents
      expect(@resp_no_hyphen).to include(exp_ids).in_first(first_x).documents
      expect(@tresp).to include(exp_ids).in_first(first_x).documents
      expect(@tresp_no_hyphen).to include(exp_ids).in_first(first_x).documents
      expect(@resp_whole_phrase).to include(exp_ids).in_first(first_x).documents
      expect(@resp_whole_phrase_no_hyphen).to include(exp_ids).in_first(first_x).documents
      expect(@tresp_whole_phrase).to include(exp_ids).in_first(first_x).documents
      expect(@tresp_whole_phrase_no_hyphen).to include(exp_ids).in_first(first_x).documents
    end
    it "should ignore hyphen in everything searches" do
      expect(@resp).to have_the_same_number_of_documents_as(@resp_no_hyphen)
    end
    it "should ignore hyphen in title searches" do
      expect(@tresp).to have_the_same_number_of_documents_as(@tresp_no_hyphen)
    end
    it "phrase search for entire query should ignore hyphen" do
      expect(@resp_whole_phrase).to have_the_same_number_of_documents_as(@resp_whole_phrase_no_hyphen)
    end
    it "title phrase search for entire query should ignore hyphen" do
      expect(@tresp_whole_phrase).to have_the_same_number_of_documents_as(@tresp_whole_phrase_no_hyphen)
    end
  end # shared examples hyphen ignored

  shared_examples_for "hyphens with space before but not after are treated as NOT, but ignored in phrase" do | query, exp_ids, unexp_ids |
    before(:all) do
      q_not = query.sub('-', 'NOT ')
      q_as_phrase = "\"#{query}\""
      q_no_hyphen = query.sub('-', ' ').sub('  ', ' ')
      q_as_phrase_no_hyphen = "\"#{q_no_hyphen}\""
      q_split = query.split('-')
      if q_split.size == 2
        term_after = q_split.last.split(' ').first
        rest_of_query = q_split.last.split(term_after).last
        rest_of_query.strip if rest_of_query
        @q_no_term = "#{q_split.first} #{rest_of_query}"
      end

      # treat as NOT when plain
      @resp = solr_resp_ids_from_query(query)
      @resp_not = solr_resp_ids_from_query(q_not)
      @tresp = solr_resp_doc_ids_only(title_search_args(query))
      @tresp_not = solr_resp_doc_ids_only(title_search_args(q_not))
      # ignore hyphen in phrase
      @resp_whole_phrase = solr_resp_ids_from_query(q_as_phrase)
      @resp_whole_phrase_no_hyphen = solr_resp_ids_from_query(q_as_phrase_no_hyphen)
      @tresp_whole_phrase = solr_resp_doc_ids_only(title_search_args(q_as_phrase))
      @tresp_whole_phrase_no_hyphen = solr_resp_doc_ids_only(title_search_args(q_as_phrase_no_hyphen))
    end

    it "should have great results for query (treat hyphen as NOT)" do
      expect(@resp).to include(exp_ids) if exp_ids
      expect(@resp).not_to include(unexp_ids)
      expect(@resp_not).to include(exp_ids) if exp_ids
      expect(@resp_not).not_to include(unexp_ids)
      expect(@tresp).to include(exp_ids) if exp_ids
      expect(@tresp).not_to include(unexp_ids)
      expect(@tresp_not).to include(exp_ids) if exp_ids
      expect(@tresp_not).not_to include(unexp_ids)
    end
    it "should have great results for query as phrase (ignore hyphen)" do
      # ignore hyphen in phrase - expect all terms
      expect(@resp_whole_phrase).to include(unexp_ids)
      expect(@resp_whole_phrase).not_to include(exp_ids) if exp_ids
      expect(@resp_whole_phrase_no_hyphen).to include(unexp_ids)
      expect(@resp_whole_phrase_no_hyphen).not_to include(exp_ids) if exp_ids
      expect(@tresp_whole_phrase).to include(unexp_ids)
      expect(@tresp_whole_phrase).not_to include(exp_ids) if exp_ids
      expect(@tresp_whole_phrase_no_hyphen).to include(unexp_ids)
      expect(@tresp_whole_phrase_no_hyphen).not_to include(exp_ids) if exp_ids
    end
    # the following is busted due to Solr edismax bug
    # https://issues.apache.org/jira/browse/SOLR-2649
    it "should treat hyphen as NOT in everything searches", pending: 'fixme', skip: true do
      expect(@resp).to have_the_same_number_of_documents_as(@resp_not)
      # the below isn't true for edismax b/c mm is basically set to 0  https://issues.apache.org/jira/browse/SOLR-2649
      expect(@resp).to have_fewer_results_than(solr_resp_ids_from_query(@q_no_term))
    end
    # the following is busted due to Solr edismax bug
    # https://issues.apache.org/jira/browse/SOLR-2649
    it "should treat hyphen as NOT in title searches", pending: 'fixme', skip: true do
      expect(@tresp).to have_the_same_number_of_documents_as(@tresp_not)
      # the below isn't true for edismax b/c mm is basically set to 0  https://issues.apache.org/jira/browse/SOLR-2649
      expect(@tresp).to have_fewer_results_than(solr_resp_doc_ids_only(title_search_args(@q_no_term)))
    end
    it "phrase search for entire query should ignore hyphen" do
      expect(@resp_whole_phrase).to have_the_same_number_of_documents_as(@resp_whole_phrase_no_hyphen)
    end
    it "title phrase search for entire query should ignore hyphen" do
      expect(@tresp_whole_phrase).to have_the_same_number_of_documents_as(@tresp_whole_phrase_no_hyphen)
    end
  end # shared examples for space before but not after

  context "'neo-romantic'", :jira => 'VUF-798' do
    it_behaves_like "hyphens without spaces imply phrase", "neo-romantic", ["7789846", "2095712", "7916667", "5627730", "1665493", "2775888", "1688481"], 12
    it_behaves_like "hyphens ignored", "neo- romantic", ["7789846", "2095712", "7916667", "5627730", "1665493", "2775888", "1688481"], 12
    it_behaves_like "hyphens ignored", "neo- romantic", ["1665493", "2775888"], 10
#   hyphens with both spaces don't work right
#    it_behaves_like "hyphens ignored", "neo - romantic", ["1665493", "2775888"], 10
    it_behaves_like "hyphens with space before but not after are treated as NOT, but ignored in phrase", "neo -romantic", '445186', ["7789846", "2095712", "7916667", "5627730", "1665493", "2775888", "1688481"]
  end

  context "'cat-dog'" do
    it_behaves_like "hyphens without spaces imply phrase", "cat-dog", "6741004", 20
  end

  context "'1951-1960'" do
    it_behaves_like "hyphens without spaces imply phrase", "1951-1960", "2916430", 20
    it_behaves_like "hyphens with space before but not after are treated as NOT, but ignored in phrase", "1951 -1960", nil, '2916430'
#   hyphens with both spaces don't work right
#    it_behaves_like "hyphens ignored", "1951 - 1960", "2916430", 20
  end

  it "'0256-1115' (ISSN)" do
    # not useful to search as title ...
    resp = solr_resp_ids_from_query('0256-1115')
    presp = solr_resp_ids_from_query('"0256 1115"')
    expect(resp).to include("4108257").as_first
    expect(presp).to include('4108257').as_first
    expect(resp).to have_the_same_number_of_documents_as(presp)
  end

  context "'Deutsch-Sudwestafrikanische Zeitung'", :jira => 'VUF-803' do
    it_behaves_like "hyphens without spaces imply phrase", "Deutsch-Sudwestafrikanische Zeitung", ["410366", "8230044"], 2
    it_behaves_like "hyphens with space before but not after are treated as NOT, but ignored in phrase", "Deutsch -Sudwestafrikanische Zeitung", '425291', ["410366", "8230044"]
#   hyphens with both spaces don't work right
#    it_behaves_like "hyphens ignored", "Deutsch - Sudwestafrikanische Zeitung", ["410366", "8230044"], 2
  end

  context "'red-rose chain'", :jira => 'SW-388' do
    # record 12197834 ranks higher than 8702148 because "red rose" appears twice in record
    # however "red rose chain" is not a phrase in record 12197834
    it_behaves_like "hyphens without spaces imply phrase", "red-rose chain", ["5335304", "8702148"], 4
  end
  context "'prisoner in a red-rose chain'", :jira => 'SW-388' do
    it_behaves_like "hyphens without spaces imply phrase", "prisoner in a red-rose chain", "8702148", 1
  end

  context "'The John - Donkey'" do
    it_behaves_like "hyphens without spaces imply phrase", "The John-Donkey", ["8166294", "365685"], 2
    it_behaves_like "hyphens ignored", "The John- Donkey", ["8166294", "365685"], 2
    it_behaves_like "hyphens with space before but not after are treated as NOT, but ignored in phrase", "The John -Donkey", '1699277', ["8166294", "365685"]
#   hyphens with both spaces don't work right
#    it_behaves_like "hyphens ignored", "The John - Donkey", ["8166294", "365685"], 2
  end

  context "'under the sea-wind'", :jira => 'VUF-966' do
    it_behaves_like "hyphens without spaces imply phrase", "under the sea-wind", ["5621261", "545419", "2167813"], 3
    it_behaves_like "hyphens ignored", "under the sea- wind", ["5621261", "545419", "2167813"], 3
    it_behaves_like "hyphens with space before but not after are treated as NOT, but ignored in phrase", "under the sea -wind", '8652881', ["5621261", "545419", "2167813"]
#   hyphens with both spaces don't work right
#    it_behaves_like "hyphens ignored", "under the sea - wind", ["5621261", "545419", "2167813"], 3
  end

  context "'customer-driven academic library'", :jira => ['SW-388', 'VUF-846'] do
    it_behaves_like "hyphens without spaces imply phrase", "customer-driven academic library", "7778647", 3
    it_behaves_like "hyphens ignored", "customer- driven academic library", "7778647", 3
    it_behaves_like "hyphens with space before but not after are treated as NOT, but ignored in phrase", "customer -driven academic library", nil, "7778647"
#   hyphens with both spaces don't work right
#    it_behaves_like "hyphens ignored", "customer - driven academic library", "7778647", 1
  end

  context "'catalogue of high-energy accelerators'", :jira => 'VUF-846' do
    it_behaves_like "hyphens without spaces imply phrase", "catalogue of high-energy accelerators", "1156871", 1
#   hyphens with both spaces don't work right
#    it_behaves_like "hyphens ignored", "catalogue of high - energy accelerators", "1156871", 1
  end

  context "'Mid-term fiscal policy review'", :jira => 'SW-388' do
    it_behaves_like "hyphens without spaces imply phrase", "Mid-term fiscal policy review", ["7204125", "5815422"], 3
    it_behaves_like "hyphens with space before but not after are treated as NOT, but ignored in phrase", "Mid -term fiscal policy review", nil, ["7204125", "5815422"]
#   hyphens with both spaces don't work right
#    it_behaves_like "hyphens ignored", "Mid - term fiscal policy review", ["7204125", "5815422"], 3
  end

  context "'South Africa, Shakespeare and post-colonial culture", :jira => 'VUF-626' do
    # no results for title search
#    it_behaves_like "hyphens without spaces imply phrase", "South Africa, Shakespeare and post-colonial culture", "9740889", 1
#    it_behaves_like "hyphens with space before but not after are treated as NOT, but ignored in phrase", "South Africa, Shakespeare and post -colonial culture", "2993586", "9740889"
    it "hyphen: post-colonial" do
      resp = solr_resp_ids_from_query 'South Africa, Shakespeare post-colonial culture'
      expect(resp).to have_documents
    end
    it "no hyphen: postcolonial" do
      resp = solr_resp_ids_from_query 'South Africa, Shakespeare postcolonial culture'
      expect(resp).to have_documents
    end
    it "space instead of hyphen: post colonial" do
      resp = solr_resp_ids_from_query 'South Africa, Shakespeare post colonial culture'
      expect(resp).to have_documents
    end
    it 'phrase instead of hyphen: "post colonial"' do
      resp = solr_resp_ids_from_query 'South Africa, Shakespeare "post colonial" culture'
      expect(resp).to have_documents
    end
  end

  context "hyphens with spaces from the usage logs", pending: 'fixme', skip: true do
    context "Europe - North Korea: between humanitarism and business" do
      it_behaves_like "hyphens ignored", "Europe - North Korea: between humanitarism and business", "8935347", 1
    end
    context "Mixed Blessings: New Art in a Multicultural America - Lucy R. Lippard" do
      it_behaves_like "hyphens ignored", "Mixed Blessings: New Art in a Multicultural America - Lucy R. Lippard", "525450", 1
    end
    context "VanDerZee, Photographer: 1886 – 1983" do
      # note:  this is the double hyphen
      it_behaves_like "hyphens ignored", "VanDerZee, Photographer: 1886 – 1983", "2782147", 1
    end
    context "MPI - the complete reference" do
      it_behaves_like "hyphens ignored", "MPI - the complete reference", ["4115563", "3131940"], 2
    end
    context "Retinoids - Methods and Protocols" do
      it_behaves_like "hyphens ignored", "Retinoids - Methods and Protocols", "8774837", 1
    end
  end

  context "'The third plan mid-term appraisal'" do
    it_behaves_like "hyphens without spaces imply phrase", "The third plan mid-term appraisal", "2234698", 1
#   hyphens with both spaces don't work right
#    it_behaves_like "hyphens ignored", "The third plan mid - term appraisal", "2234698", 1
  end

  # the following is busted due to Solr edismax bug
  # https://issues.apache.org/jira/browse/SOLR-2649
  context "'beyond race in a race -obsessed world'", pending: 'fixme', skip: true do
    it_behaves_like "hyphens with space before but not after are treated as NOT, but ignored in phrase", "beyond race in a race -obsessed world", "3148369", "3381968"
  end

  context "'Silence : a thirteenth-century French romance'" do
    it_behaves_like "hyphens without spaces imply phrase", "Silence : a thirteenth-century French romance", "2416395", 2
    it_behaves_like "hyphens ignored", "Silence : a thirteenth- century French romance", "2416395", 2
    # the following is busted due to Solr edismax bug
    # https://issues.apache.org/jira/browse/SOLR-2649
#    it_behaves_like "hyphens with space before but not after are treated as NOT, but ignored in phrase", "Silence : a thirteenth -century French romance", nil, "11484079"
#   hyphens with both spaces don't work right
#    it_behaves_like "hyphens ignored", "Silence : a thirteenth - century French romance", "11484079", 1
  end

  context "'Color-blindness; its dangers and its detection'", :jira => 'SW-94' do
    it_behaves_like "hyphens without spaces imply phrase", "Color-blindness; its dangers and its detection", ["10858119", "2323785"], 2
  end
  context "'Color-blindness [print/digital]; its dangers and its detection'", :jira => 'SW-94' do
    # because over mm threshold, no hyphen has diff number of hits than hyphen with spaces
#    it_behaves_like "hyphens ignored", "Color - blindness; its dangers and its detection", ["7329437", "2323785"], 2

    #  it_behaves_like "hyphens without spaces imply phrase", "Color-blindness [print/digital]; its dangers and its detection", "7329437", 2
    #   we don't include 245h in title_245_search, and 245h contains "[print/digital]"
    before(:all) do
      query = 'Color-blindness [print/digital]; its dangers and its detection'
      q_as_phrase = "\"#{query}\""
      q_as_phrase_no_hyphen = "\"#{query.sub('-', ' ')}\""
      q_split = query.split('-')
      if q_split.size == 2
        term_before = q_split.first.split(' ').last
        start_of_query = q_split.first.split(term_before).first
        start_of_query.strip if start_of_query
        term_after = q_split.last.split(' ').first
        rest_of_query = q_split.last.split(term_after).last
        rest_of_query.strip if rest_of_query
        q_no_hyphen_phrase = "#{start_of_query} \"#{term_before} #{term_after}\" #{rest_of_query}"
      end
      @resp = solr_resp_ids_from_query(query)
      @presp = solr_resp_ids_from_query(q_no_hyphen_phrase)
      @tresp = solr_resp_doc_ids_only(title_search_args(query))
      @ptresp = solr_resp_doc_ids_only(title_search_args(q_no_hyphen_phrase))
      @resp_whole_phrase = solr_resp_ids_from_query(q_as_phrase)
      @resp_whole_phrase_no_hyphen = solr_resp_ids_from_query(q_as_phrase_no_hyphen)
      @tresp_whole_phrase = solr_resp_doc_ids_only(title_search_args(q_as_phrase))
      @tresp_whole_phrase_no_hyphen = solr_resp_doc_ids_only(title_search_args(q_as_phrase_no_hyphen))
    end
    it "should have great results for query" do
      # with mm=8, 245h "[print/digital]" becomes important for matching documents
      exp_ids = ["10858119", "2323785"]
      first_x = 2
      #  makes everything search include documents with 245h
      expect(@resp).to include("10858119").in_first(first_x).documents
      expect(@presp).to include("10858119").in_first(first_x).documents
      #  makes title search return 0 documments
      expect(@tresp).not_to include(exp_ids).in_first(first_x).documents
      expect(@ptresp).not_to include(exp_ids).in_first(first_x).documents
      # 2323785 is NOT present for the entire query as a phrase search;
      #  we don't include 245h in title_245_search, and 245h contains "[print/digital]"
      expect(@resp_whole_phrase).to include("10858119").in_first(first_x).documents
      expect(@resp_whole_phrase_no_hyphen).to include("10858119").in_first(first_x).documents
    end
    it "should treat hyphen as phrase search for surrounding terms in everything searches" do
      expect(@resp).to have_the_same_number_of_documents_as(@presp)
    end
    it "should treat hyphen as phrase search for surrounding terms in title searches" do
      expect(@tresp).to have_the_same_number_of_documents_as(@ptresp)
    end
    it "phrase search for entire query should ignore hyphen" do
      expect(@resp_whole_phrase).to have_the_same_number_of_documents_as(@resp_whole_phrase_no_hyphen)
    end
    it "title phrase search for entire query should ignore hyphen" do
      expect(@tresp_whole_phrase).to have_the_same_number_of_documents_as(@tresp_whole_phrase_no_hyphen)
    end
  end # context "'Color-blindness [print/digital]; its dangers and its detection'"

  context "multiple hyphens 'probabilities for use in stop-or-go sampling'" do
    it "should treat multiple hyphens like a phrase" do
      resp = solr_resp_ids_from_query('probabilities for use in stop-or-go sampling')
      expect(resp).to include(["2146380", "3336158"]).in_first(2).documents
      presp = solr_resp_ids_from_query('probabilities for use in "stop or go" sampling')
      expect(presp).to include(["2146380", "3336158"]).in_first(2).documents
      expect(resp).to have_the_same_number_of_documents_as(presp)
      tresp = solr_resp_doc_ids_only(title_search_args 'probabilities for use in stop-or-go sampling')
      expect(tresp).to include(["2146380", "3336158"]).in_first(2).documents
      tpresp = solr_resp_doc_ids_only(title_search_args 'probabilities for use in "stop or go" sampling')
      expect(tpresp).to include(["2146380", "3336158"]).in_first(2).documents
      expect(tresp).to have_the_same_number_of_documents_as(tpresp)
    end
  end

  context "used to prohibit a clause" do
    it 'should work with quotes' do
      resp = solr_resp_ids_from_query('mark twain -"tom sawyer"')
      expect(resp.size).to be >= 1400
      expect(resp).to have_the_same_number_of_documents_as(solr_resp_ids_from_query('mark twain NOT "tom sawyer"'))
    end
    it "should work with parens", :jira => 'VUF-379' do
      resp = solr_resp_ids_from_query('mark twain -(tom sawyer)')
      expect(resp.size).to be >= 1400
      expect(resp).to have_the_same_number_of_documents_as(solr_resp_ids_from_query('mark twain NOT (tom sawyer)'))
    end
  end

  context "hyphenated phrase in quotes \"Color-blind\" racism" do
    it "should ignore the hyphen" do
      resp = solr_resp_ids_from_query('"Color-blind" racism')
      expect(resp).to include("3499287").in_first(5)
      resp_no_hyphen = solr_resp_ids_from_query('"Color blind" racism')
      expect(resp_no_hyphen).to include("3499287").in_first(5)
      tresp = solr_resp_doc_ids_only(title_search_args '"Color-blind" racism')
      expect(tresp).to include("3499287").as_first
      tresp_no_hyphen = solr_resp_doc_ids_only(title_search_args '"Color blind" racism')
      expect(tresp_no_hyphen).to include("3499287").as_first
    end
  end

end
