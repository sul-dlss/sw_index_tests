# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'rspec-solr'

describe "Japanese: hiragana, katakana, kanji, and romaji scripts", :japanese => true do

  it "(manga) まんが should get the same results as マンガ" do
    resp = solr_resp_doc_ids_only({'q'=>'まんが'}) # 3 in prod, 111 in soc
    resp.should have_at_least(105).documents
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'マンガ'})) # 13 in prod, 140 in soc
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'漫画'})) # 22 in prod, 409 in soc
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'漫畫'})) # 6 in prod, 409 in soc
  end
  
  it "Keichu (person's name) in latin, in kanji  契沖 and in hiragana  けいちゅう should have same results" do
    resp = solr_resp_doc_ids_only({'q'=>'Keichu'}) # 22 in prod, 22 in soc
    resp.should have_at_least(20).documents
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'契沖'})) #  kanji  11 in prod, 21 in soc
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'けいちゅう'})) # hiragana 0 in prod, 1 in soc (7191360)
  end
  
end