# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Korean: Hangul and Hancha scripts", :korean => true, :fixme => true do
  
  it "hangul  광주 should get results for hancha  光州" do
    resp = solr_resp_doc_ids_only({'q'=>'광주'}) 
    resp.should include(["7763372", "7773313"]) # hancha  光州
    resp.should have_at_least(110).documents # 87 in prod (87 korean), 115 in soc (115 Korean)
  end
  
  it "hancha (simplified)  光州 for Korean language should include the hangul  광주 results" do
    resp = solr_resp_doc_ids_only({'q'=>'光州', 'fq'=>'language:Korean'}) 
    resp.should include(["8579366", "8536590"])  # hangul  광주
    resp.should have_at_least(45).documents # 22 in prod (21 korean), 701 in soc (50 Korean)
  end
  
  it "hancha (traditional)  廣州 for Korean language should include the hancha simplified  光州 results" do
    resp = solr_resp_doc_ids_only({'q'=>'廣州', 'fq'=>'language:Korean'}) 
    resp.should include(["7763372", "7773313"]) # hancha  光州
    resp.should have_at_least(9).documents # 1928 in prod (2 korean), 4739 in soc (9 Korean)
  end
  
  # Korean Home Bank:  한국주택은행  (hangul)  韓國住宅銀行  (hancha)
  # The growth of the Korean Economy: 
  #    한국 경제 의 발전  hangul
  #    韓國 經濟 의 發展    hancha 
  #   한국 =  韓國,   경제 =  經濟,  발전 =  發展
  
end