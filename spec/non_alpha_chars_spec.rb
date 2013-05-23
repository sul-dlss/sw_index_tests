# encoding: utf-8
require 'spec_helper'

describe "Terms with Numbers or other oddities" do
  
  it "q of 'Two3' should have excellent results", :jira => 'VUF-386', :icu => true do
    # record is Two³;  icu treats superscript as distinct from number?  but also gets 192793 docs  2013-05-20
    resp = solr_resp_ids_from_query 'Two3'
    resp.should have_at_most(10).documents
    resp.should include("5732752").as_first_result
    resp.should include("5732855")
    resp.should_not include("5727394")
    resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query 'two3')
    resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query 'Two³') # how it appears in the record
    resp.should have_fewer_results_than(solr_resp_ids_from_query 'two 3')
  end
  
  context "square brackets" do
    # if they're not for a range query, they should be ignored
    it "preceded by space as part of q string should be ignored" do
      resp = solr_resp_ids_from_query 'mark twain [pseud]'
      resp.should have_at_least(125).documents
      resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query "mark twain pseud")
    end

    it "preceded by space as part of phrase query should be ignored" do
      resp = solr_resp_ids_from_query '"mark twain [pseud]"'
      resp.should have_at_least(125).documents
      resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query '"mark twain pseud"')
    end
    
    it "not preceded by space as part of a query string should be ignored", :fixme => true do
      resp = solr_resp_ids_from_query 'Alice Wonderland serie[s]'
      resp.should have_at_least(2).documents
      resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query "Alice Wonderland series")
    end
  end
  
  it "period at end of term should be ignored" do
    resp = solr_resp_doc_ids_only(title_search_args('Nature.'))
    resp.should include("1337040")
    # Journal:  7917346, 3195844  Other books:  581294, 1361438
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(title_search_args('Nature')))
  end
  
  context "ellipses" do
    it "leading ellipsis should be ignored" do
      resp = solr_resp_doc_ids_only(title_search_args('...Nature'))
      resp.should include("1361438")
      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(title_search_args('Nature')))
    end
    it "trailing ellipsis should be ignored" do
      resp = solr_resp_doc_ids_only(title_search_args('why...'))
      resp.should include(["85217", "4272319"]).in_first(10).results
      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(title_search_args('why')))
      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(title_search_args('why ...')))
      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(title_search_args('why... ')))
    end
    it "trailing ellipsis preceded by a space should be ignored (title search)" do
      resp = solr_resp_doc_ids_only(title_search_args('I want ...'))
      resp.should include('10062710')
      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(title_search_args('I want')))
      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(title_search_args('I want...')))
      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(title_search_args('I want ... ')))
    end
    it "trailing ellipsis preceded by a space should be ignored", :fixme => true do
      #  This works for a title search, but not for an everything search ...
      resp = solr_resp_doc_ids_only({'q' => 'I want ...'})
      resp.should include('10062710')
      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(title_search_args('I want')))
      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(title_search_args('I want...')))
      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(title_search_args('I want ... ')))
    end
  end
  
  context "slash" do
    it "surround by spaces should be ignored" do
      resp = solr_resp_ids_from_query 'Physical chemistry / Ira N Levine'
      resp.should include(["1726910", "3016212", "4712578", "7633476"]).in_first(5).results
    end
    
    it "within numbers, no letters (56 1/2)", :jira => 'VUF-389' do
      resp = solr_resp_ids_from_query '56 1/2'
      resp.should include(["6031340", "5491883"]).in_first(3).results
    end
    
    it "within numbers, no letters (33 1/3)", :jira => 'VUF-178' do
      resp = solr_resp_doc_ids_only(title_search_args('33 1/3'))
      resp.should have_at_least(85).results  # Socrates gets 104 titles as of 2010-11-03
      resp.should include("6721172").in_first(3).results
    end
  end # context slash
  
  it "should ignore punctuation inside a phrase" do
    resp = solr_resp_ids_from_query '"Alice in Wonderland : a serie[s]"'
    resp.should have_at_least(2).documents
    resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query '"Alice in Wonderland a serie[s]"')
  end
  
  context "unmatched pairs" do    
    it "unmatched double quote should be ignored", :edismax => true do
      resp = solr_resp_ids_from_query '"space traveler'
      resp.should have_documents
      resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query 'space traveler')
      resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query 'space" traveler')
      resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query'space "traveler')
      # single char on its lonesome becomes a term?
#      resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query 'space " traveler')  # works for dismax, not edismax
      resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query 'space traveler"')
    end
    
    it "unmatched single quote should be ignored" do
      resp = solr_resp_ids_from_query "'space traveler"
      resp.should have_documents
      resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query "space traveler")
      resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query "space' traveler")
      resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query "space 'traveler")
      # single char on its lonesome becomes a term?
#      resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query "space ' traveler")
      resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query "space traveler'")
    end
    
    it "unmatched square bracked should be ignored" do
      resp = solr_resp_ids_from_query "[wise up"
      resp.should have_documents
      resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query "wise up")
      resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query "wise[ up")
      resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query "wise [up")
      # single char on its lonesome becomes a term?
#      resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query "wise [ up")
      resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query "wise up[")
      resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query "]wise up")
      resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query "wise] up")
      resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query "wise ]up")
      # single char on its lonesome becomes a term?
#      resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query "wise ] up")
      resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query "wise up]")
    end
    
    it "unmatched curly brace should be ignored" do
      resp = solr_resp_ids_from_query "{final chord"
      resp.should have_documents
      resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query "final chord")
      resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query "final{ chord")
      resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query "final {chord")
      # single char on its lonesome becomes a term?
#      resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query "final { chord")
      resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query "final chord{")
      resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query "}final chord")
      resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query "final} chord")
      resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query "final }chord")
      # single char on its lonesome becomes a term?
#      resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query "final } chord")
      resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query "final chord}")
    end

    it "unmatched paren should be ignored" do
      resp = solr_resp_ids_from_query '(french horn'
      resp.should have_documents
      resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query 'french horn')
      resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query 'french( horn')
      resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query 'french (horn')
      resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query 'french horn(')
      resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query ')french horn')
      resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query 'french) horn')
      resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query 'french )horn')
      resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query 'french horn)')
    end

  end # unmatched pairs
  
  context "wildcard queries" do
    it "question mark as query '?'", :fixme => true, :edismax => true do
      # dismax or icu tokenizer:  one result  (4085436)
      # edismax:  all documents
      resp = solr_resp_ids_from_query '?' # '?' 
      resp.should have_at_least(6900000).documents
    end

    it "asterix as query '*'", :fixme => true, :edismax => true do
      # dismax:  returns 0 results
      # edismax:  returns all documents  (or timeout error?)
      resp = solr_resp_ids_from_query '*'  
      resp.should have_at_least(6900000).documents
    end
  end
  
  it "non-dismax special lone characters should politely return 0 results" do
    # lucene query parsing special chars that are not special to dismax:
    # && || ! ( ) { } [ ] ^ ~ * ? : \
    resp = solr_resp_ids_from_query '&'
    resp.should_not have_documents
    resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('|'))
    resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('('))
    resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query(')'))
    resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('{'))
    resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('}'))
    resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('['))
    resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query(']'))
    resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('^'))
    resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('~'))
    resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query(':'))
    resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('\\'))
    resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query(';'))
    # get results
#    resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('!'))  # gets a result (4085487)
#    resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('.'))  # gets a result (398240)
    # solr errors
#    resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('%2B'))  # '+' gives 400 error
#    resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('-'))  # gives 400 error
#    resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('&&'))  # gives 400 error
#    resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('||')) # gives 400 error
  end
  
end