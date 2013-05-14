require 'spec_helper'

describe "ampersands in queries" do

  shared_examples_for "ampersand ignored" do | q_with_amp, exp_ids, first_x |
    let(:q_no_amp) { q_with_amp.to_s.sub(' & ', ' ') }
    let(:resp) { solr_resp_ids_from_query(q_with_amp.to_s) }
    let(:presp) { solr_resp_ids_from_query("\"#{q_with_amp}\"") }
    let(:tresp) { solr_resp_doc_ids_only(title_search_args(q_with_amp)) }
    let(:ptresp) { solr_resp_doc_ids_only(title_search_args("\"#{q_with_amp}\"")) }
    it "should have great results for query" do
      resp.should include(exp_ids).in_first(first_x).documents
      presp.should include(exp_ids).in_first(first_x).documents
      tresp.should include(exp_ids).in_first(first_x).documents
      ptresp.should include(exp_ids).in_first(first_x).documents
    end
    it "should ignore ampersand in everything searches" do
      resp.should have_the_same_number_of_documents_as(solr_resp_ids_from_query(q_no_amp))
    end
    it "should ignore ampersand in everything phrase searches" do
      presp.should have_the_same_number_of_documents_as(solr_resp_ids_from_query("\"#{q_no_amp}\""))
    end
    it "should ignore ampersand in title searches" do
      tresp.should have_the_same_number_of_documents_as(solr_resp_doc_ids_only(title_search_args(q_no_amp)))
    end
    it "should ignore ampersand in title phrase searches" do
      ptresp.should have_the_same_number_of_documents_as(solr_resp_doc_ids_only(title_search_args("\"#{q_no_amp}\"")))
    end
  end

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
    context "title search" do
      before(:all) do
        @tresp = solr_resp_doc_ids_only(title_search_args('time & money'))
      end
      it "should ignore the ampersand (same as AND if # terms is less than mm threshold)" do
        @tresp.should include("3042571").in_first(2).documents
        @tresp.should have_the_same_number_of_documents_as(solr_resp_doc_ids_only(title_search_args('time money')))
      end
    end
  end # context  time & money

  context "3 term query 'of time & place' (former stopword 'of')" do
    before(:all) do
      @resp = solr_resp_doc_ids_only({'q'=>'of time & place'})
      @presp = solr_resp_doc_ids_only({'q'=>'"of time & place"'})
    end
    it "should ignore the ampersand (same as AND if # terms is less than mm threshold)" do
      @resp.should include(["2186298", "9348274"]).in_first(3).documents
      @resp.should have_the_same_number_of_documents_as(solr_resp_doc_ids_only({'q'=>'of time place'}))
    end
    it "phrase query should ignore the ampersand " do
      @presp.should include(["2186298", "9348274"]).in_first(3).documents
      @presp.should have_the_same_number_of_documents_as(solr_resp_doc_ids_only({'q'=>'"of time place"'}))
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
      it "phrase query should ignore the ampersand " do
        @ptresp.should include("2186298").as_first.document
        @ptresp.should have_the_same_number_of_documents_as(solr_resp_doc_ids_only(title_search_args('"of time place"')))
      end
    end    
  end # context  of time & place
  
  context "3 term query 'ESRI data & maps'", :jira=>'SW-85' do
    before(:all) do
      @resp = solr_resp_doc_ids_only({'q'=>'ESRI data & maps'})
      @presp = solr_resp_doc_ids_only({'q'=>'"ESRI data & maps"'})
    end
    it "should ignore the ampersand (same as AND if # terms is less than mm threshold)" do
      @resp.should include(["5468146", "4244185", "5412572", "5412597", "4798829", "4554456", "7652136", "5675395", "6738945", "5958512"]).in_first(15).documents
      @resp.should have_the_same_number_of_documents_as(solr_resp_doc_ids_only({'q'=>'ESRI data maps'}))
    end
    it "phrase query should ignore the ampersand" do
      @presp.should include(["5468146", "4244185", "5412572", "5412597", "4798829", "4554456", "7652136", "5675395", "6738945", "5958512"]).in_first(15).documents
      @presp.should have_the_same_number_of_documents_as(solr_resp_doc_ids_only({'q'=>'"ESRI data maps"'}))
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
      it "phrase query should ignore the ampersand" do
        @ptresp.should include(["5468146", "4244185", "5412572", "5412597", "4798829", "4554456", "7652136", "5675395", "6738945", "5958512"]).in_first(15).documents
        @ptresp.should have_the_same_number_of_documents_as(solr_resp_doc_ids_only(title_search_args('"ESRI data maps"')))
      end
    end    
  end # context  ESRI data & maps

  context "3 term query 'Crystal growth & design'", :jira=>'VUF-1057' do
    before(:all) do
      @resp = solr_resp_doc_ids_only({'q'=>'Crystal growth & design'})
      @presp = solr_resp_doc_ids_only({'q'=>'"Crystal growth & design"'})
    end
    it "should ignore the ampersand (same as AND if # terms is less than mm threshold)" do
      @resp.should include("4371266").as_first
      @resp.should have_the_same_number_of_documents_as(solr_resp_doc_ids_only({'q'=>'Crystal growth design'}))
    end
    it "phrase query should ignore the ampersand" do
      @presp.should include("4371266").as_first
      @presp.should have_the_same_number_of_documents_as(solr_resp_doc_ids_only({'q'=>'"Crystal growth design"'}))
    end
    context "title search" do
      before(:all) do
        @tresp = solr_resp_doc_ids_only(title_search_args('Crystal growth & design'))
        @ptresp = solr_resp_doc_ids_only(title_search_args('"Crystal growth & design"'))
      end
      it "should ignore the ampersand (same as AND if # terms is less than mm threshold)" do
        @tresp.should include("4371266").as_first
        @tresp.should have_the_same_number_of_documents_as(solr_resp_doc_ids_only(title_search_args('Crystal growth design')))
      end
      it "phrase query should ignore the ampersand" do
        @ptresp.should include("4371266").as_first
        @ptresp.should have_the_same_number_of_documents_as(solr_resp_doc_ids_only(title_search_args('"Crystal growth design"')))
      end
    end    
  end # context  Crystal growth & design

  context "3 term query 'Fish & Shellfish Immunology'", :jira=>'VUF-1100' do
    before(:all) do
      @resp = solr_resp_doc_ids_only({'q'=>'Fish & Shellfish Immunology'})
      @presp = solr_resp_doc_ids_only({'q'=>'"Fish & Shellfish Immunology"'})
    end
    it "should ignore the ampersand (same as AND if # terms is less than mm threshold)" do
      @resp.should include("2405684").in_first(3).documents
      @resp.should have_the_same_number_of_documents_as(solr_resp_doc_ids_only({'q'=>'Fish Shellfish Immunology'}))
    end
    it "phrase query should ignore the ampersand" do
      @presp.should include("2405684").in_first(3).documents
      @presp.should have_the_same_number_of_documents_as(solr_resp_doc_ids_only({'q'=>'"Fish Shellfish Immunology"'}))
    end
    context "title search" do
      before(:all) do
        @tresp = solr_resp_doc_ids_only(title_search_args('Fish & Shellfish Immunology'))
        @ptresp = solr_resp_doc_ids_only(title_search_args('"Fish & Shellfish Immunology"'))
      end
      it "should ignore the ampersand (same as AND if # terms is less than mm threshold)" do
        @tresp.should include("2405684").in_first(3).documents
        @tresp.should have_the_same_number_of_documents_as(solr_resp_doc_ids_only(title_search_args('Fish Shellfish Immunology')))
      end
      it "phrase query should ignore the ampersand" do
        @ptresp.should include("2405684").in_first(3).documents
        @ptresp.should have_the_same_number_of_documents_as(solr_resp_doc_ids_only(title_search_args('"Fish Shellfish Immunology"')))
      end
    end    
  end # context  Fish & Shellfish Immunology

  context "3 term query 'Environmental Science & Technology'", :jira=>'VUF-1150' do
    before(:all) do
      @resp = solr_resp_doc_ids_only({'q'=>'Environmental Science & Technology'})
      @presp = solr_resp_doc_ids_only({'q'=>'"Environmental Science & Technology"'})
    end
    it "should ignore the ampersand (same as AND if # terms is less than mm threshold)" do
      @resp.should include("2956046").as_first
      @resp.should have_the_same_number_of_documents_as(solr_resp_doc_ids_only({'q'=>'Environmental Science Technology'}))
    end
    it "phrase query should ignore the ampersand" do
      @presp.should include("2956046").as_first
      @presp.should have_the_same_number_of_documents_as(solr_resp_doc_ids_only({'q'=>'"Environmental Science Technology"'}))
    end
    context "title search" do
      before(:all) do
        @tresp = solr_resp_doc_ids_only(title_search_args('Environmental Science & Technology'))
        @ptresp = solr_resp_doc_ids_only(title_search_args('"Environmental Science & Technology"'))
      end
      it "should ignore the ampersand (same as AND if # terms is less than mm threshold)" do
        @tresp.should include("2956046").as_first
        @tresp.should have_the_same_number_of_documents_as(solr_resp_doc_ids_only(title_search_args('Environmental Science Technology')))
      end
      it "phrase query should ignore the ampersand" do
        @ptresp.should include("2956046").as_first
        @ptresp.should have_the_same_number_of_documents_as(solr_resp_doc_ids_only(title_search_args('"Environmental Science Technology"')))
      end
    end    
  end # context  Environmental Science & Technology

  context "4 term query title search 'horn violin & piano'" do
    before(:all) do
      @tresp = solr_resp_doc_ids_only(title_search_args('horn violin & piano'))
      @ptresp = solr_resp_doc_ids_only(title_search_args('"horn violin & piano"'))
    end
    it "should ignore the ampersand (same as AND if # terms is less than mm threshold)" do
      @tresp.should include("298114").in_first(11).results
      @tresp.should have_the_same_number_of_documents_as(solr_resp_doc_ids_only(title_search_args('horn violin piano')))
    end
    it "phrase query should ignore the ampersand" do
      @ptresp.should have_the_same_number_of_documents_as(solr_resp_doc_ids_only(title_search_args('"horn violin piano"')))
    end
  end # context  horn violin & piano

  context "4 term query 'crosby stills nash & young'" do
    before(:all) do
      @resp = solr_resp_doc_ids_only({'q'=>'crosby stills nash & young'})
      @presp = solr_resp_doc_ids_only({'q'=>'"crosby stills nash & young"'})
    end
    it "should ignore the ampersand (same as AND if # terms is less than mm threshold)" do
      @resp.should include("5627798").as_first
      @resp.should have_the_same_number_of_documents_as(solr_resp_doc_ids_only({'q'=>'crosby stills nash young'}))
    end
    it "phrase query should ignore the ampersand" do
      @presp.should include("5627798").as_first
      @presp.should have_the_same_number_of_documents_as(solr_resp_doc_ids_only({'q'=>'"crosby stills nash young"'}))
    end
    context "title search" do
      before(:all) do
        @tresp = solr_resp_doc_ids_only(title_search_args('crosby stills nash & young'))
        @ptresp = solr_resp_doc_ids_only(title_search_args('"crosby stills nash & young"'))
      end
      it "should ignore the ampersand (same as AND if # terms is less than mm threshold)" do
        @tresp.should include("5627798").as_first
        @tresp.should have_the_same_number_of_documents_as(solr_resp_doc_ids_only(title_search_args('crosby stills nash young')))
      end
      it "phrase query should ignore the ampersand" do
        @ptresp.should include("5627798").as_first
        @ptresp.should have_the_same_number_of_documents_as(solr_resp_doc_ids_only(title_search_args('"crosby stills nash young"')))
      end
    end    
  end # context  crosby stills nash & young

  context "4 term query 'steam boat & canal routesg'" do
    before(:all) do
      @resp = solr_resp_doc_ids_only({'q'=>'steam boat & canal routes'})
      @presp = solr_resp_doc_ids_only({'q'=>'"steam boat & canal routes"'})
    end
    it "should ignore the ampersand (same as AND if # terms is less than mm threshold)" do
      @resp.should include("5723944").as_first
      @resp.should have_the_same_number_of_documents_as(solr_resp_doc_ids_only({'q'=>'steam boat canal routes'}))
    end
    it "phrase query should ignore the ampersand" do
      @presp.should include("5723944").as_first
      @presp.should have_the_same_number_of_documents_as(solr_resp_doc_ids_only({'q'=>'"steam boat canal routes"'}))
    end
    context "title search" do
      before(:all) do
        @tresp = solr_resp_doc_ids_only(title_search_args('steam boat & canal routes'))
        @ptresp = solr_resp_doc_ids_only(title_search_args('"steam boat & canal routes"'))
      end
      it "should ignore the ampersand (same as AND if # terms is less than mm threshold)" do
        @tresp.should include("5723944").as_first
        @tresp.should have_the_same_number_of_documents_as(solr_resp_doc_ids_only(title_search_args('steam boat canal routes')))
      end
      it "phrase query should ignore the ampersand" do
        @ptresp.should include("5723944").as_first
        @ptresp.should have_the_same_number_of_documents_as(solr_resp_doc_ids_only(title_search_args('"steam boat canal routes"')))
      end
    end    
  end # context  steam boat & canal routes
  
  context "5 term query 'horns, violins, viola, cello & organ'" do
    before(:all) do
      @resp = solr_resp_doc_ids_only({'q'=>'horns, violins, viola, cello & organ'})
      @presp = solr_resp_doc_ids_only({'q'=>'"horns, violins, viola, cello & organ"'})
    end
    it "should ignore the ampersand (same as AND if # terms is less than mm threshold)" do
      @resp.should include("6438612").as_first
      @resp.should have_the_same_number_of_documents_as(solr_resp_doc_ids_only({'q'=>'horns, violins, viola, cello & organ'}))
    end
    it "phrase query should ignore the ampersand " do
      @presp.should include("6438612").as_first
      @presp.should have_the_same_number_of_documents_as(solr_resp_doc_ids_only({'q'=>'"horns, violins, viola, cello & organ"'}))
    end
    context "title search" do
      before(:all) do
        @tresp = solr_resp_doc_ids_only(title_search_args('horns, violins, viola, cello & organ'))
        @ptresp = solr_resp_doc_ids_only(title_search_args('"horns, violins, viola, cello & organ"'))
      end
      it "should ignore the ampersand (same as AND if # terms is less than mm threshold)" do
        @tresp.should include("6438612").as_first
        @tresp.should have_the_same_number_of_documents_as(solr_resp_doc_ids_only(title_search_args('horns, violins, viola, cello & organ')))
      end
      it "phrase query should ignore the ampersand " do
        @ptresp.should include("6438612").as_first
        @ptresp.should have_the_same_number_of_documents_as(solr_resp_doc_ids_only(title_search_args('"horns, violins, viola, cello & organ"')))
      end
    end    
  end # context  horns, violins, viola, cello & organ
  
  context "5 term query 'the truth about cats & dogs' (former stopword 'the')" do
    it_behaves_like "ampersand ignored", "the truth about cats & dogs", "5646609", 1
  end
  
  context "5 term query 'anatomy of the dog & cat' (former stopwords 'of', 'the')" do
    it_behaves_like "ampersand ignored", "anatomy of the dog & cat", "3324413", 1
  end 

  context "6 term query 'Dr. Seuss & Mr. Geisel : a biography' (former stopword 'a')" do
    it_behaves_like "ampersand ignored", "Dr. Seuss & Mr. Geisel : a biography", "2997769", 1
  end 

  context "6 term query 'Zen & the Art of Motorcycle Maintenance' (former stopwords 'of', 'the')" do
    it_behaves_like "ampersand ignored", "Zen & the Art of Motorcycle Maintenance", ["1464048", "524822"], 5
  end 

  context "6 term query 'horns, violins, viola, cello & organ continuo'" do
    it_behaves_like "ampersand ignored", "horns, violins, viola, cello & organ continuo", "6438612", 1
  end


=begin

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