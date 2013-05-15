require 'spec_helper'

describe "sorting results" do

  context "empty query" do
    it "default sort should be by pub date desc (not in Solr default of document id order)" do
      resp = solr_response({'fl'=>'id,pub_date', 'facet'=>false})
      resp.should_not include('1') # should not be in document id order
      year = Time.new.year
      # TODO:  waiting for gdor fix to Walters pub_date_sort values
  #    resp.should include("pub_date" => /(#{year}|#{year + 1}|#{year + 2})/).in_each_of_first(20).documents
    end

    it "with facet format:Book; default sort should be by pub date desc then title asc" do
      resp = solr_response({'fq'=>'format:Book', 'fl'=>'id,pub_date', 'facet'=>false})
      year = Time.new.year
      resp.should include("pub_date" => /(#{year}|#{year + 1}|#{year + 2})/).in_each_of_first(20).documents
      # _Applications of Microsoft Excel in analytical chemistry_  before  _Chemistry : a molecular approach_
      resp.should include('9937771').before('9937759')
    end
    
    it "with facet access:Online; default sort should be by pub date desc then title asc" do
      resp = solr_response({'fq'=>'access_facet:Online', 'fl'=>'id,pub_date', 'facet'=>false})
      resp.should_not include('7342') # Solidarité, 1902
    end    
  end # empty query
  
  context "pub dates should not be 0000 or 9999" do
    it "should not have earliest pub date of 0000" do
      resp = solr_response({'fq'=>'format:Book', 'fl'=>'id,pub_date', 'sort'=>'pub_date asc', 'facet'=>false})
      resp.should_not include('pub_date' => /0000/)
    end
    it "should not have latest pub date of 9999" do
      resp = solr_response({'fq'=>'format:Book', 'fl'=>'id,pub_date', 'sort'=>'pub_date desc', 'facet'=>false})
      resp.should_not include('pub_date' => /9999/)
    end
  end

=begin
  Scenario: Spaces should be significant
  Scenario: Case / Capitalization should have no effect on sorting
  Scenario: Punctuation should not affect sorting
  Scenario: Subscripts should be sorted properly
  # super scripts;  what about $, %, etc.

  Scenario: Letters with and without diacritics should be interfiled
    # TODO:  diacritics in first character;  subsequent characters  
  Scenario: Polish L should sort properly
  Scenario: Znaks, hard and soft, should be ignored for sorting
    # More information needed about znaks: is this a character?  a diacritic?  Should any occurrence be ignored?

  Scenario: Æ and AE should be interfiled
    And I go to the home page
    When I fill in "q" with "Æon"
    And I press "search"
    And I select "title" from "sort"
    And I press "sort_submit"
    Then I should get ckey 6628532 before ckey 4647437
    Then I should get ckey 6197318 before ckey 4647437

  Scenario: Chinese - traditional and simplified characters should be sorted together
  Scenario: Japanese - old and new characters should sort together?
  Scenario: Korean - something about spaces vs. no space (?)
  Scenario: Hebrew alif and ayn should be ignored for sorting
    # TODO:  as first character only, or as any character?
    # TODO:  transliteration vs. hebrew script ... 


  Scenario: Combination of non-filing characters and diacritics in first character should sort properly.
     # Etude,   another example from vitus in email week of 4/27

  Scenario: Non-filing indicators should be ignored for sorting.
   # TODO: maybe someday autodetect non-filing chars that aren't accommodated in the marc record

=end

end