# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'rspec-solr'

describe "Japanese: Traditional and Modern Kanji (Han) Characters", :japanese => true, :fixme => true do

  it "(bukkyogaku) Traditional (Han) chars 佛教學 should get the same results as simplified/kanji chars 仏教学" do
    # char 1:  佛 (traditional)  仏 (modern)
    # char 3:  學 (traditional)  学 (modern)
    resp = solr_resp_doc_ids_only({'q'=>'bukkyogaku'}) # 49 in prod
    resp.should have_at_least(40).documents
    resp.should have_at_most(60).documents
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'佛教學'})) # 2 in prod, 279 in soc
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'仏教學'})) # 0 in prod, 46 in soc
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'佛教学'})) # 0 in prod, 279 in soc
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'佛教學'})) # 2 in prod, 279 in soc
  end
  
  it "(teikoku)  帝國 (trad) should get the same results as 帝国 (modern)" do
    # TODO:  factor out romanji from here
    resp = solr_resp_doc_ids_only({'q'=>'teikoku'}) # 1560 in prod, 1559 in soc
    resp.should have_at_least(1550).documents
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'帝國'})) # 10 in prod, 1593 in soc
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'帝国'})) # 58 in prod, 1593 in soc
    # these results have some in Korean and Chinese, too
    resp.should have_more_documents_than(solr_resp_doc_ids_only({'q'=>'帝國', 'fq'=>'language:Japanese'})) # 6 in prod, 1347 in soc
    # 'teikoku'  and lang Japanese   794 in prod, 1494 in soc
  end
  
  it "manga  漫画 (modern char 2) should get the same results as  漫畫 (traditional char 2)" do
    resp_kanji_m = solr_resp_doc_ids_only({'q'=>'漫画'}) # 22 in prod, 409 in soc
    resp_kanji_m.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'漫畫'}))
    resp_kanji_m.should have_at_least(400).documents
    # TODO:  ckeys expected?  
  end
  
  context "Single character searches" do
        
    it "title  乱 (modern) should get same results as  亂 (trad)" do
      resp = solr_resp_doc_ids_only(title_search_args('乱').merge({'fq'=>'language:Japanese'}))
      resp.should have_at_least(320).documents # 4 in prod, 323 in soc
      resp.should include("6260985") # famous movie by Akira Kurosawa
      resp.should include("4176905") # trad
      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(title_search_args('亂').merge({'fq'=>'language:Japanese'}))) # 0 in prod, 323 in soc 
    end

    it "title Zen  禪 (trad) should get same results as  禅 (modern)" do
      resp = solr_resp_doc_ids_only(title_search_args('禪').merge({'fq'=>'language:Japanese'})) 
      resp.should have_at_least(425).documents # 1 in prod, 435 in soc
      resp.should include("6667691")  # trad
      resp.should include("4193363")  # modern
      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(title_search_args('禅').merge({'fq'=>'language:Japanese'}))) # 5 in prod, 435 in soc 
    end
  end
  
end