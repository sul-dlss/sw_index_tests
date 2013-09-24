# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Japanese Title searches", :japanese => true do

  lang_limit = {'fq'=>'language:Japanese'}

  context "blocking ブロック化 (katakana-kanji mix)", :jira => 'VUF-2695' do
    it_behaves_like "expected result size", 'title', 'ブロック化', 12, 15
    it_behaves_like "best matches first", 'title', 'ブロック化', '9855019', 1
  end
  context "buddhism", :jira => 'VUF-2725' do
    # FIXME:  first character of traditional doesn't translate to first char of 
    #  modern with ICU traditional->simplified    (see also japanese han variants)
    context "traditional 佛教" do
      it_behaves_like "result size and vern short title matches first", 'title', '佛教', 1100, 1250, /佛教/, 100
      context "w lang limit" do
        it_behaves_like "result size and vern short title matches first", 'title', '佛教', 160, 175, /佛教/, 100, lang_limit
      end
    end
    context "modern 仏教" do
      it_behaves_like "result size and vern short title matches first", 'title', '仏教', 775, 850, /仏教/, 100
      exact_245a = ['6854317', '4162614', '6276328', '10243029', '10243045', '10243039']
      it_behaves_like "matches in vern short titles first", 'title', '仏教', /^仏教[^[[:alnum:]]]*$/, 3  # exact title match
      context "w lang limit" do
        it_behaves_like "result size and vern short title matches first", 'title', '仏教', 765, 825, /仏教/, 100, lang_limit
      end
    end
  end
  context "editorial" do
    it_behaves_like "both scripts get expected result size", 'title', 'traditional', '論說', 'modern', '論説', 50, 100, lang_limit
    it_behaves_like "matches in vern short titles first", 'title', '論説', /論說|論説/, 16, lang_limit
    it_behaves_like "matches in vern titles first", 'title', '論説', /論說|論説/, 20, lang_limit
    it_behaves_like "matches in vern titles", 'title', '論說', /論說/, 20, lang_limit # traditional script is in results
    # no 説 (modern) in results
    resp = cjk_query_resp_ids('title', '論説', lang_limit)
    it "should not sort series titles matches before main titles" do
      resp.should_not include('6808627')
    end
  end
  context "February 26 Incident", :jira => 'VUF-2755' do
    it_behaves_like "expected result size", 'title', 'ニ・ニ六事件', 2, 5
    it_behaves_like "best matches first", 'title', 'ニ・ニ六事件', '6325833', 1 # all in 245a, but as ニ・  ニ六事件・
    it_behaves_like "best matches first", 'title', 'ニ・ニ六事件', '6279541', 4 # in 246
    # other two results are not relevant:
    #  6617115 seems to confuse "ニ (= Japanese kana, romanized as 'ni')" which appears after "小作 (kosaku)" with "ニ (= number 2 in Kanji)
    #  6360442 seems to confuse "に (= Japanese kana, romanized as 'ni') which appears after "十六名 (jurokumei)" with "ニ (= number 2 in Kanji)"
  end
  context "grandpa  おじいさん (hiragana)", :jira => 'VUF-2715' do
    it_behaves_like "both scripts get expected result size", 'title', 'hiragana', 'おじいさん', 'katagana', 'オジいサン', 10, 12
    it_behaves_like "matches in vern short titles first", 'title', 'おじいさん', /おじいさん|オジいサン/, 2
    it_behaves_like "matches in vern titles first", 'title', 'おじいさん', /おじいさん|オジいサン/, 2
    it_behaves_like "matches in vern titles", 'title', 'おじいさん', /おじいさん/, 11 # hiragana script is in results
    it_behaves_like "matches in vern titles", 'title', 'おじいさん', /オジいサン/, 11 # katagana script is in results
  end
  context "'hiragana'  ひらがな", :jira => 'VUF-2693' do
    it_behaves_like "expected result size", 'title', 'ひらがな', 4, 10
    it_behaves_like "best matches first", 'title', 'ひらがな', ['4217219', '9252490'], 3   # both in 245b
  end
  context "historical records" do
    it_behaves_like "both scripts get expected result size", 'title', 'traditional', '古記錄', 'modern', '古記録', 120, 200
    it_behaves_like "both scripts get expected result size", 'title', 'traditional', '古記錄', 'modern', '古記録', 110, 126, lang_limit
    it_behaves_like "matches in vern short titles first", 'title', '古記録', /古記錄|古記録/, 24, lang_limit  
    it_behaves_like "matches in vern titles first", 'title', '古記録', /古記錄|古記録/, 26, lang_limit  # 4647977 at 27, which doesn't match 3 together
  end
  context "'humorous'  ユニークな", :jira => 'VUF-2753' do
    it_behaves_like "expected result size", 'title', 'ユニークな', 2, 5
    it_behaves_like "best matches first", 'title', 'ユニークな', '6668838', 1 # beginning of 245a
    it_behaves_like "best matches first", 'title', 'ユニークな', '4198351', 2  # middle of 245a
  end
  context "japanese art works ref encyclopedia", :jira => 'VUF-2698' do
    it_behaves_like "expected result size", 'title', '日本美術作品レファレンス事典', 8, 12
    it_behaves_like "matches in vern short titles first", 'title', '日本美術作品レファレンス事典', /^日本美術作品レファレンス事典[[:punct:]]*$/, 8
    # 9th result is without the first 2 chars
  end
  context "lantern", :jira => 'VUF-2703' do
    it_behaves_like "expected result size", 'title', 'ちょうちん', 1, 3
    it_behaves_like "best matches first", 'title', 'ちょうちん', '10181601', 1   # in 245a
    it_behaves_like "matches in vern titles", 'title', 'ちょうちん', /ちょう/, 2 # sub-term
  end
  context "lantern shop", :jira => 'VUF-2702' do
    it_behaves_like "expected result size", 'title', 'ちょうちん屋', 1, 1
    it_behaves_like "best matches first", 'title', 'ちょうちん', '10181601', 1   # in 245a
  end
  context "manga/comics", :jira => ['VUF-2734', 'VUF-2735'] do
    it_behaves_like "both scripts get expected result size", 'title', 'hiragana', 'まんが', 'katakana', 'マンガ', 210, 275      
    it_behaves_like "matches in vern short titles first", 'title', 'まんが', /まんが|マンガ/, 100
    it_behaves_like "matches in vern titles", 'title', 'まんが', /まんが/, 20 # hiragana script is in results
    it_behaves_like "matches in vern titles", 'title', 'マンガ', /マンガ/, 20 # katagana script is in results
    it_behaves_like "both scripts get expected result size", 'title', 'traditional', '漫畫', 'modern', ' 漫画', 237, 400
    it_behaves_like "matches in vern short titles first", 'title', '漫画', /漫画|漫畫/, 150
    it_behaves_like "matches in vern titles", 'title', '漫画', /漫画/, 20 # modern script is in results
    it_behaves_like "matches in vern titles", 'title', '漫畫', /漫畫/, 20 # traditional script is in results
  end
  context "painting dictionary", :jira => 'VUF-2697' do
    # FIXME:  first character of traditional doesn't translate to first char of 
    #  modern with ICU traditional->simplified    (see also japanese han variants)
    context "traditional" do
      it_behaves_like "good results for query", 'title', '繪畫辞典', 1, 1, '8448289', 1
    end
    context "modern" do
      it_behaves_like "expected result size", 'title', '絵画辞典', 0, 1
    end
  end
  context "people traveling overseas encyclopedia", :jira => 'VUF-2084' do
    it_behaves_like "expected result size", 'title', '海外渡航者人物事典', 1, 1
    it_behaves_like "best matches first", 'title', '海外渡航者人物事典', '5746725', 1
  end
  context "pseudonym usage (modern, mixed scripts)" do
    it_behaves_like "good results for query", 'title', '近世仮名遣い', 1, 1, '7926218', 1
    it_behaves_like "good results for query", 'title', '近世仮名  遣い', 1, 1, '7926218', 1
    it_behaves_like "good results for query", 'title', '近世仮名  遣い論の研究', 1, 1, '7926218', 1
    it_behaves_like "good results for query", 'title', '近世仮名遣い論の研究', 1, 1, '7926218', 1
  end
  context "sports  スポーツ (katakana)", :jira => 'VUF-2738' do
    it_behaves_like "expected result size", 'title', 'スポーツ', 34, 50
    it_behaves_like "matches in vern short titles first", 'title', 'スポーツ', /スポーツ/, 20
  end
  context "Study of Buddhism", :jira => ['VUF-2732', 'VUF-2733'] do
    # FIXME:  first trad character isn't translated to modern - these should be equivalent
    # (see also japanese han variants)  
    context "modern" do
      it_behaves_like "expected result size", 'title', '仏教学', 100, 135
      it_behaves_like "matches in vern short titles first", 'title', '仏教学', /仏教学/, 8
    end
    context "traditional" do
      it_behaves_like "expected result size", 'title', '佛教學', 150, 175
      it_behaves_like "matches in vern short titles first", 'title', '佛教學', /佛教學/, 3
      it_behaves_like "best matches first", 'title', '佛教學', '7813279', 1
      it_behaves_like "best matches first", 'title', '佛教學', '7641164', 2  # in Korean!
    end
  end
  context "survey/investigation", :jira => 'VUF-2727' do
    # FIXME:  second trad char isn't translated to modern - these should be equivalent
    # (see also japanese han variants)
    context "modern" do
      it_behaves_like "expected result size", 'title', '調査', 55, 65, lang_limit
      it_behaves_like "matches in vern short titles first", 'title', '調査', /調査/, 25, lang_limit
      it_behaves_like "matches in vern titles first", 'title', '調査', /調査/, 30, lang_limit
    end
    context "traditional" do
      it_behaves_like "expected result size", 'title', '調查', 4450, 4700, lang_limit
      it_behaves_like "matches in vern short titles first", 'title', '調查', /調查/, 100, lang_limit
    end
  end
  context "tale", :jira => ['VUF-2705', 'VUF-2743', 'VUF-2742', 'VUF-2740'] do
    # (see also japanese hiragana - han spec)
    context "hiragana", :jira => ['VUF-2705', 'VUF-2743'] do
      it_behaves_like "expected result size", 'title', 'ものがたり', 60, 83
      it_behaves_like "matches in vern short titles first", 'title', 'ものがたり', /ものがたり/, 35
    end
    context "kanji", :jira => ['VUF-2705', 'VUF-2742', 'VUF-2740'] do
      # FIXME:  Japanese do not use 语 (2nd char as simplified chinese) but rather 語
      # (see also japanese han variants)
      it_behaves_like "both scripts get expected result size", 'title', 'traditional', '物語', 'chinese simp', '物语', 2351, 2455
      it_behaves_like "matches in vern titles first", 'title', '物語', /物語/, 13  # 14 is 4223454 which has it in 240a
    end
  end
  context "Tsu child remains lantern shop", :jira => 'VUF-2701' do
    # hiragana, kanji, katakana scripts all here
    it_behaves_like "expected result size", 'title', 'ちょうちん屋のままッ子', 1, 1
    it_behaves_like "best matches first", 'title', 'ちょうちん屋のままッ子', '10181601', 1   # in 245a
  end
  context "twin story of the swan (mixed katakana/hiragana)", :jira => 'VUF-2704' do
    it_behaves_like "expected result size", 'title', '白鳥のふたごものがたり', 1, 1
    it_behaves_like "best matches first", 'title', '白鳥のふたごものがたり', '10185778', 1   # in 245a
  end
  context "weather", :jira => 'VUF-2756' do
    # FIXME:  2nd modern char isn't same as translate simplified han
    # (see also japanese han variants)
    it_behaves_like "both scripts get expected result size", 'title', 'traditional', '天氣', 'chinese', '天气', 10, 17
    context "modern" do
      it_behaves_like "expected result size", 'title', '天気', 2, 17
      it_behaves_like "matches in vern short titles first", 'title', '天気', /天気/, 2
    end
    context "traditional" do
      it_behaves_like "expected result size", 'title', '天氣', 10, 17
      it_behaves_like "matches in vern short titles first", 'title', '天氣', /(天氣|天气)/, 7
      it_behaves_like "matches in vern titles first", 'title', '天氣', /(天氣|天气)/, 9
    end
  end
  context "weekly" do
    # FIXME:  2nd trad char isn't translated to modern  (modern != simplified)
    # (see also japanese han variants)
    context "modern" do
      it_behaves_like "expected result size", 'title', '週刊', 73, 100, lang_limit
      it_behaves_like "matches in vern short titles first", 'title', '週刊', /週刊/, 15, lang_limit
    end
    context "traditional" do
      it_behaves_like "expected result size", 'title', '週刋', 9, 15, lang_limit
      it_behaves_like "matches in vern short titles first", 'title', '週刋', /週刋/, 2, lang_limit # 3rd hit, 6324070, matches in 730a
    end
  end
  context "TPP", :jira => 'VUF-2696' do
    it_behaves_like "expected result size", 'title', 'TPP', 11, 15
    it_behaves_like "expected result size", 'title', 'TPP', 6, 10, lang_limit
    it_behaves_like "matches in vern short titles first", 'title', 'TPP', /TPP/, 6, lang_limit
    it_behaves_like "matches in vern titles first", 'title', 'TPP', /TPP/, 7, lang_limit
    # 8th result is a series title
  end

end