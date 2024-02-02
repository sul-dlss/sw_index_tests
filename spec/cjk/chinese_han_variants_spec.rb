# -*- encoding : utf-8 -*-
require 'spec_helper'

describe 'Chinese Han variants', chinese: true do
  context 'Guangxu (pinyin input method vs our data)', jira: ['VUF-2757', 'VUF-2751'] do
    # The Unicode code point of the "with dot" version (緖) is U+7DD6. And the code point for the "without dot" version (緒) is U+7DD2
    # In the Unicode standard, it is the "without dot" version (U+7DD2) that is linked to the simplified form (U+7EEA). The "with dot" version is not.
    # We have more records with the "with dot" version than the "without dot" version.
    #   added  7DD6 -> 7DD2 mapping
    it_behaves_like 'both scripts get expected result size', 'everything', 'with dot', '光緖', 'without dot', '光緒', 5500, 6500
    it_behaves_like 'both scripts get expected result size', 'everything', 'traditional (with dot)', '光緖', 'simplified', '光绪', 5500, 6500
    it_behaves_like 'both scripts get expected result size', 'everything', 'without dot', '光緒', 'simplified', '光绪', 5500, 6500
    context 'with dot U+7DD6  緖' do
      it_behaves_like 'expected result size', 'everything', '光緖', 5500, 6500
    end
    context 'without dot U+7DD2 緒' do
      it_behaves_like 'expected result size', 'everything', '光緒', 5500, 6500
    end
    context 'simplified U+7EEA 绪' do
      it_behaves_like 'expected result size', 'everything', '光绪', 5500, 6500
    end
  end

  context 'Hiroshi', jira: 'VUF-2760' do
    #  廣甯縣
    # desire:  first and second chars 廣寧   become  广宁
    # first char  廣 (U+5EE3) => becomes  广 (U+5E7F)
    # added variant  甯 752F => standard trad 寧 5BE7, which does map to   宁 (U+5B81)
    addl_desired_results = ['4184963', # 245a
                            '6833733', # 245a,  9th
                           ]
    shared_examples_for 'great matches for Hiroshi' do |query|
      it_behaves_like 'matches in vern short titles first', 'title', query, /(廣|广)(甯|寧|宁)(縣|县)/, 9 # modern
      it_behaves_like 'best matches first', 'title', query, addl_desired_results, 15
    end
    trad = '廣甯縣'
    simp = '广宁县'
    it_behaves_like 'both scripts get expected result size', 'title', 'traditional', trad, 'simplified', simp, 25, 40
    it_behaves_like 'great matches for Hiroshi', trad
    it_behaves_like 'great matches for Hiroshi', simp
  end

  context 'history research' do
    # the 3rd character
    #  历史硏究   硏  U+784F   in the records   6433575, 9336336
    #   correct mapping of 緖 784F (variant) => 研 7814 (std trad, also simp)
    shared_examples_for 'great matches for history research' do |query_type, query|
      it_behaves_like 'best matches first', query_type, query, %w(6433575 9336336), 2
      it_behaves_like 'matches in vern short titles first', query_type, query, /^歷史\s*(硏|研)究$/, 2
    end
    context 'no spaces' do
      it_behaves_like 'both scripts get expected result size', 'title', 'traditional', '歷史研究', 'simplified', '历史研究', 1250, 2400
      it_behaves_like 'great matches for history research', 'title', '歷史研究'
      it_behaves_like 'great matches for history research', 'title', '历史研究'
    end
    context 'with space' do
      it_behaves_like 'both scripts get expected result size', 'title', 'traditional', '歷史 研究', 'simplified', '历史 研究', 2500, 3000

      it_behaves_like 'best matches first', 'title', '歷史 研究', %w(6433575 9336336), 10
      it_behaves_like 'best matches first', 'title', '历史 研究', %w(6433575 9336336), 10
    end
    context 'as phrase' do
      it_behaves_like 'both scripts get expected result size', 'title', 'traditional', '"歷史研究"', 'simplified', '"历史研究"', 275, 400
      it_behaves_like 'great matches for history research', 'title', '"歷史研究"'
      it_behaves_like 'great matches for history research', 'title', '"历史研究"'
    end
  end

  context 'International Politics Quarterly', jira: 'VUF-2691' do
    # the fifth character is different:  the traditional character is not xlated to the simple one
    #   correct mapping of 緖 784F (variant) => 研 7814 (std trad)
    # FIXME:  these do not give the same numbers of results.
    # it_behaves_like "both scripts get expected result size", 'title', 'traditional', '國際政治硏究', 'simplified', '国际政治研究', 24, 60
    it_behaves_like 'expected result size', 'title', '國際政治硏究', 50, 60  # trad
    it_behaves_like 'expected result size', 'title', '国际政治研究', 50, 60  # simplified

    it_behaves_like 'best matches first', 'title', '國際政治硏究', '7106961', 2
    it_behaves_like 'best matches first', 'title', '国际政治研究', '7106961', 2
  end

  context 'xi ju yan jiu', jira: 'VUF-2798' do
    # 1st char:   戲 (U+6232)  which can be  戯 (U+622F), 戱 (U+6231) or 戏 (U+620F)
    #  added  戯 6231 (variant) => 戲 6232 (std trad)
    # 3rd char: correct mapping of 緖 784F (variant) => 研 7814 (std trad)
    it_behaves_like 'best matches first', 'title', '戲劇研究', ['6694075', # 245a 戲劇研究
                                                            '9669954', # 245a  戯劇硏究
                                                            '12084994', # 245a 戯劇硏究
                                                            '6694086', # 245a  戯劇硏究
                                                            '6860183', # 245a  戏剧硏究
                                                           ], 5, 'fq' => 'format_main_ssim:Journal/Periodical'
    it_behaves_like 'matches in vern short titles first', 'title', '戲劇研究', /^(戯|戱|戲|戏)(劇|剧)(硏|研)究[^[[:alnum:]]]*$/, 6
  end

  context 'Yue Fu Zhi', jira: 'VUF-2746' do
    #  1st char:  added  嶽 5DBD (std trad) => 岳 5CB3 (simp)
    desired_results = %w(10160893 11458846 9646016)
    qtrad = '嶽州府志'
    qsimp = '岳州府志'
    it_behaves_like 'both scripts get expected result size', 'title', 'traditional', qtrad, 'simplified', qsimp, 3, 15
    it_behaves_like 'best matches first', 'title', qtrad, desired_results, 15
    it_behaves_like 'best matches first', 'title', qsimp, desired_results, 15
  end

  context 'Minguo shi qi she hui diao cha cong bian' do
    it '囯 vs  国' do
      # added  囯 56EF (variant) => 國 570B (std trad)
      resp = solr_resp_doc_ids_only('q' => '民囯时期社会调查丛编') # A (囯) is second char  # 1 in prod: 8593449, 2 in soc as of 2012-11
      expect(resp.size).to be >= 3
      expect(resp).to include(%w(8593449 6553207))
      expect(resp).to include('8940619') # has title 民国时期社会调查丛编 - B (国) is second char  # 1 in prod: 8940619, 1 in soc as of 2012-11
    end
  end

  context '嶽 5DBD (std trad) => 岳 5CB3 (simp)' do
    it_behaves_like 'both scripts get expected result size', 'title', 'traditional', '富嶽', 'simplified', '富岳', 3, 15
  end

  context '囯 56EF (variant) => 國 570B (std trad)', skip: :fixme do
    # TODO: these return different results because the text_ja analysis doesn't simplify chinese characters
    it_behaves_like 'both scripts get expected result size', 'title', 'variant', '国家の', 'std trad', '國家の', 1400, 2200
  end

  context '戯 6231 (variant) => 戲 6232 (std trad)' do
    it_behaves_like 'both scripts get expected result size', 'everything', 'variant', '戯作文学', 'std trad', '戏作文学', 10, 17
  end

  context '敎 654E (variant) => 教 6559 (std trad)' do
    # FIXME:  these do not give the same numbers of results.
    # it_behaves_like "both scripts get expected result size", 'title', 'variant', '敎育', 'std trad', '教育', 3000, 3500, {'fq'=>'language:Japanese'}
    it_behaves_like 'expected result size', 'title', '敎育', 3500, 4500, 'fq' => 'language:Japanese'  # variant
    it_behaves_like 'expected result size', 'title', '教育', 3500, 4500, 'fq' => 'language:Japanese'  # std trad
  end

  context '甯 752F (variant) => 寧 5BE7 (std trad)' do
    it_behaves_like 'both scripts get expected result size', 'title', 'variant', '丁甯語の', 'std trad', '丁寧語の', 1, 5
  end

  context '硏 784F (variant) => 研 7814 (std trad)' do
    # FIXME:  these do not give the same numbers of results.
    # it_behaves_like "both scripts get expected result size", 'title', 'variant', '硏究', 'std trad', '研究', 14750, 15250, {'fq'=>'language:Japanese'}
    it_behaves_like 'expected result size', 'title', '硏究', 16_750, 18_750, 'fq' => 'language:Japanese'  # variant
    it_behaves_like 'expected result size', 'title', '研究', 16_750, 18_750, 'fq' => 'language:Japanese'  # std trad
  end

  context '緖 7DD6 (variant) => 緒 7DD2 (std trad)' do
    it_behaves_like 'both scripts get expected result size', 'title', 'variant', '緖方', 'std trad', '緒方', 30, 40
  end

  context '緖 7DD6 (variant) => 緒 7DD2 (std trad)' do
    it_behaves_like 'both scripts get expected result size', 'title', 'variant', '緖方', 'std trad', '緒方', 30, 40
  end

  context '緖 7DD6 (variant) => 緒 7DD2 (std trad)' do
    it_behaves_like 'both scripts get expected result size', 'title', 'variant', '緖方', 'std trad', '緒方', 30, 40
  end

  # '\u520A' => '\u520B' // modern 刊 => trad 刋     see japanese  "weekly"
  # '\u5DDE' => '\u6D32' // modern 州 => trad 洲    see South Manchurian RailRoad Company

  #  户 vs  戸   # covered already by Jidong's list
end
