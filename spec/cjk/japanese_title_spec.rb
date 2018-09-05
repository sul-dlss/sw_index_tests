# -*- encoding : utf-8 -*-
require 'spec_helper'

describe 'Japanese Title searches', japanese: true do
  lang_limit = { 'fq' => ['language:Japanese', 'collection:sirsi'] }

  context 'blocking ブロック化 (katakana-kanji mix)', jira: 'VUF-2695' do
    context 'pending a discussion about how much we should be stemming with text_ja', pending: :fixme do
      it_behaves_like 'expected result size', 'title', 'ブロック化', 15, 20
    end
    it_behaves_like 'best matches first', 'title', 'ブロック化', '9855019', 1
  end
  context 'buddhism', jira: ['VUF-2724', 'VUF-2725'] do
    # First char of traditional doesn't translate to first char of modern with ICU traditional->simplified
    # (traditional and simplified are the same;  modern is different)
    # (see also japanese han variants spec)
    it_behaves_like 'both scripts get expected result size', 'title', 'traditional', '佛教', 'modern', '仏教', 3000, 3500
    it_behaves_like 'matches in vern short titles first', 'title', '佛教', /(佛|仏)(教|敎)/, 100  # trad
    it_behaves_like 'matches in vern short titles first', 'title', '仏教', /(佛|仏)(教|敎)/, 15  # modern
    it_behaves_like 'matches in vern short titles first', 'title', '仏教', /^(佛|仏)(教|敎)[^[[:alnum:]]]*$/, 3 # exact title match
    it_behaves_like 'matches in vern short titles first', 'title', '仏教', /^(佛|仏)(教|敎).*$/, 7 # title starts w match
    context 'w lang limit' do
      # trad
      it_behaves_like 'result size and vern short title matches first', 'title', '佛教', 1400, 1550, /(佛|仏)(教|敎)/, 100, lang_limit
      # modern
      it_behaves_like 'result size and vern short title matches first', 'title', '仏教', 1400, 1550, /(佛|仏)(教|敎)/, 15, lang_limit
    end
  end
  context 'editorial' do
    it_behaves_like 'both scripts get expected result size', 'title', 'traditional', '論說', 'modern', '論説', 200, 300, lang_limit
    it_behaves_like 'matches in vern short titles first', 'title', '論説', /論說|論説/, 16, lang_limit
    it_behaves_like 'matches in vern titles first', 'title', '論説', /論說|論説/, 20, lang_limit
    it_behaves_like 'matches in vern titles', 'title', '論說', /論說/, 20, lang_limit # traditional script is in results
    # no 説 (modern) in results
    it 'should not sort series titles matches before main titles' do
      expect(cjk_query_resp_ids('title', '論説', 'fq' => 'language:Japanese')).not_to include('6808627')
    end
  end
  context 'February 26 Incident', jira: 'VUF-2755' do
    it_behaves_like 'expected result size', 'title', '二・二六事件', 60, 90
    it_behaves_like 'best matches first', 'title', '二・二六事件', '6279752', 1 # all in 245a, but as ニ・  ニ六事件・
    it_behaves_like 'best matches first', 'title', '二・二六事件', '4174677', 4 # in 246
  end
  context 'grandpa  おじいさん (hiragana)', jira: 'VUF-2715' do
    it_behaves_like 'both scripts get expected result size', 'title', 'hiragana', 'おじいさん', 'katagana', 'オジいサン', 5, 15
    it_behaves_like 'matches in vern short titles first', 'title', 'おじいさん', /おじいさん|オジいサン/, 2
    it_behaves_like 'matches in vern titles first', 'title', 'おじいさん', /おじいさん|オジいサン/, 2
    it_behaves_like 'matches in vern titles', 'title', 'おじいさん', /おじいさん/, 11 # hiragana script is in results
    it_behaves_like 'matches in vern titles', 'title', 'おじいさん', /オジいサン/, 11 # katagana script is in results
  end
  context "'hiragana'  ひらがな", jira: 'VUF-2693' do
    it_behaves_like 'expected result size', 'title', 'ひらがな', 4, 15
    # new record 12320088 has ひらがな in 245a and pushes record 4217219 down results ranking
    context 'the new relevancy doesnt seem as good due to stemming.', pending: :fixme do
      it_behaves_like 'best matches first', 'title', 'ひらがな', %w(4217219 12142832), 5 # 4217219 in 245b and 12142832 in 245a
    end
  end
  context 'historical records' do
    it_behaves_like 'both scripts get expected result size', 'title', 'traditional', '古記錄', 'modern', '古記録', 120, 200
    it_behaves_like 'both scripts get expected result size', 'title', 'traditional', '古記錄', 'modern', '古記録', 110, 140, lang_limit
    it_behaves_like 'matches in vern short titles first', 'title', '古記録', /古記錄|古記録/, 24, lang_limit
    it_behaves_like 'matches in vern titles first', 'title', '古記録', /古記錄|古記録/, 26, lang_limit # 4647977 at 27, which doesn't match 3 together
  end
  context "'humorous'  ユニークな", jira: 'VUF-2753' do
    it_behaves_like 'expected result size', 'title', 'ユニークな', 2, 5
    it_behaves_like 'best matches first', 'title', 'ユニークな', '6668838', 1 # beginning of 245a
    it_behaves_like 'best matches first', 'title', 'ユニークな', '4198351', 2 # middle of 245a
  end
  context 'japanese art works ref encyclopedia', jira: 'VUF-2698' do
    it_behaves_like 'expected result size', 'title', '日本美術作品レファレンス事典', 13, 20
    it_behaves_like 'matches in vern short titles first', 'title', '日本美術作品レファレンス事典', /^日本美術作品レファレンス事典[[:punct:]]*$/, 8
    # 9th result is without the first 2 chars
  end
  context 'lantern', jira: 'VUF-2703' do
    it_behaves_like 'expected result size', 'title', 'ちょうちん', 1, 10
    it_behaves_like 'best matches first', 'title', 'ちょうちん', '10181601', 2 # in 245a
    it_behaves_like 'matches in vern titles', 'title', 'ちょうちん', /ちょう/, 2 # sub-term
  end
  context 'lantern shop', jira: 'VUF-2702' do
    it_behaves_like 'expected result size', 'title', 'ちょうちん屋', 1, 3
    it_behaves_like 'best matches first', 'title', 'ちょうちん屋', '10181601', 1 # in 245a
  end
  context 'manga/comics', jira: ['VUF-2734', 'VUF-2735'] do
    context 'pending kana normalization', skip: :fixme do
      it_behaves_like 'both scripts get expected result size', 'title', 'hiragana', 'まんが', 'katakana', 'マンガ', 250, 450
    end
    it_behaves_like 'matches in vern short titles first', 'title', 'まんが', /まんが|マンガ/, 100
    it_behaves_like 'matches in vern titles', 'title', 'まんが', /まんが/, 20 # hiragana script is in results
    it_behaves_like 'matches in vern titles', 'title', 'マンガ', /マンガ/, 20 # katagana script is in results
    it_behaves_like 'both scripts get expected result size', 'title', 'traditional', '漫畫', 'modern', ' 漫画', 275, 525
    it_behaves_like 'matches in vern short titles first', 'title', '漫画', /漫画|漫畫/, 50
    it_behaves_like 'matches in vern titles', 'title', '漫画', /漫画/, 20 # modern script is in results
    it_behaves_like 'matches in vern titles', 'title', '漫畫', /漫畫/, 20 # traditional script is in results
  end
  context 'painting dictionary', jira: 'VUF-2697' do
    # FIXME:  first character of traditional doesn't translate to first char of
    #  modern with ICU traditional->simplified    (see also japanese han variants)
    context 'traditional' do
      it_behaves_like 'good results for query', 'title', '繪畫辞典', 1, 1, '8448289', 1
    end
    context 'modern' do
      it_behaves_like 'expected result size', 'title', '絵画辞典', 0, 1
    end
  end
  context 'people traveling overseas encyclopedia', jira: 'VUF-2084' do
    it_behaves_like 'expected result size', 'title', '海外渡航者人物事典', 1, 1
    it_behaves_like 'best matches first', 'title', '海外渡航者人物事典', '5746725', 1
  end
  context 'pseudonym usage (modern, mixed scripts)' do
    it_behaves_like 'good results for query', 'title', '近世仮名遣い', 1, 1, '7926218', 1
    it_behaves_like 'good results for query', 'title', '近世仮名  遣い', 1, 1, '7926218', 1
    it_behaves_like 'good results for query', 'title', '近世仮名  遣い論の研究', 1, 1, '7926218', 1
    it_behaves_like 'good results for query', 'title', '近世仮名遣い論の研究', 1, 1, '7926218', 1
  end
  context 'sports  スポーツ (katakana)', jira: 'VUF-2738' do
    it_behaves_like 'expected result size', 'title', 'スポーツ', 34, 80
    it_behaves_like 'matches in vern short titles first', 'title', 'スポーツ', /スポーツ/, 20
  end
  context 'Study of Buddhism', jira: ['VUF-2732', 'VUF-2733'] do
    # First char of traditional doesn't translate to first char of modern with ICU traditional->simplified
    # (see also japanese han variants for plain buddhism)
    it_behaves_like 'both scripts get expected result size', 'title', 'traditional', '佛教學', 'modern', '仏教学', 100, 200
    it_behaves_like 'both scripts get expected result size', 'title', 'traditional', '佛教學', 'modern', '仏教学', 40, 70, lang_limit
    it_behaves_like 'matches in vern short titles first', 'title', '佛教學', /(佛|仏)(教|敎)(學|学)/, 15, lang_limit # trad
    it_behaves_like 'matches in vern short titles first', 'title', '仏教学', /(佛|仏)(教|敎)(學|学)/, 15, lang_limit # modern
    it_behaves_like 'matches in vern short titles first', 'title', '佛教學', /(佛|仏)(教|敎)(學|学)/, 15 # trad
    it_behaves_like 'matches in vern short titles first', 'title', '仏教学', /(佛|仏)(教|敎)(學|学)/, 15 # modern
    it_behaves_like 'best matches first', 'title', '佛教學', '7813279', 1
    it_behaves_like 'best matches first', 'title', '佛教學', '7641164', 10  # in Korean!
    it_behaves_like 'best matches first', 'title', '仏教学', '7813279', 1
    it_behaves_like 'best matches first', 'title', '仏教学', '7641164', 10  # in Korean!
  end
  context 'survey/investigation', jira: 'VUF-2727' do
    # second trad char isn't translated to modern with ICU trad -> simp
    # (see also japanese han variants)
    it_behaves_like 'both scripts get expected result size', 'title', 'traditional', ' 調查', 'modern', '調査', 7500, 8500
    # exact title match
    it_behaves_like 'matches in vern short titles first', 'title', '調查', /^(調查|調査)[^[[:alnum:]]]*$/, 1 # trad
    it_behaves_like 'matches in vern short titles first', 'title', '調査', /^(調查|調査)[^[[:alnum:]]]*$/, 1 # mod
    context 'w lang limit' do
      it_behaves_like 'both scripts get expected result size', 'title', 'traditional', ' 調查', 'modern', '調査', 4000, 4200, lang_limit
      it_behaves_like 'matches in vern short titles first', 'title', '調查', /(調查|調査)/, 40, lang_limit # trad
      it_behaves_like 'matches in vern short titles first', 'title', '調査', /(調查|調査)/, 50, lang_limit # modern
      # exact title match
      it_behaves_like 'matches in vern short titles first', 'title', '調查', /^(調查|調査)[^[[:alnum:]]]*$/, 1
      it_behaves_like 'matches in vern short titles first', 'title', '調査', /^(調查|調査)[^[[:alnum:]]]*$/, 1
    end
  end
  context 'tale', jira: ['VUF-2705', 'VUF-2743', 'VUF-2742', 'VUF-2740'] do
    # (see also japanese hiragana - han spec)
    context 'hiragana', jira: ['VUF-2705', 'VUF-2743'] do
      it_behaves_like 'expected result size', 'title', 'ものがたり', 70, 100
      it_behaves_like 'matches in vern short titles first', 'title', 'ものがたり', /ものがたり/, 20
    end
    context 'kanji', jira: ['VUF-2705', 'VUF-2742', 'VUF-2740'] do
      # Japanese do not use 语 (2nd char as simplified chinese) but rather 語 (trad char)
      it_behaves_like 'both scripts get expected result size', 'title', 'traditional', '物語', 'chinese simp', '物语', 2700, 2850
      it_behaves_like 'matches in vern titles first', 'title', '物語', /物語/, 13 # 14 is 4223454 which has it in 240a
      it_behaves_like 'matches in vern titles first', 'title', '物語', /物語/, 100, lang_limit
    end
  end
  context 'Tsu child remains lantern shop', jira: 'VUF-2701' do
    # hiragana, kanji, katakana scripts all here
    it_behaves_like 'expected result size', 'title', 'ちょうちん屋のままッ子', 1, 1
    it_behaves_like 'best matches first', 'title', 'ちょうちん屋のままッ子', '10181601', 1   # in 245a
  end
  context 'twin story of the swan (mixed katakana/hiragana)', jira: 'VUF-2704' do
    it_behaves_like 'expected result size', 'title', '白鳥のふたごものがたり', 1, 1
    it_behaves_like 'best matches first', 'title', '白鳥のふたごものがたり', '10185778', 1   # in 245a
  end
  context 'weather', jira: 'VUF-2756' do
    # (see japanese han variants)
  end
  context 'weekly', skip: :fixme do
    # (see also japanese han variants) 2nd modern char isn't same as translated simplified han (modern != simplified)
    it_behaves_like 'both scripts get expected result size', 'title', 'traditional', '週刋', 'modern', '週刊', 80, 110, lang_limit
    it_behaves_like 'matches in vern short titles first', 'title', '週刊', /週(刊|刋)/, 20, lang_limit # modern
    it_behaves_like 'matches in vern short titles first', 'title', '週刋', /週(刊|刋)/, 20, lang_limit # trad
  end
  context 'TPP', jira: 'VUF-2696' do
    it_behaves_like 'expected result size', 'title', 'TPP', 30, 75
    it_behaves_like 'expected result size', 'title', 'TPP', 20, 50, lang_limit
    it_behaves_like 'matches in vern short titles first', 'title', 'TPP', /TPP/, 6, lang_limit
    it_behaves_like 'matches in vern titles first', 'title', 'TPP', /TPP/, 7, lang_limit
    # 8th result is a series title
  end
end
