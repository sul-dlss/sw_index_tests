require 'spec_helper'
require 'rspec-solr'

describe "boolean operators" do
  
  # TODO: more better tests for lowercase and?
  # TODO: what about lowercase not?
  # TODO: what about OR/or ?

  # TODO: move this to hyphen feature
=begin
    Scenario: Hyphen Between Two Letters Ignored
      # see also:  dismax features (these queries without and)
      When I am on the home page
      And I fill in "q" with "South Africa, Shakespeare and post-colonial culture"
      And I press "search"
      Then I should get results
=end  

  context "default operator:  AND" do

    context "everything search" do
      it "more search terms should get fewer results" do
        resp = solr_resp_doc_ids_only({'q'=>'horn'})
        resp.should have_more_documents_than(solr_resp_doc_ids_only({'q'=>'french horn'}))
      end
      it "loggerhead turtles should not have Shakespeare in facets", :fixme => 'need facet parsing' do
        resp = solr_resp_doc_ids_only({'q'=>'loggerhead turtles'})
        # this was in the facets when default was "OR"
        # Then I should not see "Shakespeare"
      end
    end

    context "author search" do
      it "more search terms should get fewer results" do
        resp = solr_resp_doc_ids_only({'q'=>'michaels', 'qt'=>'search_author'})
        resp.should have_more_documents_than(solr_resp_doc_ids_only({'q'=>'leonard michaels', 'qt'=>'search_author'}))
      end
    end
    
    context "title search" do
      it "more search terms should get fewer results" do
        resp = solr_resp_doc_ids_only({'q'=>'turtles', 'qt'=>'search_title'})
        resp.should have_more_documents_than(solr_resp_doc_ids_only({'q'=>'sea turtles', 'qt'=>'search_title'}))
      end
    end
    
    it "across MARC fields (author and title)" do
      resp = solr_resp_doc_ids_only({'q'=>'gulko sea turtles'})
      resp.should have(1).document
      resp.should include("5958831")
      resp = solr_resp_doc_ids_only({'q'=>'eckert sea turtles'})
      resp.should have(1).document
      resp.should include("5958831")
    end
    
    context "5 terms with AND" do
      before(:all) do
        @resp = solr_resp_doc_ids_only({'q'=>'Catholic thought AND papal jewry policy'})
      end
      it "should include doc 1711043" do
        @resp.should have(1).document
        @resp.should include("1711043")
      end
      it "should get the same results as lowercase 'and'" do
        @resp.should have_the_same_number_of_documents_as(solr_resp_doc_ids_only({'q'=>'Catholic thought and papal jewry policy'}))
      end
    end
    
    it "lower case 'and' behaves like upper case AND", :jira => 'VUF-626' do
      resp = solr_resp_doc_ids_only({'q'=>'South Africa, Shakespeare AND post-colonial culture'})
      resp.should include(["8505958", "4745861", "7837826", "7756621"])
      resp2 = solr_resp_doc_ids_only({'q'=>'South Africa, Shakespeare and post-colonial culture'})
      resp2.should include(["8505958", "4745861", "7837826", "7756621"])
      resp.should have_the_same_number_of_documents_as(resp2)
    end
    
  end # context AND
  
  context "NOT operator" do
    
    context "cats NOT poets" do
      before(:all) do
        @resp = solr_resp_doc_ids_only({'q'=>'cats NOT poets'})
      end
      it "should have no results with poet" do
        # TODO: this test needs work -- there are 19843 results!
        @resp.should have_documents
        @resp.should_not include("5373870")
        resp2 = solr_resp_doc_ids_only({'q'=>'cats poets'})
        resp2.should include("5373870")
      end
      it "should have fewer results than query 'cats'" do
        @resp.should have_fewer_documents_than(solr_resp_doc_ids_only({'q'=>'cats'}))
      end
      it "should be equivalent to cats -poets" do
        @resp.should have_the_same_number_of_documents_as(solr_resp_doc_ids_only({'q'=>'cats -poets'}))
      end 
    end
    
    context "wb4 NOT shakespeare" do
      before(:all) do
        @resp = solr_resp_doc_ids_only({'q'=>'wb4 NOT shakespeare'})
      end
      it "should have no results with shakespeare" do
        # TODO: this test needs work -- there are 7202 results!
        @resp.should have_documents
        @resp.should_not include("1989093")
        resp2 = solr_resp_doc_ids_only({'q'=>'wb4 shakespeare'})
        resp2.should include("1989093")
      end
      it "should have fewer results than query 'wb4'" do
        @resp.should have_fewer_documents_than(solr_resp_doc_ids_only({'q'=>'wb4'}))
      end
      it "should be equivalent to wb4 -shakespeare" do
        @resp.should have_the_same_number_of_documents_as(solr_resp_doc_ids_only({'q'=>'wb4 -shakespeare'}))
      end
    end
    
    context "twain NOT sawyer" do
      before(:all) do
        @resp = solr_resp_doc_ids_only({'q'=>'twain NOT sawyer'})
      end
      it "should have fewer results than query 'twain'" do
        @resp.should have_documents
        @resp.should have_fewer_documents_than(solr_resp_doc_ids_only({'q'=>'twain'}))
      end
      it "should be equivalent to twain -sawyer" do
        @resp.should have_the_same_number_of_documents_as(solr_resp_doc_ids_only({'q'=>'twain -sawyer'}))
      end
    end

    context "query with NOT applied to phrase:  mark twain NOT 'tom sawyer'" do
      before(:all) do
        @resp = solr_resp_doc_ids_only({'q'=>'mark twain NOT "tom sawyer"'})
      end
      
      it "should have no results with 'tom sawyer' as a phrase", :fixme => true do
        @resp.should have_at_least(2).documents
        # TODO:  implement regular expression matcher
      end
      it "should be equivalent to mark twain -'tom sawyer'" do
        @resp =  have_the_same_number_of_documents_as(solr_resp_doc_ids_only({'q'=>'mark twain -"tom sawyer"'}))
      end
      it "should get more results than 'mark twain 'tom sawyer''" do
        @resp.should have_more_results_than(solr_resp_doc_ids_only({'q'=>'mark twain "tom sawyer"'}))
      end
      it "should get more results than 'mark twain tom sawyer'" do
        @resp.should have_more_results_than(solr_resp_doc_ids_only({'q'=>'mark twain tom sawyer'}))
      end
    end
  end # context NOT
  
end