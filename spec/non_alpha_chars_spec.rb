require 'spec_helper'

describe "Terms with Numbers or other oddities" do
  
  it "q of 'Two3' should have excellent results", :jira => 'VUF-386' do
    resp = solr_resp_doc_ids_only({'q'=>'Two3'})
    resp.should have_at_most(10).documents
    resp.should include("5732752").as_first_result
    resp.should include("8564713").in_first(2).results
    resp.should_not include("5727394")
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'two3'}))
    resp.should have_fewer_results_than(solr_resp_doc_ids_only({'q'=>'two 3'}))
  end
  
  context "square brackets" do
    it "as part of q string should be ignored" do
      resp = solr_resp_doc_ids_only({'q'=>'mark twain [pseud]'})
      resp.should have_at_least(125).documents
      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>"mark twain pseud"}))
    end

    it "as part of phrase query should be ignored" do
      resp = solr_resp_doc_ids_only({'q'=>'"mark twain [pseud]"'})
      resp.should have_at_least(125).documents
      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'"mark twain pseud"'}))
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
  end
  
  context "slash" do
    it "surround by spaces should be ignored" do
      resp = solr_resp_doc_ids_only({'q'=>'Physical chemistry / Ira N Levine'})
      resp.should include(["1726910", "3016212", "4712578", "7633476"]).in_first(5).results
    end
    
    it "within numbers, no letters (56 1/2)", :jira => 'VUF-389' do
      resp = solr_resp_doc_ids_only({'q'=>'56 1/2'})
      resp.should include(["6031340", "5491883"]).in_first(3).results
    end
    
    it "within numbers, no letters (33 1/3)", :jira => 'VUF-178' do
      resp = solr_resp_doc_ids_only(title_search_args('33 1/3'))
      resp.should have_at_least(85).results  # Socrates gets 104 titles as of 2010-11-03
      resp.should include("6721172").in_first(3).results
    end
  end # context slash
  
  it "should ignore punctuation inside a phrase" do
    resp = solr_resp_doc_ids_only({'q'=>'""Alice in Wonderland : a serie[s]"'})
    resp.should have_at_least(2).documents
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'"Alice in Wonderland a serie[s]"'}))
  end
  
  context "unmatched pairs" do    
    it "unmatched double quote should be ignored" do
      resp = solr_resp_doc_ids_only({'q'=>'"space traveler'})
      resp.should have_documents
      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'space traveler'}))
      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'space" traveler'}))
      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'space "traveler'}))
      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'space " traveler'}))
      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'space traveler"'}))
    end
    
    it "unmatched single quote should be ignored" do
      resp = solr_resp_doc_ids_only({'q'=>"'space traveler"})
      resp.should have_documents
      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>"space traveler"}))
      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>"space' traveler"}))
      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>"space 'traveler"}))
      # single char on its lonesome becomes a term?
#      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>"space ' traveler"}))
      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>"space traveler'"}))
    end
    
    it "unmatched square bracked should be ignored" do
      resp = solr_resp_doc_ids_only({'q'=>"[wise up"})
      resp.should have_documents
      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>"wise up"}))
      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>"wise[ up"}))
      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>"wise [up"}))
      # single char on its lonesome becomes a term?
#      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>"wise [ up"}))
      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>"wise up["}))
      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>"]wise up"}))
      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>"wise] up"}))
      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>"wise ]up"}))
      # single char on its lonesome becomes a term?
#      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>"wise ] up"}))
      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>"wise up]"}))
    end
    
    it "unmatched curly brace should be ignored" do
      resp = solr_resp_doc_ids_only({'q'=>"{final chord"})
      resp.should have_documents
      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>"final chord"}))
      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>"final{ chord"}))
      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>"final {chord"}))
      # single char on its lonesome becomes a term?
#      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>"final { chord"}))
      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>"final chord{"}))
      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>"}final chord"}))
      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>"final} chord"}))
      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>"final }chord"}))
      # single char on its lonesome becomes a term?
#      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>"final } chord"}))
      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>"final chord}"}))
    end

  end # unmatched pairs
  
end