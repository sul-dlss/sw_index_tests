# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Chinese Title", :chinese => true do
  
  context "china economic policy", :jira => 'SW-100' do
    context "no spaces" do
      it_behaves_like "both scripts get expected result size", 'title', 'traditional', '中國經濟政策', 'simplified', '中国经济政策', 75, 100
      it_behaves_like "matches in vern short titles first", 'title', '中國經濟政策', /^中國經濟政策$/, 1
      it_behaves_like "matches in vern short titles first", 'title', '中國經濟政策', /(中國經濟政策|中国经济政策|中国経済政策史)/, 7
    end
    context "with spaces" do
      # TODO:  would like to have better precision here -- too many results now
      it_behaves_like "both scripts get expected result size", 'title', 'traditional', '中國 經濟 政策', 'simplified', '中国 经济 政策', 75, 125
      it_behaves_like "matches in vern titles", 'title', '中國 經濟 政策', /^中國經濟政策 \/.*$/, 2
      it_behaves_like "matches in vern short titles first", 'title', '中國 經濟 政策', /(中國經濟政策|中国经济政策|中国経済政策史)/, 7
    end
  end
  
  context "Chinese historical research, phrase", :jira => 'VUF-2775' do
    trad = '中國歷史研究'
    simp = '中国历史研究'
    context "phrase" do
      it_behaves_like "both scripts get expected result size", 'title', 'traditional', "\"#{trad}\"", 'simplified', "\"#{simp}\"", 14, 30
      it_behaves_like "matches in vern short titles first", 'title', "\"#{trad}\"", /中[國国][歷历歴]史[研硏]究/, 12
      it_behaves_like "matches in vern short titles first", 'title', "\"#{simp}\"", /中[國国][歷历歴]史[研硏]究/, 12
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
      it_behaves_like "both scripts get expected result size", 'title', 'traditional', '歷史研究', 'simplified', '历史研究', 1300, 1500
    end
    context "with space" do
      it_behaves_like "both scripts get expected result size", 'title', 'traditional', '歷史 研究', 'simplified', '历史 研究', 1775, 2000
    end
    context "as phrase" do
      it_behaves_like "both scripts get expected result size", 'title', 'traditional', '"歷史研究"', 'simplified', '"历史研究"', 250, 325
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
      it_behaves_like "both scripts get expected result size", 'title', 'traditional', '舊 小說', 'simplified', '旧 小说', 11, 20
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
    shared_examples_for "great results for PRC" do | query |
      it_behaves_like "matches in vern short titles first", 'title', query, /^(中國地方誌集成|中国地方志集成|中國地方志集成)[^[[:alpha:]]]*$/, 50
    end
    context "no spaces" do
      it_behaves_like "both scripts get expected result size", 'title', 'traditional', '中國地方誌集成', 'simplified', '中国地方志集成', 850, 1100
      it_behaves_like "great results for PRC", '中國地方誌集成'
      it_behaves_like "great results for PRC", '中国地方志集成'
    end
    context "spaces" do
      it_behaves_like "both scripts get expected result size", 'title', 'traditional', '中國地 方誌 集成', 'simplified', '中国地 方志 集成', 850, 1100
      it_behaves_like "great results for PRC", '中國地 方誌 集成'
      it_behaves_like "great results for PRC", '中国地 方志 集成'
    end
  end

  context "Quan Song bi ji" do
    shared_examples_for "great results for Quan Song bi ji" do | query |
      it_behaves_like "matches in vern short titles first", 'title', query, /^全宋(筆|笔)(記|记)[^[[:alpha:]]]*$/, 5
    end
    context "no spaces" do
      it_behaves_like "both scripts get expected result size", 'title', 'traditional', '全宋笔记', 'simplified', '全宋筆記', 6, 8
      it_behaves_like "great results for Quan Song bi ji", '全宋笔记'
      it_behaves_like "great results for Quan Song bi ji", '全宋筆記'
    end
    context "middle space" do
      it_behaves_like "both scripts get expected result size", 'title', 'traditional', '全宋 笔记', 'simplified', '全宋 筆記', 6, 8
      it_behaves_like "great results for Quan Song bi ji", '全宋 笔记'
      it_behaves_like "great results for Quan Song bi ji", '全宋 筆記'
    end
    context "two spaces" do
      it_behaves_like "both scripts get expected result size", 'title', 'traditional', '全 宋 笔记', 'simplified', '全 宋 筆記', 6, 12
      it_behaves_like "great results for Quan Song bi ji", '全 宋 笔记'
      it_behaves_like "great results for Quan Song bi ji", '全 宋 筆記'
    end
  end

  context "Three Kingdoms 3 char" do
    # see chinese_unigram_spec
  end

  context "Three Kingdoms 4 char, title search" do
    shared_examples_for "great results for Three Kingdoms" do | query |
      it_behaves_like "matches in vern short titles first", 'title', query, /^三(國|国|囯)演(義|义)[^[[:alpha:]]]*$/, 13
    end
    context "no spaces" do
      it_behaves_like "both scripts get expected result size", 'title', 'traditional', '三國演義', 'simplified', '三国演义', 83, 95
      it_behaves_like "great results for Three Kingdoms", '三國演義'
      it_behaves_like "great results for Three Kingdoms", '三国演义'
    end
    context "middle space" do
      it_behaves_like "both scripts get expected result size", 'title', 'traditional', '三國 演義', 'simplified', '三国 演义', 83, 95
      it_behaves_like "great results for Three Kingdoms", '三國 演義'
      it_behaves_like "great results for Three Kingdoms", '三国 演义'
    end
    context "first space" do
      it_behaves_like "both scripts get expected result size", 'title', 'traditional', '三 國演義', 'simplified', '三 国演义', 83, 95
      it_behaves_like "great results for Three Kingdoms", '三 國演義'
      it_behaves_like "great results for Three Kingdoms", '三 国演义'
    end
    context "all spaces" do
      it_behaves_like "great results for Three Kingdoms", '三 國 演 義'
      it_behaves_like "great results for Three Kingdoms", '三 国 演 义'
    end
  end

  context "women *and* literature" do
    context "no spaces" do
      it_behaves_like "both scripts get expected result size", 'title', 'traditional', '婦女與文學', 'simplified', '妇女与文学', 17, 25
      trad_resp = cjk_query_resp_ids('title', '婦女與文學')
      simp_resp = cjk_query_resp_ids('title', '妇女与文学')
      it_behaves_like "great search results for women and literature (Han)" do
        let (:resp) { trad_resp }
      end
      it_behaves_like "great search results for women and literature (Han)" do
        let (:resp) { simp_resp }
      end
    end
    context "spaces" do
      it_behaves_like "both scripts get expected result size", 'title', 'traditional', '婦女 與 文學', 'simplified', '妇女 与 文学', 17, 25
      trad_resp = cjk_query_resp_ids('title', '婦女 與 文學')
      simp_resp = cjk_query_resp_ids('title', '妇女 与 文学')
      it_behaves_like "great search results for women and literature (Han)" do
        let (:resp) { trad_resp }
      end
      it_behaves_like "great search results for women and literature (Han)" do
        let (:resp) { simp_resp }
      end
    end
  end

  context "women marriage law" do
    shared_examples_for "great search results for women marriage law" do
      # woman:   traditional:  婦女    simplified:  妇女
      # marriage law: 婚姻法   marriage: 婚姻  (same for both)   law: 法   (same for both)
      it "matches 505t trad 'woman' and 'marriage law'" do
        expect(resp).to include("8722338") # woman (trad) 505t (many) ; marriage law: 505t, 505t ; marriage: diff 505t (mult)
      end
      it "matches 505t simp 'woman' and 'marriage' and 'law' but not 'marriage law'" do
        expect(resp).to include("4520813") # woman (simp) 505a, 740a ; marriage 245a, 505a, 740a;  law 245a, 260a, 505a, 740a
      end
      it "matches 505t trad 'woman' and 'marriage' and 'law' but not 'marriage law'" do
        expect(resp).to include("9665009") # woman (trad) 505t (mult) ; marriage 505t (mult); law 505t
        expect(resp).to include("9665014") # woman (trad) 505t (mult) ; marriage 505t (mult); law 505t, 520t
      end
    end
    context "no spaces" do
      it_behaves_like "both scripts get expected result size", 'title', 'traditional', '婦女婚姻法', 'simplified', '妇女婚姻法', 4, 8
      trad_resp = cjk_query_resp_ids('title', '婦女婚姻法')
      simp_resp = cjk_query_resp_ids('title', '妇女婚姻法')
      it_behaves_like "great search results for women marriage law" do
        let (:resp) { trad_resp }
      end
      it_behaves_like "great search results for women marriage law" do
        let (:resp) { simp_resp }
      end
    end
    context "one space" do
      it_behaves_like "both scripts get expected result size", 'title', 'traditional', '婦女 婚姻法', 'simplified', '妇女 婚姻法', 4, 8
      trad_resp = cjk_query_resp_ids('title', '婦女 婚姻法')
      simp_resp = cjk_query_resp_ids('title', '妇女 婚姻法')
      it_behaves_like "great search results for women marriage law" do
        let (:resp) { trad_resp }
      end
      it_behaves_like "great search results for women marriage law" do
        let (:resp) { simp_resp }
      end
    end
    context "two spaces" do
      it_behaves_like "both scripts get expected result size", 'title', 'traditional', '婦女 婚姻 法', 'simplified', '妇女 婚姻 法', 4, 8
      trad_resp = cjk_query_resp_ids('title', '婦女 婚姻 法')
      simp_resp = cjk_query_resp_ids('title', '妇女 婚姻 法')
      it_behaves_like "great search results for women marriage law" do
        let (:resp) { trad_resp }
      end
      it_behaves_like "great search results for women marriage law" do
        let (:resp) { simp_resp }
      end
    end    
  end # women marriage law

  shared_examples_for "great results for women marriage" do
    # woman:   traditional:  婦女    simplified:  妇女
    # marriage: 婚姻  (same for both)
    it "ranks highest docs with both words in 245a (though not adjacent)" do
      resp.should include(["4222208", # woman (simp) 245a, 490a, 830a; marriage 245a (1 char between) 
                          "4401219", #  woman 245a; marriage 245a   (3 chars between)
                          "4178814", # woman 245a; marriage 245a  (out of order w char between)
                          ]).in_first(5).results
    end
    it "includes docs with both words in 245b" do
      # 7808424 - woman 245b, 246a; marriage 245b, 246a  (1 char between)
      resp.should include(["7808424"])
    end
    # Symph results from everything search 2012-11
    #  妇女婚姻 no spaces    
    #    SYMPH: 12  parsed to  妇女 same  婚姻   (same means same field)  2012-11
    #       9654720   woman 245a, 520a;  marriage 520a
    #       9229845   woman 245b, 246a;  marriage 245a
    #       8716123   woman 245a;  marriage unlinked520a 
    #       4401219   woman 245a;  marriage 245a
    #       4520813   woman 505a, 740a;  marriage 245a, 505a, 740a
    #       7808424   woman 245a, 246a;  marriage 245a, 246a
    #       4178814   woman 245a;  marriage 245a
    #       4222208   woman 245a, 490a, 830a;  marriage 245a
    #       4207254   woman 245c, 260a, 710a;  marriage 245a, 245c, 710b
    #       6201069   woman (as  婦女) 505a;  marriage 505a
    #       6696574   woman (as  婦女) 110a;  marriage 245a
    #       6343505   woman (as  婦女) 245a;  marriage 505a
    # 
    #  妇女 婚姻 space
    #   SYMPH: 20  parsed to  妇女 and  婚姻     2012-11
    #       9654720   woman 245a, 520a;  marriage 520a
    #       9229845   woman 245b, 246a;  marriage 245a
    #   NEW 8839221   woman 500a; marriage unlinked520a, 245a, 245a
    #       8716123   woman 245a;  marriage unlinked520a 
    #   NEW 8276633   woman 490a, 830a; marriage 245a
    #   NEW 8245869   woman (as 婦女) 490a, 830a; marriage 245a
    #       4401219   woman 245a;  marriage 245a 
    #       4520813   woman 505a, 740a;  marriage 245a, 505a, 740a
    #       7808424   woman 245a, 246a;  marriage 245a, 246a
    #       4178814   woman 245a;  marriage 245a
    #       4222208   woman 245a, 490a, 830a;  marriage 245a
    #   NEW 4220723   woman 260b; marriage 245b
    #   NEW 4205664   woman 260b; marriage 245a
    #       4207254   woman 245c, 260a, 710a;  marriage 245a, 245c, 710b 
    #       6201069   woman 505a (as  婦女);  marriage 505a
    #   NEW 6542987   woman (as 婦女) 260b, 710a; marriage 245a
    #       6696574   woman (as  婦女) 110a;  marriage 245a
    #   NEW 6543091   woman (as  婦女) 110a, 260b; marriage 245a
    #       6343505   woman (as  婦女) 245a;  marriage 505a
    #   NEW 6543322   woman (as  婦女) 245a, 260b, 500a; marriage 500a
    
  end # shared examples  great results for women marriage (Han)

  context "women marriage" do
    context "no spaces" do
      it_behaves_like "both scripts get expected result size", 'title', 'traditional', '婦女婚姻', 'simplified', '妇女婚姻', 8, 12
      trad_resp = cjk_query_resp_ids('title', '婦女婚姻')
      simp_resp = cjk_query_resp_ids('title', '妇女婚姻')
      it_behaves_like "great results for women marriage" do
        let (:resp) { trad_resp }
      end
      it_behaves_like "great results for women marriage" do
        let (:resp) { simp_resp }
      end
      it "ranks higher docs with one word in 245a and the other in 245b" do
        #  9229845 - woman 245b, 246a; marriage 245a 
        expect(trad_resp).to  include("9229845").in_first(5).results
        expect(simp_resp).to  include("9229845").in_first(5).results
      end
    end
    context "with space" do
      it_behaves_like "both scripts get expected result size", 'title', 'traditional', '婦女 婚姻', 'simplified', '妇女 婚姻', 8, 20
      trad_resp = cjk_query_resp_ids('title', '婦女 婚姻')
      simp_resp = cjk_query_resp_ids('title', '妇女 婚姻')
      it_behaves_like "great results for women marriage" do
        let (:resp) { trad_resp }
      end
      it_behaves_like "great results for women marriage" do
        let (:resp) { simp_resp }
      end
      it "ranks higher docs with one word in 245a and the other in 245b" do
        #  9229845 - woman 245b, 246a; marriage 245a 
        expect(trad_resp).to  include("9229845").in_first(4).results
        expect(simp_resp).to  include("9229845").in_first(4).results
      end
      it "includes additional relevant docs" do
        expect(trad_resp).to include(['4520813', '6696574', '9956874',  '9665009', '8722338'])
        expect(simp_resp).to include(['4520813', '6696574', '9956874',  '9665009', '8722338'])
      end
    end
  end # women marriage

  context "women AND marriage" do
    context "no spaces" do
      it_behaves_like "both scripts get expected result size", 'title', 'traditional', '婦女與婚姻', 'simplified', '妇女与婚姻', 7, 10
      trad_resp = cjk_query_resp_ids('title', '婦女與婚姻')
      simp_resp = cjk_query_resp_ids('title', '妇女与婚姻')
      it_behaves_like "great results for women marriage" do
        let (:resp) { trad_resp }
      end
      it_behaves_like "great results for women marriage" do
        let (:resp) { simp_resp }
      end
    end
    context "with spaces" do
      it_behaves_like "both scripts get expected result size", 'title', 'traditional', '婦女 與 婚姻', 'simplified', '妇女 与 婚姻', 7, 10
      trad_resp = cjk_query_resp_ids('title', '婦女 與 婚姻')
      simp_resp = cjk_query_resp_ids('title', '妇女 与 婚姻')
      it_behaves_like "great results for women marriage" do
        let (:resp) { trad_resp }
      end
      it_behaves_like "great results for women marriage" do
        let (:resp) { simp_resp }
      end
      it "includes additional relevant docs" do
        expect(trad_resp).to include(['8276633'])
        expect(simp_resp).to include(['8276633'])
      end
    end
  end # women AND marriage

  context "zen" do
    # see chinese_unigram_spec
  end

  context "Zhengzhou geography" do
    # see chinese_zhengzhou_geography_spec
  end
  
  context "Zhongguo jin xian dai nü xing xue shu cong kan xu bian", :jira => 'VUF-2706' do
    it_behaves_like "expected result size", 'title', ' 中國近現代女性學術叢刊續編', 5, 10    
  end
end