require 'spec_helper'

describe "ampersands in queries" do

  context "2 term query 'Bandits & Bureaucrats'", :jira => 'VUF-831' do
    before(:all) do
      @resp_amp = solr_resp_doc_ids_only({'q'=>'Bandits & Bureaucrats'})
      @resp_plain = solr_resp_doc_ids_only({'q'=>'Bandits Bureaucrats'})
      @resp_phrase = solr_resp_doc_ids_only({'q'=>'"Bandits Bureaucrats"'})
      @resp_amp_phrase = solr_resp_doc_ids_only({'q'=>'"Bandits & Bureaucrats"'})
    end
    it "should ignore the ampersand (same as AND if # terms is less than mm threshold)" do
      @resp_amp.should have_at_least(5).documents
      @resp_amp.should include("2972993").as_first.document
      @resp_amp.should have_the_same_number_of_documents_as(@resp_plain)
    end
    it "phrase query with ampersand should behave like phrase query without ampersand" do
      @resp_amp_phrase.should include("2972993").as_first.document
      @resp_amp_phrase.should have_the_same_number_of_documents_as(@resp_phrase)
    end
    it "phrase query should have fewer results than non-phrase query" do
      @resp_amp_phrase.should have_fewer_documents_than(@resp_amp)
    end
    context "title search" do
      before(:all) do
        @tresp_amp = solr_resp_doc_ids_only(title_search_args('Bandits & Bureaucrats'))
        @tresp_plain = solr_resp_doc_ids_only(title_search_args('Bandits Bureaucrats'))
        @tresp_phrase = solr_resp_doc_ids_only(title_search_args('"Bandits Bureaucrats"'))
        @tresp_amp_phrase = solr_resp_doc_ids_only(title_search_args('"Bandits & Bureaucrats"'))
      end
      it "should ignore the ampersand (same as AND if # terms is less than mm threshold)" do
        @tresp_amp.should have_at_most(5).documents
        @tresp_amp.should include("2972993").as_first.document
        @tresp_amp.should have_the_same_number_of_documents_as(@tresp_plain)
      end
      it "phrase query with ampersand should behave like phrase query without ampersand" do
        @tresp_amp_phrase.should include("2972993").as_first.document
        @tresp_amp_phrase.should have_the_same_number_of_documents_as(@tresp_phrase)
      end
      # these are currently the same -- 1 result
#      it "phrase query should have fewer results than non-phrase query" do
#        @tresp_amp_phrase.should have_fewer_documents_than(@tresp_amp)
#      end 
    end # context title search
  end # context bandits & bureaucrats

  context "2 term query 'time & money'" do
    before(:all) do
      @resp = solr_resp_doc_ids_only({'q'=>'time & money'})
    end
    it "should ignore the ampersand (same as AND if # terms is less than mm threshold)" do
      @resp.should include("3042571").in_first(2).documents
      @resp.should have_the_same_number_of_documents_as(solr_resp_doc_ids_only({'q'=>'time money'}))
    end
    it "should have more results than a phrase query" do
      @resp.should have_more_documents_than(solr_resp_doc_ids_only({'q'=>'"time money"'}))
    end
    context "title search" do
      before(:all) do
        @tresp = solr_resp_doc_ids_only(title_search_args('time & money'))
      end
      it "should ignore the ampersand (same as AND if # terms is less than mm threshold)" do
        @tresp.should include("3042571").in_first(2).documents
        @tresp.should have_the_same_number_of_documents_as(solr_resp_doc_ids_only(title_search_args('time money')))
      end
      it "should have more results than a phrase query" do
        @tresp.should have_more_documents_than(solr_resp_doc_ids_only(title_search_args('"time money"')))
      end
    end
  end # context  time & money

  context "3 term query 'of time & place' (stopword 'of')" do
    before(:all) do
      @resp = solr_resp_doc_ids_only({'q'=>'of time & place'})
      @presp = solr_resp_doc_ids_only({'q'=>'"of time & place"'})
    end
    it "should ignore the ampersand (same as AND if # terms is less than mm threshold)" do
      @resp.should include(["2186298", "9348274"]).in_first(3).documents
      @resp.should have_the_same_number_of_documents_as(solr_resp_doc_ids_only({'q'=>'of time place'}))
    end
    context "phrase query" do
# FIXME: @presp is empty?      
#      @resp.should have_more_documents_than(@presp)
#      @presp.should include(["2186298", "9348274"]).in_first(3).documents
#      @presp.should have_the_same_number_of_documents_as(solr_resp_doc_ids_only({'q'=>'"of time place"'}))
    end
    context "title search" do
      before(:all) do
        @tresp = solr_resp_doc_ids_only(title_search_args('of time & place'))
        @ptresp = solr_resp_doc_ids_only(title_search_args('"of time & place"'))
      end
      it "should ignore the ampersand (same as AND if # terms is less than mm threshold)" do
        @tresp.should include("2186298").as_first.document
        @tresp.should have_the_same_number_of_documents_as(solr_resp_doc_ids_only(title_search_args('of time place')))
      end
      context "phrase query" do
#        @tresp.should have_more_documents_than(@ptresp)
#        @ptresp.should include("2186298").as_first.document
#        @ptresp.should have_the_same_number_of_documents_as(solr_resp_doc_ids_only({'q'=>'"of time place"', 'qt'=>'search_title'}))
      end
    end    
  end # context  of time & place
  
  context "3 term query 'ESRI data & maps' (0 stopwords)", :jira=>'SW-85' do
    before(:all) do
      @resp = solr_resp_doc_ids_only({'q'=>'ESRI data & maps'})
      @presp = solr_resp_doc_ids_only({'q'=>'"ESRI data & maps"'})
    end
    it "should ignore the ampersand (same as AND if # terms is less than mm threshold)" do
      @resp.should include(["5468146", "4244185", "5412572", "5412597", "4798829", "4554456", "7652136", "5675395", "6738945", "5958512"]).in_first(15).documents
      @resp.should have_the_same_number_of_documents_as(solr_resp_doc_ids_only({'q'=>'ESRI data maps'}))
    end
    context "phrase query" do
#      @resp.should have_more_documents_than(@presp)
#      @presp.should include(["5468146", "4244185", "5412572", "5412597", "4798829", "4554456", "7652136", "5675395", "6738945", "5958512"]).in_first(15).documents
#      @presp.should have_the_same_number_of_documents_as(solr_resp_doc_ids_only({'q'=>'"ESRI data maps"'}))
    end
    context "title search" do
      before(:all) do
        @tresp = solr_resp_doc_ids_only(title_search_args('ESRI data & maps'))
        @ptresp = solr_resp_doc_ids_only(title_search_args('"ESRI data & maps"'))
      end
      it "should ignore the ampersand (same as AND if # terms is less than mm threshold)" do
        @tresp.should include(["5468146", "4244185", "5412572", "5412597", "4798829", "4554456", "7652136", "5675395", "6738945", "5958512"]).in_first(15).documents
        @tresp.should have_the_same_number_of_documents_as(solr_resp_doc_ids_only(title_search_args('ESRI data maps')))
      end
      context "phrase query" do
#        @tresp.should have_more_results_than(@ptresp)
#        @ptresp.should include(["5468146", "4244185", "5412572", "5412597", "4798829", "4554456", "7652136", "5675395", "6738945", "5958512"]).in_first(15).documents
#        @ptresp.should have_the_same_number_of_documents_as(solr_resp_doc_ids_only({'q'=>'"ESRI data maps"', 'qt'=>'search_title'}))
      end
    end    
  end # context  ESRI data & maps

=begin
  Scenario: 3 term query with AMPERSAND, 0 Stopwords   (VUF-1057)
    When I go to the home page
    And I fill in "q" with "Crystal growth & design"
    And I press "search"
    Then I should get ckey 4371266 in the first 1 results  
    And I should get the same number of results as a search for "Crystal growth design"
    And I should get more results than a search for "\"Crystal growth design\""

  Scenario: 3 term PHRASE query with AMPERSAND, 0 Stopwords   (VUF-1057)
    When I go to the home page
    And I fill in the search box with "\"Crystal growth & design\""
    And I press "search"
    Then I should get ckey 4371266 in the first 1 results  
    And I should get the same number of results as a search for "\"Crystal growth design\""

  Scenario: 3 term TITLE query with AMPERSAND, 0 Stopwords   (VUF-1057)
    When I go to the home page
    And I fill in "q" with "Crystal growth & design"
    And I select "Title" from "search_field"
    And I press "search"
    Then I should get ckey 4371266 in the first 1 results  
    And I should get the same number of results as a title search for "Crystal growth design"
    And I should get more results than a title search for "\"Crystal growth design\""

  Scenario: 3 term TITLE PHRASE query with AMPERSAND, 0 Stopwords  (VUF-1057)
    When I go to the home page
    And I fill in the search box with "\"Crystal growth & design\""
    And I select "Title" from "search_field"
    And I press "search"
    Then I should get ckey 4371266 in the first 1 results  
    And I should get the same number of results as a title search for "\"Crystal growth design\""



  Scenario: 3 term query with AMPERSAND, 0 Stopwords   (VUF-1100)
    When I go to the home page
    And I fill in "q" with "Fish & Shellfish Immunology"
    And I press "search"
    Then I should get ckey 2405684 in the first 3 results  
    And I should get the same number of results as a search for "Fish Shellfish Immunology"
    And I should get more results than a search for "\"Fish Shellfish Immunology\""

  Scenario: 3 term PHRASE query with AMPERSAND, 0 Stopwords   (VUF-1100)
    When I go to the home page
    And I fill in the search box with "\"Fish & Shellfish Immunology\""
    And I press "search"
    Then I should get ckey 2405684 in the first 3 results  
    And I should get the same number of results as a search for "\"Fish Shellfish Immunology\""

  Scenario: 3 term TITLE query with AMPERSAND, 0 Stopwords   (VUF-1100)
    When I go to the home page
    And I fill in "q" with "Fish & Shellfish Immunology"
    And I select "Title" from "search_field"
    And I press "search"
    Then I should get ckey 2405684 in the first 3 results  
    And I should get the same number of results as a title search for "\"Fish Shellfish Immunology\""

  Scenario: 3 term TITLE PHRASE query with AMPERSAND, 0 Stopwords  (VUF-1100)
    When I go to the home page
    And I fill in the search box with "\"Fish & Shellfish Immunology\""
    And I select "Title" from "search_field"
    And I press "search"
    Then I should get ckey 2405684 in the first 3 results  
    And I should get the same number of results as a title search for "\"Fish Shellfish Immunology\""



  Scenario: 3 term query with AMPERSAND, 0 Stopwords   (VUF-1150)
    When I go to the home page
    And I fill in "q" with "Environmental Science & Technology"
    And I press "search"
    Then I should get ckey 2956046 in the first 1 result
    And I should get the same number of results as a search for "Environmental Science Technology"
    And I should get more results than a search for "\"Environmental Science Technology\""

  Scenario: 3 term PHRASE query with AMPERSAND, 0 Stopwords   (VUF-1150)
    When I go to the home page
    And I fill in the search box with "\"Environmental Science & Technology\""
    And I press "search"
    Then I should get ckey 2956046 in the first 1 result
    And I should get the same number of results as a search for "\"Environmental Science Technology\""

  Scenario: 3 term TITLE query with AMPERSAND, 0 Stopwords   (VUF-1150)
    When I go to the home page
    And I fill in "q" with "Environmental Science & Technology"
    And I select "Title" from "search_field"
    And I press "search"
    Then I should get ckey 2956046 in the first 1 result
    And I should get the same number of results as a title search for "Environmental Science Technology"
    And I should get more results than a title search for "\"Environmental Science Technology\""

  Scenario: 3 term TITLE PHRASE query with AMPERSAND, 0 Stopwords  (VUF-1150)
    When I go to the home page
    And I fill in the search box with "\"Environmental Science & Technology\""
    And I select "Title" from "search_field"
    And I press "search"
    Then I should get ckey 2956046 in the first 1 result
    And I should get the same number of results as a title search for "\"Environmental Science Technology\""



  Scenario: 3 term query with AMPERSAND, 2 Stopwords 
    When I go to the home page
    And I fill in "q" with "Zen & the Art of Motorcycle"
    And I press "search"
    Then I should get at least 2 of these ckeys in the first 3 results: "1464048, 524822"
    And I should get the same number of results as a search for "Zen the Art of Motorcycle"

  Scenario: 3 term PHRASE query with AMPERSAND, 2 Stopwords 
    When I go to the home page
    And I fill in the search box with "\"Zen & the Art of Motorcycle\""
    And I press "search"
    Then I should get at least 2 of these ckeys in the first 3 results: "1464048, 524822"
    And I should get the same number of results as a search for "\"Zen the Art of Motorcycle\""

  Scenario: 3 term TITLE query with AMPERSAND, 2 Stopwords 
    When I go to the home page
    And I fill in "q" with "Zen & the Art of Motorcycle"
    And I select "Title" from "search_field"
    And I press "search"
    Then I should get at least 2 of these ckeys in the first 3 results: "1464048, 524822"
    And I should get the same number of results as a title search for "Zen the Art of Motorcycle"

  Scenario: 3 term TITLE PHRASE query with AMPERSAND, 2 Stopwords
    When I go to the home page
    And I fill in the search box with "\"Zen & the Art of Motorcycle\""
    And I select "Title" from "search_field"
    And I press "search"
    Then I should get at least 2 of these ckeys in the first 3 results: "1464048, 524822"
    And I should get the same number of results as a title search for "\"Zen the Art of Motorcycle\""



  Scenario: 3 term query with AMPERSAND, 2 Stopwords 
    When I go to the home page
    And I fill in "q" with "anatomy of the dog & cat"
    And I press "search"
    Then I should get ckey 3324413 in the first 1 results  
    And I should get the same number of results as a search for "anatomy of the dog cat"
    And I should get more results than a search for "\"anatomy of the dog cat\""



  Scenario: 3 term TITLE query with AMPERSAND, 2 Stopwords 
    When I go to the home page
    And I fill in "q" with "horn violin & piano"
    And I select "Title" from "search_field"
    And I press "search"
    Then I should get ckey 298114 in the first 11 results  
    And I should get the same number of results as a title search for "horn violin piano"
    And I should get more results than a title search for "\"horn violin piano\""



  Scenario: 4 term query with AMPERSAND, 0 Stopwords 
    When I go to the home page
    And I fill in "q" with "crosby stills nash & young"
    And I press "search"
    Then I should get ckey 5627798 in the first 1 results
    And I should get the same number of results as a search for "crosby stills nash young"

  Scenario: 4 term PHRASE query with AMPERSAND, 0 Stopwords 
    When I go to the home page
    And I fill in the search box with "\"crosby stills nash & young\""
    And I press "search"
    Then I should get ckey 5627798 in the first 1 results
    And I should get the same number of results as a search for "\"crosby stills nash young\""

  Scenario: 4 term TITLE query with AMPERSAND, 0 Stopwords 
    When I go to the home page
    And I fill in "q" with "crosby stills nash & young"
    And I select "Title" from "search_field"
    And I press "search"
    Then I should get ckey 5627798 in the first 1 results
    And I should get the same number of results as a title search for "crosby stills nash young"

  Scenario: 4 term TITLE PHRASE query with AMPERSAND, 0 Stopwords
    When I go to the home page
    And I fill in the search box with "\"crosby stills nash & young\""
    And I select "Title" from "search_field"
    And I press "search"
    Then I should get ckey 5627798 in the first 1 results
    And I should get the same number of results as a title search for "\"crosby stills nash young\""



  Scenario: 4 term query with AMPERSAND, 0 Stopwords 
    When I go to the home page
    And I fill in "q" with "steam boat & canal routes"
    And I press "search"
    Then I should get ckey 5723944 in the first 1 results
    And I should get the same number of results as a search for "steam boat canal routes"
    And I should get more results than a search for "\"steam boat canal routes\""

  Scenario: 4 term TITLE query with AMPERSAND, 0 Stopwords 
    When I go to the home page
    And I fill in "q" with "steam boat & canal routes"
    And I select "Title" from "search_field"
    And I press "search"
    Then I should get ckey 5723944 in the first 1 results
    And I should get the same number of results as a title search for "steam boat canal routes"
    And I should get more results than a title search for "\"steam boat canal routes\""



  Scenario: 4 term query with AMPERSAND, 2 Stopwords 
    When I go to the home page
    And I fill in "q" with "Zen & the Art of Motorcycle maintenance"
    And I press "search"
    Then I should get at least 2 of these ckeys in the first 3 results: "1464048, 524822"
    And I should get the same number of results as a search for "Zen the Art of Motorcycle maintenance"

  Scenario: 4 term PHRASE query with AMPERSAND, 2 Stopwords 
    When I go to the home page
    And I fill in the search box with "\"Zen & the Art of Motorcycle maintenance\""
    And I press "search"
    Then I should get at least 2 of these ckeys in the first 3 results: "1464048, 524822"
    And I should get the same number of results as a search for "\"Zen the Art of Motorcycle maintenance\""

  Scenario: 4 term TITLE query with AMPERSAND, 2 Stopwords 
    When I go to the home page
    And I fill in "q" with "Zen & the Art of Motorcycle maintenance"
    And I select "Title" from "search_field"
    And I press "search"
    Then I should get at least 2 of these ckeys in the first 3 results: "1464048, 524822"
    And I should get the same number of results as a title search for "Zen the Art of Motorcycle maintenance"

  Scenario: 4 term TITLE PHRASE query with AMPERSAND, 2 Stopwords
    When I go to the home page
    And I fill in the search box with "\"Zen & the Art of Motorcycle maintenance\""
    And I select "Title" from "search_field"
    And I press "search"
    Then I should get at least 2 of these ckeys in the first 3 results: "1464048, 524822"
    And I should get the same number of results as a title search for "\"Zen the Art of Motorcycle maintenance\""



  Scenario: 4 term query with AMPERSAND, 2 Stopwords 
    When I go to the home page
    And I fill in "q" with "the truth about cats & dogs"
    And I press "search"
    Then I should get ckey 5646609 in the first 1 results  
    And I should get the same number of results as a search for "the truth about cats dogs"
    And I should get more results than a search for "\"the truth about cats dogs\""

  Scenario: 4 term TITLE query with AMPERSAND, 2 Stopwords 
    When I go to the home page
    And I fill in "q" with "the truth about cats & dogs"
    And I select "Title" from "search_field"
    And I press "search"
    Then I should get ckey 5646609 in the first 1 results  
    And I should get the same number of results as a title search for "the truth about cats dogs"
    And I should get more results than a title search for "\"the truth about cats dogs\""



  Scenario: 5 term query with AMPERSAND, 0 Stopwords 
    When I go to the home page
    And I fill in "q" with "horns, violins, viola, cello & organ"
    And I press "search"
    Then I should get ckey 6438612 in the first 1 results
    And I should get the same number of results as a search for "horns, violins, viola, cello organ"
    And I should get more results than a search for "\"horns, violins, viola, cello organ\""

  Scenario: 5 term PHRASE query with AMPERSAND, 0 Stopwords 
    When I go to the home page
    And I fill in the search box with "\"horns, violins, viola, cello & organ\""
    And I press "search"
    Then I should get ckey 6438612 in the first 1 results
    And I should get the same number of results as a search for "\"horns, violins, viola, cello organ\""

  Scenario: 5 term TITLE query with AMPERSAND, 0 Stopwords 
    When I go to the home page
    And I fill in "q" with "horns, violins, viola, cello & organ"
    And I select "Title" from "search_field"
    And I press "search"
    Then I should get ckey 6438612 in the first 1 results
    And I should get the same number of results as a title search for "horns, violins, viola, cello organ"
    And I should get more results than a title search for "\"horns, violins, viola, cello organ\""

  Scenario: 5 term TITLE PHRASE query with AMPERSAND, 0 Stopwords
    When I go to the home page
    And I fill in the search box with "\"horns, violins, viola, cello & organ\""
    And I select "Title" from "search_field"
    And I press "search"
    Then I should get ckey 6438612 in the first 1 results
    And I should get the same number of results as a title search for "\"horns, violins, viola, cello organ\""



  Scenario: 5 term query with AMPERSAND, 1 Stopword 
    When I go to the home page
    And I fill in "q" with "Dr. Seuss & Mr. Geisel : a biography"
    And I press "search"
    Then I should get ckey 2997769 in the first 1 results
    And I should get the same number of results as a search for "Dr. Seuss Mr. Geisel : a biography"

  Scenario: 5 term PHRASE query with AMPERSAND, 1 Stopword
    When I go to the home page
    And I fill in the search box with "\"Dr. Seuss & Mr. Geisel : a biography\""
    And I press "search"
    Then I should get ckey 2997769 in the first 1 results
    And I should get the same number of results as a search for "\"Dr. Seuss Mr. Geisel : a biography\""

  Scenario: 5 term TITLE query with AMPERSAND, 1 Stopword 
    When I go to the home page
    And I fill in "q" with "Dr. Seuss & Mr. Geisel : a biography"
    And I select "Title" from "search_field"
    And I press "search"
    Then I should get ckey 2997769 in the first 1 results
    And I should get the same number of results as a title search for "Dr. Seuss Mr. Geisel : a biography"

  Scenario: 5 term TITLE PHRASE query with AMPERSAND, 1 Stopword
    When I go to the home page
    And I fill in the search box with "\"Dr. Seuss & Mr. Geisel : a biography\""
    And I select "Title" from "search_field"
    And I press "search"
    Then I should get ckey 2997769 in the first 1 results
    And I should get the same number of results as a title search for "\"Dr. Seuss Mr. Geisel : a biography\""



  Scenario: 6 term query with AMPERSAND, 0 Stopwords 
    When I go to the home page
    And I fill in "q" with "horns, violins, viola, cello & organ continuo"
    And I press "search"
    Then I should get ckey 6438612 in the first 1 results
    And I should get the same number of results as a search for "horns, violins, viola, cello organ continuo"
    And I should get the same number of results as a search for "\"horns, violins, viola, cello organ continuo\""

  Scenario: 6 term PHRASE query with AMPERSAND, 0 Stopwords 
    When I go to the home page
    And I fill in the search box with "\"horns, violins, viola, cello & organ continuo\""
    And I press "search"
    Then I should get ckey 6438612 in the first 1 results
    And I should get the same number of results as a search for "\"horns, violins, viola, cello organ continuo\""

  Scenario: 6 term TITLE query with AMPERSAND, 0 Stopwords 
    When I go to the home page
    And I fill in "q" with "horns, violins, viola, cello & organ continuo"
    And I select "Title" from "search_field"
    And I press "search"
    Then I should get ckey 6438612 in the first 1 results
    And I should get the same number of results as a title search for "horns, violins, viola, cello organ continuo"
    And I should get the same number of results as a title search for "\"horns, violins, viola, cello organ continuo\""

  Scenario: 6 term TITLE PHRASE query with AMPERSAND, 0 Stopwords
    When I go to the home page
    And I fill in the search box with "\"horns, violins, viola, cello & organ continuo\""
    And I select "Title" from "search_field"
    And I press "search"
    Then I should get ckey 6438612 in the first 1 results
    And I should get the same number of results as a title search for "\"horns, violins, viola, cello organ continuo\""



  Scenario: 6 term query with AMPERSAND, 1 Stopword 
    When I go to the home page
    And I fill in "q" with "Practical legal problems in music & recording industry"
    And I press "search"
    Then I should get ckey 1804064 in the first 1 results
    And I should get the same number of results as a search for "Practical legal problems in music recording industry"

  Scenario: 6 term PHRASE query with AMPERSAND, 1 Stopword
    When I go to the home page
    And I fill in the search box with "\"Practical legal problems in music & recording industry\""
    And I press "search"
    Then I should get ckey 1804064 in the first 1 results
    And I should get the same number of results as a search for "\"Practical legal problems in music recording industry\""

  Scenario: 6 term TITLE query with AMPERSAND, 1 Stopword 
    When I go to the home page
    And I fill in "q" with "Practical legal problems in music & recording industry"
    And I select "Title" from "search_field"
    And I press "search"
    Then I should get ckey 1804064 in the first 1 results
    And I should get the same number of results as a title search for "Practical legal problems in music recording industry"

  Scenario: 6 term TITLE PHRASE query with AMPERSAND, 1 Stopword
    When I go to the home page
    And I fill in the search box with "\"Practical legal problems in music recording industry\""
    And I select "Title" from "search_field"
    And I press "search"
    Then I should get ckey 1804064 in the first 1 results
    And I should get the same number of results as a title search for "\"Practical legal problems in music recording industry\""



  Scenario: multiple AMPERSANDs, 0 Stopwords 
    When I go to the home page
    And I fill in "q" with "Bob & Carol & Ted & Alice"
    And I press "search"
    Then I should get ckey 5742243 in the first 1 results
    And I should get the same number of results as a search for "Bob Carol & Ted & Alice"
    And I should get the same number of results as a search for "Bob & Carol Ted & Alice"
    And I should get the same number of results as a search for "Bob & Carol & Ted Alice"
    And I should get the same number of results as a search for "Bob Carol Ted & Alice"
    And I should get the same number of results as a search for "Bob Carol & Ted Alice"
    And I should get the same number of results as a search for "Bob & Carol Ted Alice"
    And I should get the same number of results as a search for "Bob Carol Ted Alice"

  Scenario: multiple AMPERSANDs, 0 Stopwords 
    When I go to the home page
    And I fill in the search box with "\"Bob & Carol & Ted & Alice\""
    And I press "search"
    Then I should get ckey 5742243 in the first 1 results
    And I should get the same number of results as a search for "\"Bob Carol & Ted & Alice\""
    And I should get the same number of results as a search for "\"Bob & Carol Ted & Alice\""
    And I should get the same number of results as a search for "\"Bob & Carol & Ted Alice\""
    And I should get the same number of results as a search for "\"Bob Carol Ted & Alice\""
    And I should get the same number of results as a search for "\"Bob Carol & Ted Alice\""
    And I should get the same number of results as a search for "\"Bob & Carol Ted Alice\""
    And I should get the same number of results as a search for "\"Bob Carol Ted Alice\""

  Scenario: multiple AMPERSANDs, 0 Stopwords 
    When I go to the home page
    And I fill in "q" with "Bob & Carol & Ted & Alice"
    And I select "Title" from "search_field"
    And I press "search"
    Then I should get ckey 5742243 in the first 1 results
    And I should get the same number of results as a title search for "Bob & Carol & Ted & Alice"
    And I should get the same number of results as a title search for "Bob Carol & Ted & Alice"
    And I should get the same number of results as a title search for "Bob & Carol Ted & Alice"
    And I should get the same number of results as a title search for "Bob & Carol & Ted Alice"
    And I should get the same number of results as a title search for "Bob Carol Ted & Alice"
    And I should get the same number of results as a title search for "Bob Carol & Ted Alice"
    And I should get the same number of results as a title search for "Bob & Carol Ted Alice"
    And I should get the same number of results as a title search for "Bob Carol Ted Alice"

  Scenario: multiple AMPERSANDs, 0 Stopwords 
    When I go to the home page
    And I fill in the search box with "\"Bob & Carol & Ted & Alice\""
    And I select "Title" from "search_field"
    And I press "search"
    Then I should get ckey 5742243 in the first 1 results
    And I should get the same number of results as a title search for "\"Bob Carol & Ted & Alice\""
    And I should get the same number of results as a title search for "\"Bob & Carol Ted & Alice\""
    And I should get the same number of results as a title search for "\"Bob & Carol & Ted Alice\""
    And I should get the same number of results as a title search for "\"Bob Carol Ted & Alice\""
    And I should get the same number of results as a title search for "\"Bob Carol & Ted Alice\""
    And I should get the same number of results as a title search for "\"Bob & Carol Ted Alice\""
    And I should get the same number of results as a title search for "\"Bob Carol Ted Alice\""
=end
end