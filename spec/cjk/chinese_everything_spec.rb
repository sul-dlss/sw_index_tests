# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Chinese Everything", :chinese => true do

  context "china economic policy", :jira => 'SW-100' do
    it_behaves_like "both scripts get expected result size", 'everything', 'traditional', '中國經濟政策', 'simplified', '中国经济政策', 250, 300
    it_behaves_like "matches in vern short titles first", 'everything', '中國經濟政策', /^中國經濟政策$/, 1
    it_behaves_like "matches in vern short titles first", 'everything', '中國經濟政策', /(中國經濟政策|中国经济政策)/, 6
    context "with spaces" do
      it_behaves_like "both scripts get expected result size", 'everything', 'traditional', '中國 經濟 政策', 'simplified', '中国 经济 政策', 200, 250
      it_behaves_like "matches in vern short titles first", 'everything', '中國 經濟 政策', /^中國經濟政策$/, 1
      it_behaves_like "matches in vern short titles first", 'everything', '中國 經濟 政策', /(中國經濟政策|中国经济政策)/, 6
    end
  end

  context "Chu Anping", :jira => 'VUF-2689' do
    # see also chinese_han_variants spec, as there are two traditional forms of the second character
    it_behaves_like "good results for query", 'everything', '储安平', 22, 30, ['6710188', '6342768', '6638798'], 25, 'rows' => 25
  end

  context "history research", :jira => 'VUF-2771' do
    context "no spaces" do
      it_behaves_like "both scripts get expected result size", 'everything', 'traditional', '歷史研究', 'simplified', '历史研究', 2700, 2800
    end
    context "with space" do
      it_behaves_like "both scripts get expected result size", 'everything', 'traditional', '歷史研究', 'simplified', '历史研究', 2700, 2800
    end
    context "as phrase" do
      it_behaves_like "both scripts get expected result size", 'everything', 'traditional', '"歷史研究"', 'simplified', '"历史研究"', 400, 425
    end
  end

  context "Nanyang or Nanʼyō", :jira => 'SW-100' do
    it_behaves_like "result size and vern short title matches first", 'everything', '南洋', 750, 825, /南洋/, 100
    it_behaves_like "matches in vern titles", 'everything', '南洋', /南洋群島/, 20
    # Nan'yō Guntō
    it_behaves_like "result size and vern short title matches first", 'everything', '南洋群島', 50, 60, /南洋群島/, 15
    it_behaves_like "good results for query", 'everything', '椰風蕉雨話南洋', 1, 1, '5564542', 1
  end
  
  context "old fiction" do
    # old (simp)  旧   (trad)  舊
    # fiction (simp)  小说   (trad)  小說
    shared_examples_for "great everything search results for old fiction (Han)" do
      it_behaves_like "great search results for old fiction (Han)"
      it "other relevant results" do
        other = ["6288832", # old 505t; fiction 505t x2
                  "7699186", # old (simp) in 245a, fiction (simp) in 490 and 830
                  "6204747", # old 245a; fiction 490a; 830a
                  "6698466", # old 245a; fiction 490a, 830a
                ]
        expect(resp).to include(other)
      end
    end # shared examples  great search results for old fiction (Han)
    context "no spaces" do
      it_behaves_like "both scripts get expected result size", 'everything', 'traditional', '舊小說', 'simplified', '旧小说', 30, 70
      trad_resp = cjk_query_resp_ids('everything', '舊小說', {'rows'=>35})
      simp_resp = cjk_query_resp_ids('everything', '旧小说', {'rows'=>35})
      it_behaves_like "great everything search results for old fiction (Han)" do
        let (:resp) { trad_resp }
      end
      it_behaves_like "great everything search results for old fiction (Han)" do
        let (:resp) { simp_resp }
      end
    end
    context "with space" do
      it_behaves_like "both scripts get expected result size", 'everything', 'traditional', '舊 小說', 'simplified', '旧 小说', 30, 70
      trad_resp = cjk_query_resp_ids('title', '舊 小說')
      simp_resp = cjk_query_resp_ids('title', '旧 小说')
      it_behaves_like "great everything search results for old fiction (Han)" do
        let (:resp) { trad_resp }
      end
      it_behaves_like "great everything search results for old fiction (Han)" do
        let (:resp) { simp_resp }
      end
    end
  end

  context "women marriage", :jira => 'SW-100' do
    it_behaves_like "both scripts get expected result size", 'everything', 'traditional', '婦女婚姻', 'simplified', '妇女婚姻', 25, 40
    it_behaves_like "both scripts get expected result size", 'everything', 'traditional', '婦女 婚姻', 'simplified', '妇女 婚姻', 25, 40
  end

end