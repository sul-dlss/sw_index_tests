# -*- encoding : utf-8 -*-
require 'spec_helper'

describe 'Chinese Everything', chinese: true do
  context 'china economic policy', jira: 'SW-100' do
    it_behaves_like 'both scripts get expected result size', 'everything', 'traditional', '中國經濟政策', 'simplified', '中国经济政策', 350, 450
    it_behaves_like 'matches in vern short titles first', 'everything', '中國經濟政策', /^(中國經濟政策|圈点)$/, 1
    # 圈点 (4648314) has a full title that includes an exact match
    it_behaves_like 'matches in vern short titles first', 'everything', '中國經濟政策', /(中國經濟政策|中国经济政策|中国経済政策史|圈点|中國新經濟政策)/, 7
    context 'with spaces' do
      it_behaves_like 'both scripts get expected result size', 'everything', 'traditional', '中國 經濟 政策', 'simplified', '中国 经济 政策', 350, 450

      it_behaves_like 'matches in vern short titles first', 'everything', '中國 經濟 政策', /^中國經濟政策$/, 1
      it_behaves_like 'matches in vern short titles first', 'everything', '中國 經濟 政策', /(中國經濟政策|中国经济政策|中国経済政策史|圈点)/, 4
    end
  end

  context 'contemporary china economic study', jira: 'VUF-2767' do
    trad = '當代中國經濟研究'
    simp = '当代中国经济研究'
    it_behaves_like 'both scripts get expected result size', 'everything', 'traditional', trad, 'simplified', simp, 12, 190
    it_behaves_like 'best matches first', 'everything', simp,
                    %w(4164852 10153644 8225832 4335450 4185340 6319540 6370106), 18
  end

  context 'Chu Anping', jira: 'VUF-2689' do
    # see also chinese_han_variants spec, as there are two traditional forms of the second character
    it_behaves_like 'good results for query', 'everything', '储安平', 22, 30, %w(6710188 6342768 6638798), 30, 'rows' => 30
  end

  context 'Full Song notes' do
    # more details: email on gryph-search week of 8/13/(2012?  2011?) w subject chinese search test - question 1
    shared_examples_for 'great results for Full Song notes' do |query|
      it_behaves_like 'expected result size', 'everything', query, 6, 35
      it_behaves_like 'best matches first', 'everything', query, '5701106', 11 # record has  全宋筆记
      it_behaves_like 'best matches first', 'everything', query, %w(9579321 9579315 6734714 8146870), 10 # records have  全宋筆記
    end # shared examples  great search results for old fiction (Han)
    it_behaves_like 'both scripts get expected result size', 'everything', 'trad', '全宋筆記', 'simp', '全宋笔記', 10, 22
    it_behaves_like 'great results for Full Song notes', '全宋筆记'
    it_behaves_like 'great results for Full Song notes', '全宋筆記'
    it_behaves_like 'great results for Full Song notes', '全  宋  筆記'
    it_behaves_like 'great results for Full Song notes', '全  宋  笔記'
  end

  context 'history research', jira: 'VUF-2771' do
    context 'no spaces' do
      it_behaves_like 'both scripts get expected result size', 'everything', 'traditional', '歷史研究', 'simplified', '历史研究', 8500, 10000
    end
    context 'with space' do
      it_behaves_like 'both scripts get expected result size', 'everything', 'traditional', '歷史研究', 'simplified', '历史研究', 8500, 10500
    end
    context 'as phrase' do
      it_behaves_like 'both scripts get expected result size', 'everything', 'traditional', '"歷史研究"', 'simplified', '"历史研究"', 800, 1050
    end
  end

  context 'Nanyang or Nanʼyō', jira: 'SW-100' do
    it_behaves_like 'result size and vern short title matches first', 'everything', '南洋', 775, 875, /南洋/, 30
    # it_behaves_like 'matches in vern titles', 'everything', '南洋', /南洋群島/, 20
    # Nan'yō Guntō
    it_behaves_like 'result size and vern short title matches first', 'everything', '南洋群島', 55, 65, /南洋(群|羣)島/, 15
    it_behaves_like 'good results for query', 'everything', '椰風蕉雨話南洋', 1, 1, '5564542', 1
  end

  context 'old fiction' do
    # old (simp)  旧   (trad)  舊
    # fiction (simp)  小说   (trad)  小說
    shared_examples_for 'great everything search results for old fiction' do
      it_behaves_like 'great search results for old fiction (Han)'
    end # shared examples  great search results for old fiction (Han)
    context 'no spaces' do
      it_behaves_like 'both scripts get expected result size', 'everything', 'traditional', '舊小說', 'simplified', '旧小说', 40, 80
      it_behaves_like 'great everything search results for old fiction' do
        let(:resp) { cjk_query_resp_ids('everything', '舊小說', 'rows' => 40) }
      end
      it_behaves_like 'great everything search results for old fiction' do
        let(:resp) { cjk_query_resp_ids('everything', '旧小说', 'rows' => 40) }
      end
    end
    context 'with space' do
      it_behaves_like 'both scripts get expected result size', 'everything', 'traditional', '舊 小說', 'simplified', '旧 小说', 40, 80
      it_behaves_like 'great everything search results for old fiction' do
        let(:resp) { cjk_query_resp_ids('title', '舊 小說') }
      end
      it_behaves_like 'great everything search results for old fiction' do
        let(:resp) { cjk_query_resp_ids('title', '旧 小说') }
      end
    end
  end

  context 'women *and* literature' do
    shared_examples_for 'great search results for women and literature' do
      it_behaves_like 'great search results for women and literature (Han)'
      it 'other relevant results' do
        other = ['8925289', # trad  lit, women in 505a, but not together
                 '8705135', # simp  lit x2 in 520a, women x2 in 520a, not together
                 '8625928', # simp  women, lit in 520a, not together
                 '8336358', # simp  women  in  245b, 246a, 520a;  lit in 520a
                 '7925586', # simp  lit then women in 520, not together
                 '6192248', # simp  lit, then women  in 505, not together
                ]
        expect(resp).to include(other)
      end
    end
    context 'no spaces' do
      it_behaves_like 'both scripts get expected result size', 'everything', 'traditional', '婦女與文學', 'simplified', '妇女与文学', 30, 50
      it_behaves_like 'great search results for women and literature' do
        let(:resp) { cjk_query_resp_ids('everything', '婦女與文學', 'rows' => 50) }
      end
      it_behaves_like 'great search results for women and literature' do
        let(:resp) { cjk_query_resp_ids('everything', '妇女与文学', 'rows' => 50) }
      end
    end
    context 'with spaces' do
      it_behaves_like 'both scripts get expected result size', 'everything', 'traditional', '婦女 與 文學', 'simplified', '妇女 与 文学', 35, 55
      context '', skip: :fixme do
        it_behaves_like 'great search results for women and literature' do
          let(:resp) { cjk_query_resp_ids('everything', '婦女 與 文學', 'rows' => 50) }
        end
        it_behaves_like 'great search results for women and literature' do
          let(:resp) { cjk_query_resp_ids('everything', '妇女 与 文学', 'rows' => 50) }
        end
      end
    end
  end

  context 'women marriage', jira: 'SW-100' do
    #  ' 婚姻法 (marriage law) in sirsi dict, but 婚姻 (marriage) is what we wanted'
    #   because sirsi dictionary approach does length-first matching
    it_behaves_like 'both scripts get expected result size', 'everything', 'traditional', '婦女婚姻', 'simplified', '妇女婚姻', 25, 75
    it_behaves_like 'both scripts get expected result size', 'everything', 'traditional', '婦女 婚姻', 'simplified', '妇女 婚姻', 25, 75
  end

  context 'women marriage law' do
    shared_examples_for 'great search results for women marriage law', skip: :fixme do
      # woman:   traditional:  婦女    simplified:  妇女
      # marriage law: 婚姻法   marriage: 婚姻  (same for both)   law: 法   (same for both)
      it "matches simp 'woman' and 'marriage law'" do
        expect(resp).to include('4200804') # woman (simp) 245c, 710a;  marriage law:  245a, 710a  (no other occurrence of marriage)
        expect(resp).to include('4207254') # woman (simp) 245c; 260b, 710a   marriage law:  245c, 710b;  marriage  245a
      end
      it "matches trad 'woman' and 'marriage law'" do
        expect(resp).to include('8722338') # woman (trad) 505t (many) ; marriage law: 505t, 505t ; marriage: diff 505t (mult)
        expect(resp).to include('6202487') # woman (trad) 245c 260b, 710a; marriage law:  245a, 500a, 710a  (no other occurrence of marriage)
        expect(resp).to include('6543154') # woman (trad) 245a, 245c, 710a; marriage law 710t
        expect(resp).to include('9956874') # woman (trad) 245a, 245c, 710a; marriage law 710t
      end
      it "matches simp 'woman' and 'marriage' and 'law' but not 'marriage law'" do
        expect(resp).to include('4520813') # woman (simp) 505a, 740a ; marriage 245a, 505a, 740a;  law 245a, 260a, 505a, 740a
        expect(resp).to include('8716123') # woman (simp) 520a, 245a ; marriage 520a; law 520a, 260b, 490a, 830a
      end
      it "matches trad 'woman' and 'marriage' and 'law' but not 'marriage law'" do
        expect(resp).to include('9665009') # woman (trad) 505t (mult) ; marriage 505t (mult); law 505t
        expect(resp).to include('9665014') # woman (trad) 505t (mult) ; marriage 505t (mult); law 505t, 520t
      end
    end
    context 'no spaces' do
      it_behaves_like 'both scripts get expected result size', 'everything', 'traditional', '婦女婚姻法', 'simplified', '妇女婚姻法', 5, 20
      it_behaves_like 'great search results for women marriage law' do
        let(:resp) { cjk_query_resp_ids('everything', '婦女婚姻法') }
      end
      it_behaves_like 'great search results for women marriage law' do
        let(:resp) { cjk_query_resp_ids('everything', '妇女婚姻法') }
      end
    end
    context 'one space' do
      it_behaves_like 'both scripts get expected result size', 'everything', 'traditional', '婦女 婚姻法', 'simplified', '妇女 婚姻法', 5, 20
      it_behaves_like 'great search results for women marriage law' do
        let(:resp) { cjk_query_resp_ids('everything', '婦女 婚姻法') }
      end
      it_behaves_like 'great search results for women marriage law' do
        let(:resp) { cjk_query_resp_ids('everything', '妇女 婚姻法') }
      end
    end
    context 'two spaces' do
      it_behaves_like 'both scripts get expected result size', 'everything', 'traditional', '婦女 婚姻 法', 'simplified', '妇女 婚姻 法', 5, 20
      it_behaves_like 'great search results for women marriage law' do
        let(:resp) { cjk_query_resp_ids('everything', '婦女 婚姻 法') }
      end
      it_behaves_like 'great search results for women marriage law' do
        let(:resp) { cjk_query_resp_ids('everything', '妇女 婚姻 法') }
      end
    end
  end # women marriage law
end
