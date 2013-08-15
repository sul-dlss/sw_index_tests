# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'rspec-solr'

describe "Basic Target Result Numbers for CJK", :fixme => true, :vetted => 'vitus' do
  
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
  
  context "chinese", :chinese => true do
    context "china economic policy (NO spaces), title search" do
      it_behaves_like "simplified and traditional title search get expected number of results", "中国经济政策", "中國經濟政策", 55
    end
    context "china economic policy (SPACES), title search" do
      it_behaves_like "simplified and traditional title search get expected number of results", "中国 经济 政策", "中國 經濟 政策", 55
    end
    
    context "dream of red mansions (NO spaces), title search" do
      it_behaves_like "simplified and traditional title search get expected number of results", "红楼梦", "紅樓夢", 503
    end
    
    context "float (Gone with the Wind), title search" do
      it_behaves_like "simplified and traditional title search get expected number of results", "飘", "飄", 120
    end

    context "golden lotus 金瓶梅 (NO spaces), title search" do
      it_behaves_like "title search gets expected number of results", "金瓶梅", 154
    end
    context "golden lotus 金瓶 梅(SPACES), title search" do
      it_behaves_like "title search gets expected number of results", "金瓶 梅", 154 
    end
    context "golden lotus 金 瓶 梅(ALL SPACES), title search" do
      it_behaves_like "title search gets expected number of results", "金 瓶 梅", 154
    end
    
    context "history research (NO spaces), title search" do
      it_behaves_like "simplified and traditional title search get expected number of results", "历史研究", "歷史研究", 562
    end
    context "history research (middle SPACE), title search" do
      it_behaves_like "simplified and traditional title search get expected number of results", "历史 研究", "歷史 研究", 562
    end

    context "old fiction (NO spaces), title search" do
      it_behaves_like "simplified and traditional title search get expected number of results", "旧小说", "舊小說", 11
    end
    context "old fiction (SPACES), title search" do
      it_behaves_like "simplified and traditional title search get expected number of results", "旧 小说", "舊 小說", 11
    end

    context "People's Republic of China (?) (NO spaces), title search" do
      it_behaves_like "simplified and traditional title search get expected number of results", "中国地方志集成", "中國地方志集成", 852
    end
    context "People's Republic of China (?) (SPACES), title search" do
      it_behaves_like "simplified and traditional title search get expected number of results", "中国 地方志 集成", "中國 地方志 集成", 852
    end

    context "three kingdoms (?) 3 char (NO spaces), title search" do
      it_behaves_like "simplified and traditional title search get expected number of results", "三国志", "三國誌", 170
    end
    context "three kingdoms (?) 3 char (SPACES), title search" do
      it_behaves_like "simplified and traditional title search get expected number of results", "三国 志", "三國 誌", 170
    end

    context "three kingdoms (?) 4 char (NO spaces), title search" do
      it_behaves_like "simplified and traditional title search get expected number of results", "三国演义", "三國演義", 113
    end
    context "three kingdoms (?) 4 char (middle SPACE), title search" do
      it_behaves_like "simplified and traditional title search get expected number of results", "三国 演义", "三國 演義", 113
    end
    context "three kingdoms (?) 4 char (first SPACE), title search" do
      it_behaves_like "simplified and traditional title search get expected number of results", "三 国演义", "三 國演義", 113
    end
    context "three kingdoms (?) 4 char (ALL SPACE), title search" do
      it_behaves_like "simplified and traditional title search get expected number of results", "三 国 演 义", "三 國 演 義", 113
    end

    context "women *and* literature (NO spaces), title search" do
      it_behaves_like "simplified and traditional title search get expected number of results", "妇女婚姻法", "婦女與婚姻", 17
    end
    context "women *and* literature (SPACES), title search" do
      it_behaves_like "simplified and traditional title search get expected number of results", "妇女 婚 姻法", "婦女 與 婚姻", 17
    end

    context "women marriage (NO spaces), title search" do
      it_behaves_like "simplified and traditional title search get expected number of results", "妇女婚姻", "婦女婚姻", 8
    end
    context "women marriage (SPACES), title search" do
      it_behaves_like "simplified and traditional title search get expected number of results", "妇女 婚姻", "婦女 婚姻", 8
    end

    context "women 'marriage law' (NO spaces), title search" do
      it_behaves_like "simplified and traditional title search get expected number of results", "妇女婚姻法", "婦女婚姻法", 4
    end
    context "women 'marriage law' (SPACES), title search" do
      it_behaves_like "simplified and traditional title search get expected number of results", "妇女 婚姻法", "婦女 婚姻法", 4
    end

    context "women *and* marriage (NO spaces), title search" do
      it_behaves_like "simplified and traditional title search get expected number of results", "妇女与婚姻", "婦女與婚姻", 7
    end
    context "women *and* marriage (SPACES), title search" do
      it_behaves_like "simplified and traditional title search get expected number of results", "妇女 与 婚姻", "婦女 與 婚姻", 7
    end

    context "zen, title search" do
      it_behaves_like "simplified and traditional title search get expected number of results", "禅", "禪", 962
    end

    context "Zhengzhou geography (NO spaces), title search" do
      it_behaves_like "simplified and traditional title search get expected number of results", "郑州地理", "鄭州地理", 2
    end
    context "Zhengzhou geography (spaces), title search" do
      it_behaves_like "simplified and traditional title search get expected number of results", "郑州 地理", "鄭州 地理", 2
    end



    context "方宝川 (Fang, Baochuan) author search" do
      it_behaves_like "simplified and traditional author search get expected number of results", "方宝川", "方寶川", 8
    end
    context "董桥 (Dong Quai, 1942-) author search" do
      it_behaves_like "simplified and traditional author search get expected number of results", "董桥", "董橋", 47
    end
    context "张爱玲 (Zhang, Ailing) author search" do
      it_behaves_like "simplified and traditional author search get expected number of results", "张爱玲", "張愛玲", 76
    end
    context "梁实秋 (Liang, Shiqiu, 1903-1987) author search" do
      it_behaves_like "simplified and traditional author search get expected number of results", "梁实秋", "梁實秋", 79
    end
  end # chinese

  context "japanese", :japanese => true do
    context "Buddhism, title search" do
      it_behaves_like "both scripts get expected number of results", 'modern', ' 仏教学', 'traditional', '佛教學', 'title', 19
    end
    context "comics/manga, title search" do
      it_behaves_like "both scripts get expected number of results", 'hiragana', 'まんが', 'katakana', 'マンガ', 'title', 140      
      it_behaves_like "both scripts get expected number of results", 'modern', ' 漫画', 'traditional', '漫畫', 'title', 237
    end
    context "South Manchurian Railroad Company, author search" do
      it_behaves_like "both scripts get expected number of results", 'modern', ' 南満州鉄道株式会社', 'traditional', '南滿洲鐵道株式會社', 'author', 522
    end
    context "sports, title search, スポーツ (katakana)" do
      it_behaves_like "title search gets expected number of results", 'スポーツ', 34
    end
    context "personal name author search (契沖)" do
      it_behaves_like "both scripts get expected number of results", 'kanji', '契沖', 'hiragana', 'けいちゅう', 'author', 5
    end
    context "mixed script title search, (modern pseudonym usage: 近世仮名遣い)" do
      it_behaves_like "title search gets expected number of results", '近世仮名遣い', 1
    end
    context "kanji author search  釘貫 (surname of 釘貫亨)" do
      it_behaves_like "author search gets expected number of results", '釘貫', 1
    end
  end # japanese
  
  context "korean", :korean => true do
    context "author search '한 영우 with and without spaces" do
      it_behaves_like "both scripts get expected number of results", 'spaces', '한 영우', 'no spaces', '한영우', 'author', 32
    end
    context "everything search 한국 주택 은행 (Korean Home Bank) with and without spaces" do
      it_behaves_like "both scripts get expected number of results", 'spaces', '한국 주택 은행', 'no spaces', '한국주택은행', nil, 2
    end
    context "everything search hanja  韓國 住宅 銀行 with and without spaces" do
      it_behaves_like "both scripts get expected number of results", 'spaces', '韓國 住宅 銀行', 'no spaces', '韓國住宅銀行', nil, 1
    end
  end # korean
  
end