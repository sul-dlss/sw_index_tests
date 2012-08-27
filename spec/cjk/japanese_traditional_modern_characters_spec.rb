# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'rspec-solr'

describe "Japanese: Traditional and Modern Kanji (Han) Characters", :japanese => true, :fixme => true do

  it "(bukkyogaku) Traditional (Han) chars 佛教學 should get the same results as simplified/kanji chars 仏教学" do
    resp = solr_resp_doc_ids_only({'q'=>'bukkyogaku'}) # 49 in prod
    resp.should have_at_least(40).documents
    resp.should have_at_most(60).documents
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'佛教學'})) # 2 in prod, 279 in soc
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'仏教學'})) # 0 in prod, 46 in soc
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'佛教学'})) # 0 in prod, 279 in soc
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'佛教學'})) # 2 in prod, 279 in soc
  end
  
  it "(teikoku) Traditional chars 帝國 should get the same results as simplified/kanji chars 帝国" do
    resp = solr_resp_doc_ids_only({'q'=>'teikoku'}) # 1560 in prod, 1559 in soc
    resp.should have_at_least(1550).documents
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'帝國'})) # 10 in prod, 1593 in soc
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'帝国'})) # 58 in prod, 1593 in soc
    # these results have some in Korean and Chinese, too
    resp.should have_more_documents_than(solr_resp_doc_ids_only({'q'=>'帝國', 'fq'=>'language:Japanese'})) # 6 in prod, 1347 in soc
    # 'teikoku'  and lang Japanese   794 in prod, 1494 in soc
  end
  
  it "(The South Manchuria Railway Company) 南滿洲鐵道株式會社 should get the same results as 南満州鉄道株式会社" do
    #  滿 is traditional, 満 is the modern form; 鐵 is traditional, and 鉄 is the modern form)
    # (minami manshu tetsudo kabushiki kaisha) in latin?
    resp = solr_resp_doc_ids_only({'q'=>'南滿洲鐵道株式會社'}) # 513 in prod, 564 in soc
    resp.should have_at_least(881).documents
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'南満州鉄道株式会社'})) # 48 in prod, 52 in soc
  end
  
  it "modern char author name  けいちゅう should get the results with traditional author name  契沖" do
    resp = solr_resp_doc_ids_only({'q'=>'契沖', 'qt'=>'search_author'}) # 5 in prod, 5 in soc
    expected_results = ["6675613", "6675393", "7191966", "6274534", "4783602"]
    resp.should include(expected_results)
    resp2 = solr_resp_doc_ids_only({'q'=>'けいちゅう'}) # 0 in prod, 1 in soc
    resp2.should include(expected_results)  # has author name  契沖
  end
  
  context "Single character searches" do
        
    it "title  乱 (modern) should get same results as  亂 (trad)" do
      resp = solr_resp_doc_ids_only({'q'=>'乱', 'qt'=>'search_title', 'fq'=>'language:Japanese'}) 
      resp.should have_at_least(320).documents # 4 in prod, 323 in soc
      resp.should include("6260985") # famous movie by Akira Kurosawa
      resp.should include("4176905") # trad
      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'亂', 'qt'=>'search_title', 'fq'=>'language:Japanese'})) # 0 in prod, 323 in soc 
    end

    it "title Zen  禪 (trad) should get same results as  禅 (modern)" do
      resp = solr_resp_doc_ids_only({'q'=>'禪', 'qt'=>'search_title', 'fq'=>'language:Japanese'}) 
      resp.should have_at_least(425).documents # 1 in prod, 435 in soc
      resp.should include("6667691")  # trad
      resp.should include("4193363")  # modern
      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'禅', 'qt'=>'search_title', 'fq'=>'language:Japanese'})) # 5 in prod, 435 in soc 
    end
  end
  
end