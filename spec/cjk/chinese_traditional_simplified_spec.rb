# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Chinese: Traditional and Simplified Scripts", :chinese => true, :fixme => true do

  it "Traditional chars 三國誌 (three kingdoms) should get the same results as simplified chars 三国志" do
    resp = solr_resp_doc_ids_only({'q'=>'三國誌'})  # 0 in prod, 242 in soc
    resp.should have_at_least(240).documents
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'三国志'})) # 23 in prod, 242 in soc
  end
  
  it "Traditional chars 紅樓夢 (dream of red chamber) should get the same results as simplified chars 红楼梦" do
    resp = solr_resp_doc_ids_only({'q'=>'紅樓夢'})  # 247 in prod, 649 in soc
    resp.should have_at_least(640).documents
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'红楼梦'})) # 306 in prod, 649 in soc
  end
  
  it "Traditional chars  廣州 (Zhengzhou) should get the same results as simplified chars  光州" do
    resp = solr_resp_doc_ids_only({'q'=>'廣州'}) 
    resp.should have_at_least(4725).documents # 1928 in prod, 4739 in soc
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'光州'})) # 22 in prod, 701 in soc
  end
  
  it "Mixed traditional and simplified characters in same search string" do 
    # more details: email on gryph-search week of 8/13 w subject chinese search test - question 1 
    resp = solr_resp_doc_ids_only({'q'=>'全宋筆记'})  # 1 in prod: 5701106;  全宋筆記 4 in prod, 12 in soc
    resp.should have_at_least(12).documents
    resp.should include("5701106") # orig query string   全宋筆记
    resp.should include(["9579321", "9579315", "6734714", "8146870"]) # diff string  全宋筆記
    resp2 = solr_resp_doc_ids_only({'q'=>'全宋筆記'})  # diff string;  4 in prod, 9 in soc
    resp2.should include(["9579321", "9579315", "6734714", "8146870"]) # diff string  全宋筆記
    resp2.should include("5701106") # orig query string   全宋筆记
    resp3 = solr_resp_doc_ids_only({'q'=>'全  宋  筆記'}) # these 3 terms are how it should parse  (3rd char is trad)
    resp.should have_the_same_number_of_results_as(resp3)
    resp4 = solr_resp_doc_ids_only({'q'=>'全  宋  笔記'}) # these 3 terms are how it should parse   (3rd char is simplified)
    resp.should have_the_same_number_of_results_as(resp4)
    resp3.should have_the_same_number_of_results_as(resp4)
  end
  
  context "Author search" do
    it "Simplified chars 张爱玲 (Zhang, Ailing) should get the same results as traditional chars 張愛玲" do
      resp = solr_resp_doc_ids_only(author_search_args('紅樓夢')) # 0 in prod, 17 in soc
      resp.should have_at_least(70).documents
      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(author_search_args('红楼梦'))) # 5 in prod, 17 in soc
    end
  end
  
  context "Title search" do
    it "Simplified  中国地方志集成 vs. Traditional 中國地方誌集成" do
      resp = solr_resp_doc_ids_only(title_search_args('中国地方志集成')) # 9 in prod, 523 in soc
      resp.should have_at_least(520).documents
      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(title_search_args('中國地方誌集成'))) # 0 in prod, 523 in soc
    end
  end
  
  context "Single character searches" do
    it "title Float / Gone with the wind  飄 (trad) should get the same results as  飘 (simplified)" do
      resp = solr_resp_doc_ids_only(title_search_args('飄')) 
      resp.should have_at_least(110).documents # 2 in prod, 117 title in soc, 115 lang chinese in soc, 154 everything in soc
      resp.should include("6701323") # trad
      resp.should include("4181771") # simp
      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(title_search_args('飘'))) # 0 title in prod, 115 title in soc 
    end
    
    it "title Zen  禪 (trad) should get the same results as  禅 (simplified)" do
      resp = solr_resp_doc_ids_only(title_search_args('禪').merge({'fq'=>'language:Chinese'}))
      resp.should have_at_least(485).documents # 0 in prod, 487 in soc
      resp.should include("6815304") # trad
      resp.should include("6428618") # simp
      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(title_search_args('禅').merge({'fq'=>'language:Chinese'}))) # 2 in prod, 487 in soc 
    end
  end

end
