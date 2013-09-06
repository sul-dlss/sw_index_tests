# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Korean: Word Breaks", :korean => true, :fixme => true, :wordbreak => true do
  
  it "한국경제 (no spaces) should retrieve all the records for  한국  경제 (with spaces)" do
    resp = solr_resp_doc_ids_only({'q'=>'한국경제'}) # 2 in prod, 350 in soc
    resp.should include(["7912628", "7518183", "7520112", "8802478"]) #  한국  경제
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'한국  경제'})) # 407 in prod, 495 in soc
  end
  
  it "한국  경제 should should retrieve all the records for  한국경제 (no space)" do
    resp = solr_resp_doc_ids_only({'q'=>'한국  경제'}) # 407 in prod, 495 in soc
    resp.should include(["6812133", "9084768"]) # 한국경제
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'한국경제'})) # 407 in prod, 495 in soc
  end
  
  context "search for record 9323348 with title  한국 경제 의 미래 와 생존 전략 " do
    # should all different versions of the char spaces return exactly the same result???
    
    it "한국 경제 의 미래 와 생존 전략 should find itself (6 spaces)" do
      resp = solr_resp_doc_ids_only({'q'=>'한국 경제 의 미래 와 생존 전략'}) 
      resp.should include(["9323348"]).in_first(1).result
    end
    
    it "한국경제의미래와생존전략 (no spaces) should get results" do
      resp = solr_resp_doc_ids_only({'q'=>'한국경제의미래와생존전략'}) # 0 in prod, 0 in soc
      resp.should include(["9323348"]).in_first(1).result
      # gets 5 in cjk1;  unclear if last 4 are relevant
    end
    
    it "한국경제의  미래와  생존전략 (2 spaces) should get results" do
      resp = solr_resp_doc_ids_only({'q'=>'한국경제의  미래와  생존전략'}) # 0 in prod, 0 in soc
      resp.should include(["9323348"]).in_first(1).result
      resp.should have_at_most(solr_resp_doc_ids_only({'q'=>' 미래와  생존전략'}).size).results # 0 in prod, 1 in soc
      resp.should have_at_most(solr_resp_doc_ids_only({'q'=>'한국경제의  미래와'}).size).results 
      resp.should have_at_most(solr_resp_doc_ids_only({'q'=>'한국경제의  생존전략'}).size).results 
    end

    it " 한국  경제의  미래와  생존  전략 (4 spaces) should get results" do
      resp = solr_resp_doc_ids_only({'q'=>'한국  경제의  미래와  생존  전략'}) # 0 in prod, 0 in soc
      resp.should include(["9323348"]).in_first(1).result
      resp.should have_at_most(solr_resp_doc_ids_only({'q'=>'한국  경제의'}).size).results # 0 in prod, 1 in soc
      resp.should have_at_most(solr_resp_doc_ids_only({'q'=>'한국  경제의  미래와'}).size).results 
      resp.should have_at_most(solr_resp_doc_ids_only({'q'=>'한국  경제의  미래와  생존'}).size).results 
      resp.should have_at_most(solr_resp_doc_ids_only({'q'=>' 경제의  미래와'}).size).results 
      resp.should have_at_most(solr_resp_doc_ids_only({'q'=>' 경제의  미래와  생존'}).size).results 
      resp.should have_at_most(solr_resp_doc_ids_only({'q'=>' 경제의  미래와  생존  전략'}).size).results 
      resp.should have_at_most(solr_resp_doc_ids_only({'q'=>'미래와  생존'}).size).results 
      resp.should have_at_most(solr_resp_doc_ids_only({'q'=>' 미래와  생존  전략'}).size).results 
      resp.should have_at_most(solr_resp_doc_ids_only({'q'=>'생존  전략'}).size).results 
    end
  end  
  
  # TODO:  phrase vs. non-phrase searching.
  
  
  # 7682995  contributor - name of bank - 3 terms - in han script   
  #  cjk1 - with spaces 1 result
  #  cjk1 - without spaces  3,157, most irrelevant
  
end