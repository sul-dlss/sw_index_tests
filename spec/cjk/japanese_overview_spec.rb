# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Japanese Overview", :japanese => true, :fixme => true do
  
  shared_examples_for "expected result size" do | query_type, query, min, max, solr_params |
    it "#{query_type} search has #{(min == max ? min : "between #{min} and #{max}")} results" do
      resp = cjk_query_resp_ids(query_type, query, solr_params ||= {})
      if min == max
        resp.should have_exactly(min).results
      else
        resp.should have_at_least(min).results
        resp.should have_at_most(max).results
      end
    end
  end

  shared_examples_for "search results are same size" do | query_type, query1, query2, solr_params |
    it "both #{query_type} searches have same result size" do
      resp1 = cjk_query_resp_ids(query_type, query1, solr_params ||= {})
      resp2 = cjk_query_resp_ids(query_type, query2, solr_params ||= {})
      resp1.should have_the_same_number_of_results_as resp2
    end
  end
  
  shared_examples_for "both scripts get expected result size" do | query_type, script_name1, query1, script_name2, query2, min, max, solr_params |
    it_behaves_like "search results are same size", query_type, query1, query2, solr_params
    context "#{script_name1}: #{query1}" do
      it_behaves_like "expected result size", query_type, query1, min, max, solr_params
    end
    context "#{script_name2}: #{query2}" do
      it_behaves_like "expected result size", query_type, query2, min, max, solr_params
    end
  end
  
  shared_examples_for "best matches first" do | query_type, query, id_list, num, solr_params |
    it "finds #{id_list.inspect} in first #{num} results" do
      resp = cjk_query_resp_ids(query_type, query, solr_params ||= {})
      resp.should include(id_list).in_first(num).results
    end
  end
  shared_examples_for "matches in short titles first" do | query_type, query, regex, num, solr_params |
    it "finds #{regex} in first #{num} titles" do
      solr_params ||= {}
      solr_params.merge!('rows'=>num) if num > 20
      resp = solr_response({'q' => cjk_q_arg(query_type, query), 'fl'=>'id,vern_title_245a_display', 'facet'=>false}.merge(solr_params))
      resp.should include({'vern_title_245a_display' => regex}).in_each_of_first(num)
    end
  end
  shared_examples_for "matches in titles first" do | query_type, query, regex, num, solr_params |
    it "finds #{regex} in first #{num} titles" do
      solr_params ||= {}
      solr_params.merge!('rows'=>num) if num > 20
      resp = solr_response({'q' => cjk_q_arg(query_type, query), 'fl'=>'id,vern_title_full_display', 'facet'=>false}.merge(solr_params))
      resp.should include({'vern_title_full_display' => regex}).in_each_of_first(num)
    end
  end
  shared_examples_for "matches in titles" do | query_type, query, regex, num, solr_params |
    it "finds #{regex} in titles" do
      solr_params ||= {}
      solr_params.merge!('rows'=>num) if num > 20
      resp = solr_response({'q' => cjk_q_arg(query_type, query), 'fl'=>'id,vern_title_full_display', 'facet'=>false}.merge(solr_params))
      resp.should include({'vern_title_full_display' => regex})
    end
  end
  

  #--- end shared examples ---------------------------------------------------

  lang_limit = {'fq'=>'language:Japanese'}
  context "title searches" do
    context "blocking ブロック化 (katakana-kanji mix)", :jira => 'VUF-2695' do
      it_behaves_like "expected result size", 'title', 'ブロック化', 1, 15
      it_behaves_like "best matches first", 'title', 'ブロック化', '9855019', 1
    end
    context "buddhism", :jira => ['VUF-2724', 'VUF-2725'] do
      it_behaves_like "both scripts get expected result size", 'title', 'traditional', '佛教', 'modern', '仏教', 1150, 2000
    end
    context "editorial" do
      it_behaves_like "both scripts get expected result size", 'title', 'traditional', '論說', 'modern', '論説', 50, 100, lang_limit
      it_behaves_like "matches in short titles first", 'title', '論説', /論說|論説/, 16, lang_limit
      it_behaves_like "matches in titles first", 'title', '論説', /論說|論説/, 20, lang_limit
      it_behaves_like "matches in titles", 'title', '論說', /論說/, 20, lang_limit # traditional script is in results
      # no 説 (modern) in results
      resp = cjk_query_resp_ids('title', '論説', lang_limit)
      it "should not sort series titles matches before main titles" do
        resp.should_not include('6808627')
      end
    end
    context "grandpa  おじいさん (hiragana)", :jira => 'VUF-2715' do
      it_behaves_like "both scripts get expected result size", 'title', 'hiragana', 'おじいさん', 'katagana', 'オジいサン', 10, 11
      it_behaves_like "matches in short titles first", 'title', 'おじいさん', /おじいさん|オジいサン/, 2
      it_behaves_like "matches in titles first", 'title', 'おじいさん', /おじいさん|オジいサン/, 2
      it_behaves_like "matches in titles", 'title', 'おじいさん', /おじいさん/, 11 # hiragana script is in results
      it_behaves_like "matches in titles", 'title', 'おじいさん', /オジいサン/, 11 # katagana script is in results
    end
    context "'hiragana'  ひらがな", :jira => 'VUF-2693' do
      it_behaves_like "expected result size", 'title', 'ひらがな', 4, 26
      it_behaves_like "best matches first", 'title', 'ひらがな', ['4217219', '9252490'], 3   # both in 245b
    end
    context "historical records" do
      it_behaves_like "both scripts get expected result size", 'title', 'traditional', '古記錄', 'modern', '古記録', 120, 200
      it_behaves_like "both scripts get expected result size", 'title', 'traditional', '古記錄', 'modern', '古記録', 110, 126, lang_limit
      it_behaves_like "matches in short titles first", 'title', '古記録', /古記錄|古記録/, 24, lang_limit  
      it_behaves_like "matches in titles first", 'title', '古記録', /古記錄|古記録/, 26, lang_limit  # 4647977 at 27, which doesn't match 3 together
    end
    context "japanese art works ref encyclopedia", :jira => 'VUF-2698' do
      it_behaves_like "expected result size", 'title', '日本美術作品レファレンス事典', 8, 9
      it_behaves_like "matches in short titles first", 'title', '日本美術作品レファレンス事典', /日本美術作品レファレンス事典/, 9
    end
    context "lantern", :jira => 'VUF-2703' do
      it_behaves_like "expected result size", 'title', 'ちょうちん', 1, 3
      it_behaves_like "best matches first", 'title', 'ちょうちん', '10181601', 1   # in 245a
      it_behaves_like "matches in titles", 'title', 'ちょうちん', /ちょう/, 2 # sub-term
    end
    context "lantern shop", :jira => 'VUF-2702' do
      it_behaves_like "expected result size", 'title', 'ちょうちん屋', 1, 1
      it_behaves_like "best matches first", 'title', 'ちょうちん', '10181601', 1   # in 245a
    end
    context "manga/comics", :jira => ['VUF-2734', 'VUF-2735'] do
      it_behaves_like "both scripts get expected result size", 'title', 'hiragana', 'まんが', 'katakana', 'マンガ', 210, 275      
      it_behaves_like "matches in short titles first", 'title', 'まんが', /まんが|マンガ/, 100
      it_behaves_like "matches in titles", 'title', 'まんが', /まんが/, 20 # hiragana script is in results
      it_behaves_like "matches in titles", 'title', 'マンガ', /マンガ/, 20 # katagana script is in results
      it_behaves_like "both scripts get expected result size", 'title', 'traditional', '漫畫', 'modern', ' 漫画', 237, 400
      it_behaves_like "matches in short titles first", 'title', '漫画', /漫画|漫畫/, 150
      it_behaves_like "matches in titles", 'title', '漫画', /漫画/, 20 # modern script is in results
      it_behaves_like "matches in titles", 'title', '漫畫', /漫畫/, 20 # traditional script is in results
    end
    context "painting dictionary", :jira => 'VUF-2697' do
# FIXME:  First character of traditional translates to diff char than first char of modern
#      it_behaves_like "both scripts get expected result size", 'title', 'traditional', '繪畫辞典', 'modern', '絵画辞典', 1, 1
      it_behaves_like "best matches first", 'title', '繪̄畫辞典', '8448289', 1
#      it_behaves_like "best matches first", 'title', '絵画辞典', '8448289', 1
    end
    context "people traveling overseas encyclopedia", :jira => 'VUF-2084' do
      it_behaves_like "expected result size", 'title', '海外渡航者人物事典', 1, 1
      it_behaves_like "best matches first", 'title', '海外渡航者人物事典', '5746725', 1
    end
    context "pseudonym usage (modern, mixed)" do
      it_behaves_like "expected result size", 'title', '近世仮名遣い', 1, 1
      it_behaves_like "best matches first", 'title', '近世仮名遣い', '7926218', 1
    end
    context "sports  スポーツ (katakana)", :jira => 'VUF-2738' do
      it_behaves_like "expected result size", 'title', 'スポーツ', 34, 50
      it_behaves_like "matches in short titles first", 'title', 'スポーツ', /スポーツ/, 20
    end
    context "Study of Buddhism", :jira => ['VUF-2732', 'VUF-2733'] do
# FIXME:  first trad character isn't translated to modern - these should be equivalent    
#      it_behaves_like "both scripts get expected result size", 'title', 'modern', ' 仏教学', 'traditional', '佛教學', 50, 200
      # modern
      it_behaves_like "expected result size", 'title', '仏教学', 19, 125
      it_behaves_like "matches in short titles first", 'title', '仏教学', /仏教学/, 3
      # FIXME:  starting with result 4, relevance isn't great
      # traditional
      it_behaves_like "expected result size", 'title', '佛教學', 150, 175
      it_behaves_like "matches in short titles first", 'title', '佛教學', /佛教學/, 3
      it_behaves_like "best matches first", 'title', '佛教學', '7813279', 1
      it_behaves_like "best matches first", 'title', '佛教學', '7641164', 2  # in Korean!
      # FIXME:  starting with result 3, relevance isn't great
    end
    context "survey/investigation", :jira => 'VUF-2727' do
# FIXME:  second trad char isn't translated to modern - these should be equivalent
#      it_behaves_like "both scripts get expected result size", 'title', 'traditional', '調查', 'modern', '調査', 4500, 4750
#      it_behaves_like "both scripts get expected result size", 'title', 'traditional', '調查', 'modern', '調査', 4500, 4750, lang_limit
      # modern
      it_behaves_like "expected result size", 'title', '調査', 59, 65, lang_limit
      it_behaves_like "matches in short titles first", 'title', '調査', /調査/, 25, lang_limit
      it_behaves_like "matches in titles first", 'title', '調査', /調査/, 30, lang_limit
      # traditional
      it_behaves_like "expected result size", 'title', '調查', 4450, 4700, lang_limit
      it_behaves_like "matches in short titles first", 'title', '調查', /調查/, 100, lang_limit
    end
    context "tale", :jira => ['VUF-2705', 'VUF-2743', 'VUF-2742', 'VUF-2740'] do
      context "hiragana", :jira => ['VUF-2705', 'VUF-2743'] do
        it_behaves_like "expected result size", 'title', 'ものがたり', 60, 83
        it_behaves_like "matches in short titles first", 'title', 'ものがたり', /ものがたり/, 35
      end
      context "kanji", :jira => ['VUF-2705', 'VUF-2742', 'VUF-2740'] do
        # note:  Japanese do not use 语 (2nd char as simplified chinese) but rather 語
        it_behaves_like "both scripts get expected result size", 'title', 'traditional', '物語', 'chinese simp', '物语', 2351, 2455
        it_behaves_like "matches in titles first", 'title', '物語', /物語/, 13  # 14 is 4223454 which has it in 240a
      end
    end
    context "Tsu child remains lantern shop", :jira => 'VUF-2701' do
      it_behaves_like "expected result size", 'title', 'ちょうちん屋のままッ子', 1, 1
    end
    context "twin story of the swan (mixed katakana/hiragana)", :jira => 'VUF-2704' do
      it_behaves_like "expected result size", 'title', '白鳥のふたごものがたり', 1, 1
    end
    context "weekly" do
      it_behaves_like "both scripts get expected result size", 'title', 'modern', '週刊', 'traditional', '週刋', 83, 440
      # TODO:  want Japanese langauge facet selected
    end
    context "TPP", :jira => 'VUF-2696' do
      it_behaves_like "expected result size", 'title', 'TPP', 11, 12
    end
  end # title searches

  context "author searches" do
    context "buddhism", :jira => 'VUF-2723' do
      it_behaves_like "both scripts get expected result size", 'author', 'traditional', '佛教', 'modern', '仏教', 96, 300
    end
    context "高橋 (common personal name)", :jira => 'VUF-2711' do
      it_behaves_like "expected result size", 'author', '高橋', 1021, 1050
    end
    context "personal name  契沖" do
      it_behaves_like "both scripts get expected result size", 'author', 'kanji', '契沖', 'hiragana', 'けいちゅう', 5, 5
    end
    context "personal name: kanji surname  釘貫 (surname of 釘貫亨)" do
      it_behaves_like "expected result size", 'author', '釘貫', 1, 1
      it_behaves_like "expected result size", 'author', '釘貫亨', 1, 1
    end
    context "South Manchurian Railroad Company", :jira => ['VUF-2736', 'VUF-2739'] do
      it_behaves_like "both scripts get expected result size", 'author', 'modern', '南満州鉄道株式会社', 'traditional', '南滿洲鐵道株式會社', 400, 700
    end
  end # author searches
  
  context "everything searches" do
    context "buddhism", :jira => ['VUF-2724', 'VUF-2725'] do
      it_behaves_like "both scripts get expected result size", 'everything', 'traditional', '佛教', 'modern', '仏教', 814, 2000
    end
    context 'Edo (old name for Tokyo)', :jira => 'VUF-2726' do
      it_behaves_like "both scripts get expected result size", 'everything', 'traditional', '江戶', 'modern', '江戸', 3, 2000
    end
    context "Japan   China   thought", :jira => 'VUF-2737' do
      it_behaves_like "expected result size", 'everything', '日本   中国   思想', 52, 55
    end
    context '(local/regional society)', :jira => 'VUF-2717' do
      it_behaves_like "expected result size", 'everything', '"地域社会', 400, 425
    end
    context "manchuria" do
      it_behaves_like "both scripts get expected result size", 'everything', 'katakana', 'マンチュリヤ', 'kanji', '満洲', 350, 400
      context "katakana", :jira => 'VUF-2712' do
        it_behaves_like "expected result size", 'everything', ' マンチュリヤ', 1, 2
      end
      context "kanji", :jira => 'VUF-2713' do
        it_behaves_like "expected result size", 'everything', "満洲", 362, 415
      end
    end
    context "outside of Japan", :jira => 'VUF-2699' do
      it_behaves_like "expected result size", 'everything', '日外', 2000, 2450
    end
    context "publisher's name starting with 'outside of Japan'", :jira => 'VUF-2699' do
      it_behaves_like "expected result size", 'everything', '日外アソシエーツ', 455, 525
    end
    context "seven wonders", :jira => 'VUF-2710' do
      it_behaves_like "expected result size", 'everything', '七不思議', 3, 3
    end
    context "seven wonders of sassafras springs  ササフラス・スプリングスの七不思議", :jira => 'VUF-2709' do
      it_behaves_like "expected result size", 'everything', 'ササフラス・スプリングスの七不思議', 1, 1
    end
    context "survey/investigation", :jira => 'VUF-2727' do
      it_behaves_like "both scripts get expected result size", 'everything', 'traditional', ' 調查', 'modern', '調査', 100, 12000
    end
    context "TPP", :jira => 'VUF-2694' do
      it_behaves_like "expected result size", 'everything', 'TPP', 69, 80
    end    
  end # everything searches
  
  context "phrases" do
    context '(local/regional society)', :jira => 'VUF-2717' do
      it_behaves_like "expected result size", 'everything', '""地域社会"', 266, 300
    end
    context '(local/regional society - I see from)', :jira => 'VUF-2716' do
      # TODO:  want 10221504, but dont get it ...
      it_behaves_like "expected result size", 'everything', '”地域社会から見る”', 3, 3
    end
    context '(local/regional society - all of Japan)', :jira => 'VUF-2714' do
      it_behaves_like "expected result size", 'everything', '"地域社会から見る帝国日本と植民地"', 1, 1
    end
  end  # phrases
  
  context "mixed scripts" do
    # katakana-kanji:  see 'blocking' title search, :jira => 'VUF-2695'
    # hiragana-kanji:  see 'lantern shop' title search, :jira => 'VUF-2702'
    # modern mixed:  see  pseudonum title search  近世仮名遣い
    # hiragana, kanji, katakana:  see tsu child remains lantern shop title search  ちょうちん屋のままッ子, :jira => 'VUF-2701'
    # hiragana-katakana:  see twin story of the swan title search 白鳥のふたごものがたり, :jira=> 'VUF-2704
    # seven wonders everything search 七不思議  VUF-2710
    # seven wonders of sassafras springs everything search  ササフラス・スプリングスの七不思議  VUF-2709

  end # mixed scripts

end