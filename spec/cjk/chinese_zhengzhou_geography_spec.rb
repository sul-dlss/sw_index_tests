# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Chinese: 郑州 (zhengzhou - a place in China)  地理 (geography)", :chinese => true do

  shared_examples_for "great search results in title for 郑州地理" do
    # zhengzhou  trad  鄭州
    # zhengzhou  simp  郑州
    # geography (same for both)  地理
    it "should only retrieve the documents with both words in a title field" do
      expect(resp).to include("9612993").as_first.result  # both words in 245a, but separated;  record not in cjk batch
      expect(resp).to include("9926680").in_first(2) # zhengzhou (simp) in 245b, 246a, 650z (mult)    geography  245a
    end
    it "should not include document only matching zhengzhou" do
      expect(resp).not_to include("119747") # zhengzhou (trad) in 245a;  geography: NONE
    end
  end

  context "title search" do
    shared_examples_for "great title search results for 郑州地理" do
      it "should have an appropriate number of results" do
        expect(resp.size).to be <= 5
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
      it "should get a reasonable number of results" do
        expect(resp.size).to be >= 8
        expect(resp.size).to be <= 30
      end
      it "should rank highest the documents with both words in 245a" do
        expect(resp).to include("9612993").as_first.result  # both words in 245a, but separated;  record not in cjk batch
      end
      it "should rank very high the documents with both words in 245" do
        expect(resp).to include("9926680").in_first(2) # zhengzhou (simp) in 245b, 246a, 650z (mult); geography  245a
      end
      # there are a LOT more of these --> socrates finds 1953 of them.
      it "should rank high the documents with one word in 245a" do
        expect(resp).to include("4203541").in_first(10).results  # geography in 245a 490a, 830a;  郑州 (zhengzhou) in 260a
        #  geography in 245a; zhengzhou in 260a
        expect(resp).to include("5809974").in_first(10).results # zhengzhou 260a; geography 245a
        expect(resp).to include("11980491").in_first(20).results # zhengzhou 260a; geography 520a
        expect(resp).to include("10111516").in_first(15).results # zhengzhou (simp) 260a;  geography 245a
        expect(resp).to include("4197620").in_first(10).results # zhengzhou 260a, geography 245a
        expect(resp).to include("4808042").in_first(10).results # zhengzhou 260a, geography 245a
        expect(resp).to include("6704074").in_first(10).results # zhengzhou 260a, geography 245a
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
