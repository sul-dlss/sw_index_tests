# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Chinese Title", :chinese => true do
  
  context "china economic policy", :jira => 'SW-100' do
    context "no spaces" do
      it_behaves_like "both scripts get expected result size", 'title', 'traditional', '中國經濟政策', 'simplified', '中国经济政策', 55, 75
      it_behaves_like "matches in vern short titles first", 'title', '中國經濟政策', /^中國經濟政策$/, 1
      it_behaves_like "matches in vern short titles first", 'title', '中國經濟政策', /(中國經濟政策|中国经济政策)/, 6
    end
    context "with spaces" do
      # TODO:  would like to have better precision here -- too many results now
      it_behaves_like "both scripts get expected result size", 'title', 'traditional', '中國 經濟 政策', 'simplified', '中国 经济 政策', 55, 90
      it_behaves_like "matches in vern titles", 'title', '中國 經濟 政策', /^中國經濟政策 \/.*$/, 2
      it_behaves_like "matches in vern short titles first", 'title', '中國 經濟 政策', /(中國經濟政策|中国经济政策)/, 6
    end
  end
  
  context "(dream of) Red Chamber, a famous Chinese novel", :jira => 'VUF-2773' do
    it_behaves_like "both scripts get expected result size", 'title', 'traditional', '紅樓夢', 'simplified', '红楼梦', 500, 525
    it_behaves_like "matches in vern short titles first", 'title', '紅樓夢', /^(紅樓夢|红楼梦|紅楼夢)[^[[:alpha:]]]*$/, 3
    it_behaves_like "matches in vern short titles first", 'title', '紅樓夢', /(紅樓夢|红楼梦|紅楼夢|红楼夢)/, 40
    it_behaves_like "matches in vern short titles first", 'title', '红楼梦', /^(紅樓夢|红楼梦|紅楼夢)[^[[:alpha:]]]*$/, 3
    it_behaves_like "matches in vern short titles first", 'title', '红楼梦', /(紅樓夢|红楼梦|紅楼夢|红楼夢)/, 40
  end
  
  context "float (Gone with the Wind)" do
    # see chinese_unigram_spec
  end

  context "golden lotus" do
    context "no space" do
      it_behaves_like "expected result size", 'title', ' 金瓶梅', 154, 175
    end
    context "one space" do
      it_behaves_like "expected result size", 'title', ' 金瓶  梅', 154, 175
    end
    context "two spaces" do
      it_behaves_like "expected result size", 'title', ' 金 瓶 梅', 154, 175
    end
  end
  
  context "history research", :jira => 'VUF-2771' do
    # see also chinese_han_variants spec, as the 3rd character isn't matching what's in the record
    context "no spaces" do
      it_behaves_like "both scripts get expected result size", 'title', 'traditional', '歷史研究', 'simplified', '历史研究', 562, 900
    end
    context "with space" do
      it_behaves_like "both scripts get expected result size", 'title', 'traditional', '歷史 研究', 'simplified', '历史 研究', 1000, 1100
    end
    context "as phrase" do
      it_behaves_like "both scripts get expected result size", 'title', 'traditional', '"歷史研究"', 'simplified', '"历史研究"', 155, 175
    end
  end
  
  context "national population survey", :jira => 'VUF-2745' do
    context "no spaces" do
      it_behaves_like "expected result size", 'title', '全国人口抽样调查', 7, 10
      it_behaves_like "matches in vern short titles first", 'title', '全国人口抽样调查', /全国.*人口抽样调查/, 5
      # FIXME:
      it_behaves_like "best matches first", 'title', '全国人口抽样调查', '10108596', 6  # actually not relevant -- checking that it's 6th here
#      it_behaves_like "does not find irrelevant results", 'title', '全国人口抽样调查', '10108596'   
    end
    context "with space" do
      it_behaves_like "expected result size", 'title', '全国 人口抽样调查', 7, 10
      it_behaves_like "matches in vern short titles first", 'title', '全国人口抽样调查', /全国.*人口抽样调查/, 5
      it_behaves_like "does not find irrelevant results", 'title', '全国 人口抽样调查', '10108596'   
    end
  end

  context "old fiction" do
    # old (simp)  旧   (trad)  舊
    # fiction (simp)  小说   (trad)  小說
    shared_examples_for "great title search results for old fiction (Han)" do
      it_behaves_like "great search results for old fiction (Han)"
      it "other relevant results" do
        other = ["6288832", # old 505t; fiction 505t x2
                #  "7699186", # old (simp) in 245a, fiction (simp) in 490 and 830
                #  "6204747", # old 245a; fiction 490a; 830a
                #  "6698466", # old 245a; fiction 490a, 830a
                ]
        expect(resp).to include(other)
      end
    end
    context "no spaces" do
      it_behaves_like "both scripts get expected result size", 'title', 'traditional', '舊小說', 'simplified', '旧小说', 11, 15
      trad_resp = cjk_query_resp_ids('title', '舊小說')
      simp_resp = cjk_query_resp_ids('title', '旧小说')
      it_behaves_like "great title search results for old fiction (Han)" do
        let (:resp) { trad_resp }
      end
      it_behaves_like "great title search results for old fiction (Han)" do
        let (:resp) { simp_resp }
      end
    end
    context "with space" do
      it_behaves_like "both scripts get expected result size", 'title', 'traditional', '舊 小說', 'simplified', '旧 小说', 11, 17
      trad_resp = cjk_query_resp_ids('title', '舊 小說')
      simp_resp = cjk_query_resp_ids('title', '旧 小说')
      it_behaves_like "great title search results for old fiction (Han)" do
        let (:resp) { trad_resp }
      end
      it_behaves_like "great title search results for old fiction (Han)" do
        let (:resp) { simp_resp }
      end
    end
  end

  context "People's Republic of China", :jira => 'SW-207' do
    shared_examples_for "great results" do | query |
      it_behaves_like "matches in vern short titles first", 'title', query, /^(中國地方誌集成|中国地方志集成|中國地方志集成)[^[[:alpha:]]]*$/, 50
    end
    context "no spaces" do
      it_behaves_like "both scripts get expected result size", 'title', 'traditional', '中國地方誌集成', 'simplified', '中国地方志集成', 850, 1100
      it_behaves_like "great results", '中國地方誌集成'
      it_behaves_like "great results", '中国地方志集成'
    end
    context "spaces" do
      it_behaves_like "both scripts get expected result size", 'title', 'traditional', '中國地 方誌 集成', 'simplified', '中国地 方志 集成', 850, 1100
      it_behaves_like "great results", '中國地 方誌 集成'
      it_behaves_like "great results", '中国地 方志 集成'
    end
  end

  context "Quan Song bi ji" do
    shared_examples_for "great results" do | query |
      it_behaves_like "matches in vern short titles first", 'title', query, /^全宋筆(記|记)[^[[:alpha:]]]*$/, 5
    end
    context "no spaces" do
      it_behaves_like "both scripts get expected result size", 'title', 'traditional', '全宋笔记', 'simplified', '全宋筆記', 6, 8
      it_behaves_like "great results", '全宋笔记'
      it_behaves_like "great results", '全宋筆記'
    end
    context "middle space" do
      it_behaves_like "both scripts get expected result size", 'title', 'traditional', '全宋 笔记', 'simplified', '全宋 筆記', 6, 8
      it_behaves_like "great results", '全宋 笔记'
      it_behaves_like "great results", '全宋 筆記'
    end
    context "two spaces" do
      it_behaves_like "both scripts get expected result size", 'title', 'traditional', '全 宋 笔记', 'simplified', '全 宋 筆記', 6, 10
      it_behaves_like "great results", '全 宋 笔记'
      it_behaves_like "great results", '全 宋 筆記'
    end
  end

  context "three kingdoms 3 char" do
    # see chinese_unigram_spec
  end

  context "three kingdoms 4 char, title search" do
    shared_examples_for "great results" do | query |
      it_behaves_like "matches in vern short titles first", 'title', query, /^(三國演義|三国演义)[^[[:alpha:]]]*$/, 12
    end
    context "no spaces" do
      it_behaves_like "both scripts get expected result size", 'title', 'traditional', '三國演義', 'simplified', '三国演义', 83, 90
      it_behaves_like "great results", '三國演義'
      it_behaves_like "great results", '三国演义'
    end
    context "middle space" do
      it_behaves_like "both scripts get expected result size", 'title', 'traditional', '三國 演義', 'simplified', '三国 演义', 83, 90
      it_behaves_like "great results", '三國 演義'
      it_behaves_like "great results", '三国 演义'
    end
    context "first space" do
      it_behaves_like "both scripts get expected result size", 'title', 'traditional', '三 國演義', 'simplified', '三 国演义', 83, 90
      it_behaves_like "great results", '三 國演義'
      it_behaves_like "great results", '三 国演义'
    end
    context "all spaces" do
      it_behaves_like "great results", '三 國 演 義'
      it_behaves_like "great results", '三 国 演 义'
    end
  end

=begin

  context "women *and* literature, title search" do
    context "no spaces" do
      it_behaves_like "simplified and traditional title search get expected number of results", "妇女与文学", "婦女與文學", 17
    end
    context "spaces" do
      it_behaves_like "simplified and traditional title search get expected number of results", "妇女 与 文学", "婦女 與 文學", 17
    end
  end

  context "women marriage, title search" do
    context "no spaces" do
      it_behaves_like "simplified and traditional title search get expected number of results", "妇女婚姻", "婦女婚姻", 8
    end
    context "space" do
      it_behaves_like "simplified and traditional title search get expected number of results", "妇女 婚姻", "婦女 婚姻", 8
    end
  end

  context "women 'marriage law', title search" do
    context "no spaces" do
      it_behaves_like "simplified and traditional title search get expected number of results", "妇女婚姻法", "婦女婚姻法", 4
    end
    context "space" do
      it_behaves_like "simplified and traditional title search get expected number of results", "妇女 婚姻法", "婦女 婚姻法", 4
    end
  end

  context "women *and* marriage, title search" do
    context "no spaces" do
      it_behaves_like "simplified and traditional title search get expected number of results", "妇女与婚姻", "婦女與婚姻", 7
    end
    context "spaces" do
      it_behaves_like "simplified and traditional title search get expected number of results", "妇女 与 婚姻", "婦女 與 婚姻", 7
    end
  end

  context "zen, title search" do
    it_behaves_like "simplified and traditional title search get expected number of results", "禅", "禪", 962
  end

  context "Zhengzhou geography, title search" do
    context "no spaces" do
      it_behaves_like "simplified and traditional title search get expected number of results", "郑州地理", "鄭州地理", 2
    end
    context "space" do
      it_behaves_like "simplified and traditional title search get expected number of results", "郑州 地理", "鄭州 地理", 2
    end
  end
=end 
end