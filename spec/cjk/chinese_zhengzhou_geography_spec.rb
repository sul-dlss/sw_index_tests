# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Chinese: 郑州 (zhengzhou - a place in China)  地理 (geography)", :chinese => true, :vetted => 'vitus' do

  shared_examples_for "great search results in title for 郑州地理" do
    # zhengzhou  trad  鄭州
    # zhengzhou  simp  郑州
    # geography (same for both)  地理
    it "should only retrieve the documents with both words in a title field" do
      resp.should include("9612993").as_first.result  # both words in 245a, but separated;  record not in cjk batch
      resp.should include("9926680").in_first(2) # zhengzhou (simp) in 245b, 246a, 650z (mult)    geography  245a
    end
    it "should not include document only matching zhengzhou" do
      resp.should_not include("119747") # zhengzhou (trad) in 245a;  geography: NONE
    end
  end

  context "title search" do
    shared_examples_for "great title search results for 郑州地理" do
      it "should have an appropriate number of results" do
        resp.should have_at_most(2).documents
      end
    end
    
    context "trad  鄭州地理 (no space)" do
      before(:all) do
        @resp = solr_resp_doc_ids_only(title_search_args('鄭州地理'))
      end
      it_behaves_like "great search results in title for 郑州地理" do
        let (:resp) { @resp }
      end
      it_behaves_like "great title search results for 郑州地理" do
        let (:resp) { @resp }
      end
    end
    context "trad  鄭州 地理 (space)" do
      before(:all) do
        @resp = solr_resp_doc_ids_only(title_search_args('鄭州 地理'))
      end
      it_behaves_like "great search results in title for 郑州地理" do
        let (:resp) { @resp }
      end
      it_behaves_like "great title search results for 郑州地理" do
        let (:resp) { @resp }
      end
    end
    context "simplified  郑州地理 (no space)" do
      before(:all) do
        @resp = solr_resp_doc_ids_only(title_search_args('郑州地理'))
      end
      it_behaves_like "great search results in title for 郑州地理" do
        let (:resp) { @resp }
      end
      it_behaves_like "great title search results for 郑州地理" do
        let (:resp) { @resp }
      end
    end
    context "simplified  郑州 地理 (space)" do
      before(:all) do
        @resp = solr_resp_doc_ids_only(title_search_args('郑州 地理'))
      end
      it_behaves_like "great search results in title for 郑州地理" do
        let (:resp) { @resp }
      end
      it_behaves_like "great title search results for 郑州地理" do
        let (:resp) { @resp }
      end
    end
  end # context title_search

  context "everything search" do
    shared_examples_for "great search results for 郑州地理" do
      # soc:  鄭州 地理 (trad) 8 results
      # soc:  郑州 地理  (simpl) 8 results
      # 518541  geography in 260b, 710b;   can't find zhengzhou
      # 119747:  zhengzhou trad  鄭州  in 245a;  can't find geography
      it "should get a reasonable number of results", :fixme => true do
        resp.should have_at_least(8).documents 
        resp.should have_at_most(20).documents
      end
      it "should rank highest the documents with both words in 245a" do
        resp.should include("9612993").as_first.result  # both words in 245a, but separated;  record not in cjk batch
      end
      it "should rank very high the documents with both words in 245" do
        resp.should include("9926680").in_first(2) # zhengzhou (simp) in 245b, 246a, 650z (mult); geography  245a
      end
      # there are a LOT more of these --> socrates finds 1953 of them.
      it "should rank high the documents with one word in 245a", :fixme => true do
        resp.should include("4203541").in_first(3).results  # geography in 245a 490a, 830a;  郑州 (zhengzhou) in 260a
        #  geography in 245a; zhengzhou in 260a
        resp.should include("5809974").in_first(8).results # zhengzhou 260a; geography 245a
        resp.should include("10111516").in_first(8).results # zhengzhou (simp) 260a;  geography 245a
        resp.should include("4197620").in_first(8).results # zhengzhou 260a, geography 245a
        resp.should include("4808042").in_first(8).results # zhengzhou 260a, geography 245a
        resp.should include("6704074").in_first(8).results # zhengzhou 260a, geography 245a
      end
      it "should rank less high the documents with both words present but not in 245", :fixme => true do
        resp.should include("7833848") # zhengzhou 260a, geography 490a
        resp.should include("5456407") # zhengzhou in 260a,  geography in 260b, 710b
      end
    end

    context "trad  鄭州地理 (no space)" do
      before(:all) do
        @resp = solr_resp_doc_ids_only({'q'=>'鄭州地理'})
      end
      it_behaves_like "great search results in title for 郑州地理" do
        let (:resp) { @resp }
      end
      it_behaves_like "great search results for 郑州地理" do
        let (:resp) { @resp }
      end
    end
    context "trad  鄭州 地理 (space)" do
      before(:all) do
        @resp = solr_resp_doc_ids_only({'q'=>'鄭州 地理'})
      end
      it_behaves_like "great search results in title for 郑州地理" do
        let (:resp) { @resp }
      end
      it_behaves_like "great search results for 郑州地理" do
        let (:resp) { @resp }
      end
    end
    context "simplified  郑州地理 (no space)" do
      # soc:  2 as of 2012-11
      before(:all) do
        @resp = solr_resp_doc_ids_only({'q'=>'郑州地理'})
      end
      it_behaves_like "great search results in title for 郑州地理" do
        let (:resp) { @resp }
      end
      it_behaves_like "great search results for 郑州地理" do
        let (:resp) { @resp }
      end
    end
    context "simplified  郑州 地理 (space)" do
      # soc:  8 as of 2012-11
      before(:all) do
        @resp = solr_resp_doc_ids_only({'q'=>'郑州 地理'})
      end
      it_behaves_like "great search results in title for 郑州地理" do
        let (:resp) { @resp }
      end
      it_behaves_like "great search results for 郑州地理" do
        let (:resp) { @resp }
      end
    end   
  end # context everything search

end