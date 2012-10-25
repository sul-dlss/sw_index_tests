# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'rspec-solr'

describe "Japanese: hiragana, katakana, kanji, and romaji scripts", :japanese => true, :fixme => true do

  context "manga" do
    before(:all) do
      @resp_hirigana = solr_resp_doc_ids_only({'q'=>'まんが'}) # 3 in prod, 111 in soc
      @resp_katakana = solr_resp_doc_ids_only({'q'=>'マンガ'}) # 13 in prod, 140 in soc
      @resp_kanji_m = solr_resp_doc_ids_only({'q'=>'漫画'}) # 22 in prod, 409 in soc
      @resp_kanji_t = solr_resp_doc_ids_only({'q'=>'漫畫'}) # 6 in prod, 409 in soc
      @resp_romanji = solr_resp_doc_ids_only({'q'=>'manga'})
      @min_num_results = 105
      @max_num_results = 450
      @exp_ckeys = ["111", "222"]
      @threshhold = 5
    end
    # NOTE:  traditional and modern kanji examined in diff spec
    it "hiragana and katakana results should match" do
      @resp_hirigana.should have_the_same_number_of_results_as(@resp_katakana)
    end
    context "hiragana" do
      it "should get excellent results" do
        @resp_hirigana.should have_at_least(@min_num_results).documents
        @resp_hirigana.should have_at_most(@max_num_results).documents
        @resp_hirigana.should include(@exp_ckeys).in_first(@threshhold).documents
      end
      it "hiragana should get fewer than kanji" do
        @resp_hirigana.should have_fewer_results_than(@resp_kanji_m)
        @resp_hirigana.should have_fewer_results_than(@resp_kanji_t)
      end
      it "hiragana should get fewer than romanji" do
        @resp_hirigana.should have_fewer_results_than(@resp_romanji)
      end
    end
    context "katakana" do
      it "should get excellent results" do
        @resp_katakana.should have_at_least(@min_num_results).documents
        @resp_katakana.should have_at_most(@max_num_results).documents
        @resp_katakana.should include(@exp_ckeys).in_first(@threshhold).documents
      end
      it "katakana should get fewer than kanji" do
        @resp_katakana.should have_fewer_results_than(@resp_kanji_m)
        @resp_katakana.should have_fewer_results_than(@resp_kanji_t)
      end
      it "katakana should get fewer than romanji" do
        @resp_katakana.should have_fewer_results_than(@resp_romanji)
      end
    end
  end # end manga

  
  it "Keichu (person's name) in latin, in kanji  契沖 and in hiragana  けいちゅう should have same results" do
    resp = solr_resp_doc_ids_only({'q'=>'Keichu'}) # 22 in prod, 22 in soc
    resp.should have_at_least(20).documents
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'契沖'})) #  kanji  11 in prod, 21 in soc
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'けいちゅう'})) # hiragana 0 in prod, 1 in soc (7191360)
  end
  
  context "author  けいちゅう (hiragana) to 契沖 (kanji)  " do

    it " けいちゅう (hiragana) should get the same results as modern kanji author name  契沖" do
      expected_results = ["6675613", "6675393", "7191966", "6274534", "4783602"]
      resp = solr_resp_doc_ids_only(author_search_args('契沖')) # 5 in prod, 5 in soc
      resp.should include(expected_results)
      resp2 = solr_resp_doc_ids_only({'q'=>'けいちゅう'}) # 0 in prod, 1 in soc
      resp2.should include(expected_results)  # has author name  契沖
    end
    
  end
  
  
  context "mixed scripts" do
    context "kanji and hiragana" do
      context "近世仮名遣い論の研究 -- chars 6, 8:  い  の  are hiragana   _Kinsei kanazukairon no kenkyu_ by Kuginuki Toru" do
        it "does something" do
          resp = solr_resp_doc_ids_only(title_search_args('q'=>'近世仮名遣い論の研究'))
          resp.should include("7926218").as_first_result
          # should we get 6279261
          # cjk6ja   as title search,  38,900 results, but first one is excellent 7926218
          # cjk8  as title search,  100,512 results, but first one is excellent
          # cjk6cn (dict W pos filter) -  100,512 results, but first one is excellent
        end
      end
    end
  end
    
end