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
      @resp.should include(exp_ids).in_first(first_x).documents
      @presp.should include(exp_ids).in_first(first_x).documents
      @tresp.should include(exp_ids).in_first(first_x).documents
      @ptresp.should include(exp_ids).in_first(first_x).documents
      @resp_whole_phrase.should include(exp_ids).in_first(first_x).documents
      @resp_whole_phrase_no_hyphen.should include(exp_ids).in_first(first_x).documents
      @tresp_whole_phrase.should include(exp_ids).in_first(first_x).documents
      @tresp_whole_phrase_no_hyphen.should include(exp_ids).in_first(first_x).documents
    end
    it "should treat hyphen as phrase search for surrounding terms in everything searches" do
      @resp.should have_the_same_number_of_documents_as(@presp)
    end
    it "should treat hyphen as phrase search for surrounding terms in title searches" do
      @tresp.should have_the_same_number_of_documents_as(@ptresp)
    end
    it "phrase search for entire query should ignore hyphen" do
      @resp_whole_phrase.should have_the_same_number_of_documents_as(@resp_whole_phrase_no_hyphen)
    end
    it "title phrase search for entire query should ignore hyphen" do
      @tresp_whole_phrase.should have_the_same_number_of_documents_as(@tresp_whole_phrase_no_hyphen)
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
      @resp.should include(exp_ids).in_first(first_x).documents
      @resp_no_hyphen.should include(exp_ids).in_first(first_x).documents
      @tresp.should include(exp_ids).in_first(first_x).documents
      @tresp_no_hyphen.should include(exp_ids).in_first(first_x).documents
      @resp_whole_phrase.should include(exp_ids).in_first(first_x).documents
      @resp_whole_phrase_no_hyphen.should include(exp_ids).in_first(first_x).documents
      @tresp_whole_phrase.should include(exp_ids).in_first(first_x).documents
      @tresp_whole_phrase_no_hyphen.should include(exp_ids).in_first(first_x).documents
    end
    it "should ignore hyphen in everything searches" do
      @resp.should have_the_same_number_of_documents_as(@resp_no_hyphen)
    end
    it "should ignore hyphen in title searches" do
      @tresp.should have_the_same_number_of_documents_as(@tresp_no_hyphen)
    end
    it "phrase search for entire query should ignore hyphen" do
      @resp_whole_phrase.should have_the_same_number_of_documents_as(@resp_whole_phrase_no_hyphen)
    end
    it "title phrase search for entire query should ignore hyphen" do
      @tresp_whole_phrase.should have_the_same_number_of_documents_as(@tresp_whole_phrase_no_hyphen)
    end
  end # shared examples for space after but not before
  
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
      @resp.should include(exp_ids) if exp_ids
      @resp.should_not include(unexp_ids)
      @resp_not.should include(exp_ids) if exp_ids
      @resp_not.should_not include(unexp_ids)
      @tresp.should include(exp_ids) if exp_ids
      @tresp.should_not include(unexp_ids)
      @tresp_not.should include(exp_ids) if exp_ids
      @tresp_not.should_not include(unexp_ids)
    end
    it "should have great results for query as phrase (ignore hyphen)" do
      # ignore hyphen in phrase - expect all terms
      @resp_whole_phrase.should include(unexp_ids)
      @resp_whole_phrase.should_not include(exp_ids) if exp_ids
      @resp_whole_phrase_no_hyphen.should include(unexp_ids)
      @resp_whole_phrase_no_hyphen.should_not include(exp_ids) if exp_ids
      @tresp_whole_phrase.should include(unexp_ids)
      @tresp_whole_phrase.should_not include(exp_ids) if exp_ids
      @tresp_whole_phrase_no_hyphen.should include(unexp_ids)
      @tresp_whole_phrase_no_hyphen.should_not include(exp_ids) if exp_ids
    end
    it "should treat hyphen as NOT in everything searches" do
      @resp.should have_the_same_number_of_documents_as(@resp_not)
      @resp.should have_fewer_results_than(solr_resp_ids_from_query(@q_no_term))
    end
    it "should treat hyphen as NOT in title searches" do
      @tresp.should have_the_same_number_of_documents_as(@tresp_not)
      @tresp.should have_fewer_results_than(solr_resp_doc_ids_only(title_search_args(@q_no_term)))
    end
    it "phrase search for entire query should ignore hyphen" do
      @resp_whole_phrase.should have_the_same_number_of_documents_as(@resp_whole_phrase_no_hyphen)
    end
    it "title phrase search for entire query should ignore hyphen" do
      @tresp_whole_phrase.should have_the_same_number_of_documents_as(@tresp_whole_phrase_no_hyphen)
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
    resp.should include("4108257").as_first
    presp.should include('4108257').as_first
    resp.should have_the_same_number_of_documents_as(presp)
  end

  context "'Deutsch-Sudwestafrikanische Zeitung'", :jira => 'VUF-803' do
    it_behaves_like "hyphens without spaces imply phrase", "Deutsch-Sudwestafrikanische Zeitung", ["410366", "8230044"], 2
    it_behaves_like "hyphens with space before but not after are treated as NOT, but ignored in phrase", "Deutsch -Sudwestafrikanische Zeitung", '425291', ["410366", "8230044"]
#   hyphens with both spaces don't work right
#    it_behaves_like "hyphens ignored", "Deutsch - Sudwestafrikanische Zeitung", ["410366", "8230044"], 2
  end

  context "'red-rose chain'", :jira => 'SW-388' do
    it_behaves_like "hyphens without spaces imply phrase", "red-rose chain", ["5335304", "8702148"], 3
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
    it_behaves_like "hyphens without spaces imply phrase", "customer-driven academic library", "7778647", 1
    it_behaves_like "hyphens ignored", "customer- driven academic library", "7778647", 1
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
    it_behaves_like "hyphens with space before but not after are treated as NOT, but ignored in phrase", "Mid -term fiscal policy review", "8489935", ["7204125", "5815422"]
#   hyphens with both spaces don't work right
#    it_behaves_like "hyphens ignored", "Mid - term fiscal policy review", ["7204125", "5815422"], 3
  end
  
  context "'The third plan mid-term appraisal'" do
    it_behaves_like "hyphens without spaces imply phrase", "The third plan mid-term appraisal", "2234698", 1
#   hyphens with both spaces don't work right
#    it_behaves_like "hyphens ignored", "The third plan mid - term appraisal", "2234698", 1
  end

  context "'beyond race in a race -obsessed world'" do
    it_behaves_like "hyphens with space before but not after are treated as NOT, but ignored in phrase", "beyond race in a race -obsessed world", "3148369", "3381968"
  end

  context "'Silence : a thirteenth-century French romance'" do
    it_behaves_like "hyphens without spaces imply phrase", "Silence : a thirteenth-century French romance", "2416395", 1
    it_behaves_like "hyphens ignored", "Silence : a thirteenth- century French romance", "2416395", 1
    it_behaves_like "hyphens with space before but not after are treated as NOT, but ignored in phrase", "Silence : a thirteenth -century French romance", nil, "2416395"
#   hyphens with both spaces don't work right
#    it_behaves_like "hyphens ignored", "Silence : a thirteenth - century French romance", "2416395", 1
  end

  context "'Color-blindness; its dangers and its detection'", :jira => 'SW-94' do
    it_behaves_like "hyphens without spaces imply phrase", "Color-blindness; its dangers and its detection", ["7329437", "2323785"], 2
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
      exp_ids = ["7329437", "2323785"]
      first_x = 2
      @resp.should include(exp_ids).in_first(first_x).documents
      @presp.should include(exp_ids).in_first(first_x).documents
      @tresp.should include(exp_ids).in_first(first_x).documents
      @ptresp.should include(exp_ids).in_first(first_x).documents
      # 2323785 is NOT present for the entire query as a phrase search;
      #  we don't include 245h in title_245_search, and 245h contains "[print/digital]"  
      @resp_whole_phrase.should include("7329437").in_first(first_x).documents
      @resp_whole_phrase_no_hyphen.should include("7329437").in_first(first_x).documents
    end
    it "should treat hyphen as phrase search for surrounding terms in everything searches" do
      @resp.should have_the_same_number_of_documents_as(@presp)
    end
    it "should treat hyphen as phrase search for surrounding terms in title searches" do
      @tresp.should have_the_same_number_of_documents_as(@ptresp)
    end
    it "phrase search for entire query should ignore hyphen" do
      @resp_whole_phrase.should have_the_same_number_of_documents_as(@resp_whole_phrase_no_hyphen)
    end
    it "title phrase search for entire query should ignore hyphen" do
      @tresp_whole_phrase.should have_the_same_number_of_documents_as(@tresp_whole_phrase_no_hyphen)
    end
  end # context "'Color-blindness [print/digital]; its dangers and its detection'"

  context "multiple hyphens 'probabilities for use in stop-or-go sampling'" do
    it "should treat multiple hyphens like a phrase" do
      resp = solr_resp_ids_from_query('probabilities for use in stop-or-go sampling')
      resp.should include(["2146380", "3336158"]).in_first(2).documents
      presp = solr_resp_ids_from_query('probabilities for use in "stop or go" sampling')
      presp.should include(["2146380", "3336158"]).in_first(2).documents
      resp.should have_the_same_number_of_documents_as(presp)
      tresp = solr_resp_doc_ids_only(title_search_args 'probabilities for use in stop-or-go sampling')
      tresp.should include(["2146380", "3336158"]).in_first(2).documents
      tpresp = solr_resp_doc_ids_only(title_search_args 'probabilities for use in "stop or go" sampling')
      tpresp.should include(["2146380", "3336158"]).in_first(2).documents
      tresp.should have_the_same_number_of_documents_as(tpresp)
    end
  end

  context "used to prohibit a clause" do
    it 'should work with quotes' do
      resp = solr_resp_ids_from_query('mark twain -"tom sawyer"')
      resp.should have_at_least(1400).documents
      resp.should have_the_same_number_of_documents_as(solr_resp_ids_from_query('mark twain NOT "tom sawyer"'))
    end
    it "should work with parens", :jira => 'VUF-379', :fixme => true do
      resp = solr_resp_ids_from_query('mark twain -(tom sawyer)')
      resp.should have_at_least(1400).documents
      resp.should have_the_same_number_of_documents_as(solr_resp_ids_from_query('mark twain NOT (tom sawyer)'))
    end
  end
  
  context "hyphenated phrase in quotes \"Color-blind\" racism" do
    it "should ignore the hyphen" do
      resp = solr_resp_ids_from_query('"Color-blind" racism')
      resp.should include("3499287").as_first
      resp_no_hyphen = solr_resp_ids_from_query('"Color blind" racism')
      resp_no_hyphen.should include("3499287").as_first
      resp.should have_the_same_number_of_documents_as(resp_no_hyphen)
      tresp = solr_resp_doc_ids_only(title_search_args '"Color-blind" racism')
      tresp.should include("3499287").as_first
      tresp_no_hyphen = solr_resp_doc_ids_only(title_search_args '"Color blind" racism')
      tresp_no_hyphen.should include("3499287").as_first
      tresp.should have_the_same_number_of_documents_as(tresp_no_hyphen)
    end
  end

end