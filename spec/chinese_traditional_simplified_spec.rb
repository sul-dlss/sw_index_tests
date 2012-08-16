# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'rspec-solr'

describe "Chinese: Traditional and Simplified Scripts", :chinese => true, :fixme => true do

  it "Traditional chars 三國誌 should get the same results as simplified chars 三国志" do
    resp = solr_resp_doc_ids_only({'q'=>'三國誌'})  # 0 in prod, 242 in soc
    resp.should have_at_least(240).documents
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'三国志'})) # 23 in prod, 242 in soc
  end
  
  it "Traditional chars 紅樓夢 should get the same results as simplified chars 红楼梦" do
    resp = solr_resp_doc_ids_only({'q'=>'紅樓夢'})  # 247 in prod, 649 in soc
    resp.should have_at_least(640).documents
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'红楼梦'})) # 306 in prod, 649 in soc
  end
  
  it "Mixed traditional and simplified characters in same search string" do
    resp = solr_resp_doc_ids_only({'q'=>'全宋筆记'})  # 1 in prod: 5701106;  全宋筆記 4 in prod, 12 in soc
    resp.should have_at_least(12).documents
    resp.should include("5701106") # orig query string   全宋筆记
    resp.should include(["9579321", "9579315", "6734714"]) # diff string  全宋筆記
    resp2 = solr_resp_doc_ids_only({'q'=>'全宋筆記'})  # diff string;  4 in prod, 9 in soc
    resp2.should include(["9579321", "9579315", "6734714"]) # diff string  全宋筆記
    resp2.should include("5701106") # orig query string   全宋筆记
    
# query  全宋筆记
#        全宋筆记    A
#        全宋筆記    B
    
# search:   全宋筆记:    A   
# 1  ["9622614", 
# 2 "9579321 --  全宋筆記",  B 
# 3 "9579315 -- 全宋筆記",  B
# 4 "9541298 --"
# 5 "9269083 --"
# 6 "8519220"
# 7 "8146870" -- 全宋筆記  B
# 8 "6734714" -- 全宋筆記  B
# 9 "5701106"  全宋筆记  A
# 10 "9424729"
# 11 "6343926"
# 12 "6295610"
#    ]

# search:     全宋筆記   B
# 1 "9579321"   全宋筆記 B
# 2 "9579315"  B
# 3 "9541298"  
# 4 "8519220"
# 5 "8146870"
# 6 "6734714"  B
# 7 "9424729"
# 8 "6343926"
# 9 "6295610"
  end
  
  context "Author search" do
    it "Simplified chars 张爱玲 should get the same results as traditional chars 張愛玲" do
      resp = solr_resp_doc_ids_only({'q'=>'紅樓夢', 'qt'=>'search_author'}) # 0 in prod, 17 in soc
      resp.should have_at_least(70).documents
      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'红楼梦', 'qt'=>'search_author'})) # 5 in prod, 17 in soc
    end
  end
  
  context "Title search" do
    it "Simplified  中国地方志集成 vs. Traditional 中 國地方誌集成" do
      resp = solr_resp_doc_ids_only({'q'=>'中国地方志集成', 'qt'=>'search_title'}) # 9 in prod, 523 in soc
      resp.should have_at_least(520).documents
      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'中 國地方誌集成', 'qt'=>'search_title'})) # 0 in prod, 523 in soc
    end
  end

end
