# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'rspec-solr'

describe "Chinese: Word Breaks - Unigrams", :chinese => true, :fixme => true do
  # see chinese_old_fiction_spec  for  "舊小說 (old fiction) becomes  舊 (unigram) and  小說 (bigram)
  # see women_and_literature_spec for  "婦女與文學 becomes  婦女 (women)  與 (and)   文學 (literature)
  
  # TODO: 
  #   AND query
  #   OR query  (after Solr bug is fixed)
  #   positionfilter ...
  #   overlapping tokens ...   what if they didn't overlap and were ANDed
  
  context "Three kingdoms 三國誌 becomes  三國 (three - bigram) and  誌 (unigram)" do
    shared_examples_for "great results for Three kingdoms" do |resp, num_exp|
      it "should have the right number of results" do
        resp.should have_at_least(num_exp - 30).documents
        resp.should have_at_most(num_exp + 50).documents
      end
      context "should have the best results first" do
        it "San guo zhi by Chen Shou  (exact 245a)" do
          resp.should include(['6696113', # microform, EAL
                                '9265099', # v. 394  harvard-yenching coll, sal1&2
                                '5630782', # v1-5  EAL Chinese coll
                                '9424180', # v 487  harvard-yenching coll, sal1&2
                                '8656531', # ser2: v14  sal1&2
                                '8656623', # ser2:v106 sal1&2
                                '9407164', # ser2:v53 harvard-yenching coll, sal1&2
                                '6718129', # v254 east asia big sets sal1&2
                                '6435402', # 65 juan  v1-5  harvard-yenching coll, sal1&2
                                '6829978', # 65 juan  v1-4  EAL chinese coll
                                '10102192', # v96-97  sal1&2
                                '8656532',  # ser2 v15  sal1&2
                                '6435401'   # v1-16  harvard-yenching coll, sal1&2
                              ])
        end
        it "Samgukchi (Korean)  (exact 245a)" do
          resp.should include(['8303152', # Samgukchi / Na Kwan-jung chiŭm  author Luo, Guanzhong  (245a, first 3 chars of 240a, 700t)
                                '10156316', # Samgukchi by  Yi Mun-yŏl p'yŏngyŏk  (245a, part of 246a, 500a, 700t)
                              ])
        end
#        it "should match other highly boosted fields" do
#          #  8448620 - 三国志 240a,  start of 245a, 600t
#        end
      end # best results first
    end # shared_examples_for  great results for Three kingdoms 
    
    context "三國誌 (trad, no spaces) should have good search results" do
      # soc:  255 as of 2013-08-08
      it_behaves_like "great results for Three kingdoms", solr_resp_doc_ids_only({'q'=>'三國誌', 'rows'=>'25'}), 250
    end
    context "三國 誌 (trad, space) should have good search results" do
      # soc:  262 as of 2013-08-08
      it_behaves_like "great results for Three kingdoms", solr_resp_doc_ids_only({'q'=>'三國 誌', 'rows'=>'25'}), 250
    end
    context "三国志 (simp, no spaces) should have good search results" do
      # soc:  255 as of 2013-08-08
      it_behaves_like "great results for Three kingdoms", solr_resp_doc_ids_only({'q'=>'三国志', 'rows'=>'25'}), 250
    end
    context "三国 志 (simp, space) should have good search results" do
      # soc:  262 as of 2013-08-08
      it_behaves_like "great results for Three kingdoms", solr_resp_doc_ids_only({'q'=>'三国 志', 'rows'=>'25'}), 250
    end
    
    context "title search" do
      shared_examples_for "great results for Three kingdoms title searches" do |resp|
        it "Sangokushi (Japanese) (exact 245a, but simplified 三国志)" do
          resp.should include(['6627151', # Sangokushi / [Ra Kanchū sen]  (245a, first 3 chars of 240a, 500a)
# FIXME:  not sure why this isn't in results    三囯志   三國誌
#                                '9146942', # Sangokushi. by Yokoyama, Mitsuteru
                              ])
        end
      end

      context "三國誌 (trad, no spaces) should have good search results" do
        # soc:  170 as of 2013-08-08
        it_behaves_like "great results for Three kingdoms", solr_resp_doc_ids_only(title_search_args '三國誌'), 170
        it_behaves_like "great results for Three kingdoms title searches", solr_resp_doc_ids_only(title_search_args '三國誌')
      end
      context "三國 誌 (trad, space) should have good search results" do
        # soc:  170 as of 2013-08-08
        it_behaves_like "great results for Three kingdoms", solr_resp_doc_ids_only(title_search_args('三國 誌').merge({'rows'=>'25'})), 170
        it_behaves_like "great results for Three kingdoms title searches", solr_resp_doc_ids_only(title_search_args '三國 誌')
      end
      context "三国志 (simp, no spaces) should have good search results" do
        # soc:  170 as of 2013-08-08
        it_behaves_like "great results for Three kingdoms", solr_resp_doc_ids_only(title_search_args '三国志'), 170
        it_behaves_like "great results for Three kingdoms title searches", solr_resp_doc_ids_only(title_search_args '三国志')
      end
      context "三国 志 (simp, space) should have good search results" do
        # soc:  170 as of 2013-08-08
        it_behaves_like "great results for Three kingdoms", solr_resp_doc_ids_only(title_search_args('三国 誌').merge({'rows'=>'25'})), 170
        it_behaves_like "great results for Three kingdoms title searches", solr_resp_doc_ids_only(title_search_args '三国 誌')
      end
    end # title search
  end #  Three kingdoms
  
  context "飘  float/drifting (Gone with the wind)" do
    shared_examples_for "great results for float (Gone with the Wind)" do |query|
      before(:all) do
        @resp = solr_resp_doc_ids_only(title_search_args query)
      end
      it "should have the right number of results" do
        @resp.should have_at_least(120).documents  # soc:  120 as of 2013-08-08
        @resp.should have_at_most(150).documents
      end
      context "should have the best results first" do
        it "Gone with the Wind (book)" do
          @resp.should include('6701323').as_first
        end
        it "Drifting (video)" do
          @resp.should include('7737681').in_first(3)
        end
      end
    end
    
    context "traditional:  飄" do
      it_behaves_like "great results for float (Gone with the Wind)", '飄'
    end
    context "simplified:  飘" do
      it_behaves_like "great results for float (Gone with the Wind)", '飘'
    end
  end # float/drifting 
  
end