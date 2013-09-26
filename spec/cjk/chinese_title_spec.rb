# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Chinese Title", :chinese => true do
=begin  
  shared_examples_for "gets expected number of results" do | query, query_type, num_exp |
    it "should have correct number of results" do
      case query_type
        when 'title'
          resp = solr_resp_doc_ids_only(title_search_args query)
        when 'author'
          resp = solr_resp_doc_ids_only(author_search_args query)
        else
          resp = solr_resp_ids_from_query query
      end
      resp.should have_exactly(num_exp).results
    end
  end # shared_examples for  gets expected number of results

  shared_examples_for "title search gets expected number of results" do |query, num_exp|
    it_behaves_like "gets expected number of results", query, 'title', num_exp
  end
  shared_examples_for "author search gets expected number of results" do |query, num_exp|
    it_behaves_like "gets expected number of results", query, 'author', num_exp
  end
  shared_examples_for "everything search gets expected number of results" do |query, num_exp|
    it_behaves_like "gets expected number of results", query, nil, num_exp
  end
  
  shared_examples_for "both queries get same number of results" do | query1, query2, query_type |
    it "both queries should get same number of results" do
      case query_type
        when 'title'
          resp1 = solr_resp_doc_ids_only(title_search_args query1)
          resp2 = solr_resp_doc_ids_only(title_search_args query2)
        when 'author'
          resp1 = solr_resp_doc_ids_only(author_search_args query1)
          resp2 = solr_resp_doc_ids_only(author_search_args query2)
        else
          resp1 = solr_resp_ids_from_query query1
          resp2 = solr_resp_ids_from_query query2
      end
      resp1.should have_the_same_number_of_results_as resp2
    end
  end
  
  shared_examples_for "both scripts get expected number of results" do | script_name1, query1, script_name2, query2, query_type, num_exp |
    it_behaves_like "both queries get same number of results", query1, query2, query_type
    context "#{script_name1}: #{query1}" do
      it_behaves_like "gets expected number of results", query1, query_type, num_exp
    end
    context "#{script_name2}: #{query2}" do
      it_behaves_like "gets expected number of results", query2, query_type, num_exp
    end
  end
  
  shared_examples_for "simplified and traditional title search get expected number of results" do | simplified_query, traditional_query, num_exp |
    it_behaves_like "both scripts get expected number of results", 'simplified', simplified_query, 'traditional', traditional_query, 'title', num_exp
  end
  shared_examples_for "simplified and traditional author search get expected number of results" do | simplified_query, traditional_query, num_exp |
    it_behaves_like "both scripts get expected number of results", 'simplified', simplified_query, 'traditional', traditional_query, 'author', num_exp
  end
  shared_examples_for "simplified and traditional everything search get expected number of results" do | simplified_query, traditional_query, num_exp |
    it_behaves_like "both scripts get expected number of results", 'simplified', simplified_query, 'traditional', traditional_query, nil, num_exp
  end
=end  
# --- end shared examples ----------------------------------------------------------------------------------------------------------------
  
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

  context "old fiction, title search" do
    # old (simp)  旧
    # old (trad)  舊
    # fiction (simp)  小说
    # fiction (trad)  小說
    trad_245a = ['9262744', '6797638', '6695967']
    trad_245a_not_adjacent = ['6696790']
    trad_245a_diff_order = ['6695904']
    trad_245ab = ['6699444']
    simp_245a = ['8834455']
    simp_245a_diff_order = ['4192734']  #  小说旧
    shared_examples_for "great search results for old fiction (Han)" do
      it "traditional char matches" do
        expect(resp).to include(trad_245a).before(trad_245a_not_adjacent + trad_245a_diff_order + trad_245ab)
      end
      it "simplified char matches" do
        expect(resp).to include(simp_245a).before(simp_245a_diff_order)
      end
      it "adjacent words in 245a" do
        expect(resp).to include(trad_245a + simp_245a).in_first(5).results
      end
      it "both words in 245a but not adjacent" do
        expect(resp).to include(trad_245a_not_adjacent + trad_245a_diff_order + simp_245a_diff_order).in_first(8).results
      end
      it "one word in 245a and the other in 245b" do
        ab245 = ["6695904", # fiction 245a; old 245a
                  "6699444", # old 245a; fiction 245b
                  "6696790", # old 245a; fiction 245a
                  "7198256", # old 245b; fiction: 245a  (Korean also in record)
                  "6793760", # old (simplified) 245a; fiction 245b
                ]
        expect(resp).to include(ab245).in_first(12).results
      end
      it "other relevant results" do
        other = ["6288832", # old 505t; fiction 505t x2
                #  "7699186", # old (simp) in 245a, fiction (simp) in 490 and 830
                #  "6204747", # old 245a; fiction 490a; 830a
                #  "6698466", # old 245a; fiction 490a, 830a
                ]
        expect(resp).to include(other)
      end
    end # shared examples  great search results for old fiction (Han)

    context "no spaces" do
      it_behaves_like "both scripts get expected result size", 'title', 'traditional', '舊小說', 'simplified', '旧小说', 11, 15
      trad_resp = cjk_query_resp_ids('title', '舊小說', {'rows'=>'25'})
      simp_resp = cjk_query_resp_ids('title', '旧小说', {'rows'=>'25'})
      it_behaves_like "great search results for old fiction (Han)" do
        let (:resp) { trad_resp }
      end
      it_behaves_like "great search results for old fiction (Han)" do
        let (:resp) { simp_resp }
      end
    end
    context "with space" do
      it_behaves_like "both scripts get expected result size", 'title', 'traditional', '舊 小說', 'simplified', '旧 小说', 11, 17
      trad_resp = cjk_query_resp_ids('title', '舊 小說', {'rows'=>'25'})
      simp_resp = cjk_query_resp_ids('title', '旧 小说', {'rows'=>'25'})
      it_behaves_like "great search results for old fiction (Han)" do
        let (:resp) { trad_resp }
      end
      it_behaves_like "great search results for old fiction (Han)" do
        let (:resp) { simp_resp }
      end
    end
  end

  context "People's Republic of China", :jira => 'SW-207' do
    context "no spaces" do
      it_behaves_like "both scripts get expected result size", 'title', 'traditional', '中國地方誌集成', 'simplified', '中国地方志集成', 850, 1100
      it_behaves_like "matches in vern short titles first", 'title', '中國地方誌集成', /^(中國地方誌集成|中国地方志集成|中國地方志集成)[^[[:alpha:]]]*$/, 50
      it_behaves_like "matches in vern short titles first", 'title', '中国地方志集成', /^(中國地方誌集成|中国地方志集成|中國地方志集成)[^[[:alpha:]]]*$/, 50
    end
    context "spaces" do
      it_behaves_like "both scripts get expected result size", 'title', 'traditional', '中國地 方誌 集成', 'simplified', '中国地 方志 集成', 850, 1100
      it_behaves_like "matches in vern short titles first", 'title', '中國地 方誌 集成', /^(中國地方誌集成|中国地方志集成|中國地方志集成)[^[[:alpha:]]]*$/, 50
      it_behaves_like "matches in vern short titles first", 'title', '中国地 方志 集成', /^(中國地方誌集成|中国地方志集成|中國地方志集成)[^[[:alpha:]]]*$/, 50
    end
  end
=begin  
  context "Quan Song bi ji, title search" do
    context "no spaces" do
      it_behaves_like "simplified and traditional title search get expected number of results", "全宋筆記", "全宋笔记", 8
    end
    context "spaces" do
      it_behaves_like "simplified and traditional title search get expected number of results", "全宋 筆記", "全宋 笔记", 8
    end
    context "real spaces" do
      it_behaves_like "simplified and traditional title search get expected number of results", "全 宋 筆記", "全 宋 笔记", 8
    end
    context "all spaces" do
      it_behaves_like "simplified and traditional title search get expected number of results", "全 宋 筆 記", "全 宋 笔 记", 8
    end
  end
  
  context "three kingdoms 3 char, title search" do
    context "no spaces" do
      it_behaves_like "simplified and traditional title search get expected number of results", "三国志", "三國誌", 170
    end
    context "space" do
      it_behaves_like "simplified and traditional title search get expected number of results", "三国 志", "三國 誌", 170
    end
  end

  context "three kingdoms 4 char, title search" do
    context "no spaces" do
      it_behaves_like "simplified and traditional title search get expected number of results", "三国演义", "三國演義", 84
    end
    context "middle space" do
      it_behaves_like "simplified and traditional title search get expected number of results", "三国 演义", "三國 演義", 84
    end
    context "first space" do
      it_behaves_like "simplified and traditional title search get expected number of results", "三 国演义", "三 國演義", 85
    end
    context "all spaces" do
      it_behaves_like "simplified and traditional title search get expected number of results", "三 国 演 义", "三 國 演 義", 88
    end
  end

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