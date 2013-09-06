# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'rspec-solr'

describe "Japanese Overview", :japanese => true, :fixme => true do
  
  shared_examples_for "expected result size" do | query_type, query, min, max |
    it "#{query_type} search should have #{(min == max ? min : "between #{min} and #{max}")} results" do
      case query_type
        when 'title'
          resp = solr_resp_doc_ids_only({'q' => cjk_title_q_arg(query)})
        when 'author'
          resp = solr_resp_doc_ids_only({'q' => cjk_author_q_arg(query)})
        else
          resp = solr_resp_doc_ids_only({'q' => cjk_everything_q_arg(query)})
      end
      if min == max
        resp.should have_exactly(min).results
      else
        resp.should have_at_least(min).results
        resp.should have_at_most(max).results
      end
    end
  end

  shared_examples_for "queries get same result size" do | query_type, query1, query2 |
    it "both #{query_type} searches should get same result size" do
      case query_type
        when 'title'
          resp1 = solr_resp_doc_ids_only({'q' => cjk_title_q_arg(query1)})
          resp2 = solr_resp_doc_ids_only({'q' => cjk_title_q_arg(query2)})
        when 'author'
          resp1 = solr_resp_doc_ids_only({'q' => cjk_author_q_arg(query1)})
          resp2 = solr_resp_doc_ids_only({'q' => cjk_author_q_arg(query2)})
        else
          resp1 = solr_resp_doc_ids_only({'q' => cjk_everything_q_arg(query1)})
          resp2 = solr_resp_doc_ids_only({'q' => cjk_everything_q_arg(query2)})
      end
      resp1.should have_the_same_number_of_results_as resp2
    end
  end
  
  shared_examples_for "both scripts get expected result size" do | query_type, script_name1, query1, script_name2, query2, min, max |
    it_behaves_like "queries get same result size", query_type, query1, query2
    context "#{script_name1}: #{query1}" do
      it_behaves_like "expected result size", query_type, query1, min, max
    end
    context "#{script_name2}: #{query2}" do
      it_behaves_like "expected result size", query_type, query2, max, max
    end
  end

  #--- end shared examples ---------------------------------------------------

  context "title searches" do
    context "blocking ブロック化 (katakana-kanji mix)", :jira => 'VUF-2695' do
      it_behaves_like "expected result size", 'title', 'ブロック化', 1, 15
    end
    context "buddhism", :jira => ['VUF-2724', 'VUF-2725'] do
      it_behaves_like "both scripts get expected result size", 'title', 'traditional', '佛教', 'modern', '仏教', 1150, 2000
    end
    context "editorial" do
      it_behaves_like "both scripts get expected result size", 'title', 'traditional', '論說', 'modern', '論説', 50, 100
      # TODO:  want Japanese langauge facet selected
    end
    context "grandpa  おじいさん (hiragana)", :jira => 'VUF-2715' do
      it_behaves_like "expected result size", 'title', 'おじいさん', 10, 11
    end
    context "'hiragana'  ひらがな", :jira => 'VUF-2693' do
      it_behaves_like "expected result size", 'title', 'ひらがな', 10, 26
    end
    context "historical records" do
      it_behaves_like "both scripts get expected result size", 'title', 'traditional', '古記錄', 'modern', '古記録', 120, 200
      # TODO:  want Japanese langauge facet selected
    end
    context "japanese art works ref encyclopedia", :jira => 'VUF-2698' do
      it_behaves_like "expected result size", 'title', '日本美術作品レファレンス事典', 8, 9
    end
    context "lantern", :jira => 'VUF-2703' do
      it_behaves_like "expected result size", 'title', 'ちょうちん', 1, 3
    end
    context "lantern shop", :jira => 'VUF-2702' do
      it_behaves_like "expected result size", 'title', 'ちょうちん屋', 1, 1
    end
    context "manga/comics", :jira => ['VUF-2734', 'VUF-2735'] do
      it_behaves_like "both scripts get expected result size", 'title', 'hiragana', 'まんが', 'katakana', 'マンガ', 210, 275      
      it_behaves_like "both scripts get expected result size", 'title', 'traditional', '漫畫', 'modern', ' 漫画', 237, 400
    end
    context "painting dictionary", :jira => 'VUF-2697' do
      it_behaves_like "both scripts get expected result size", 'title', 'traditional', '繪畫辞典', 'modern', '絵画辞典', 1, 1
    end
    context "people traveling overseas encyclopedia", :jira => 'VUF-2084' do
      it_behaves_like "expected result size", 'title', '海外渡航者人物事典', 1, 1
    end
    context "pseudonym usage (modern, mixed)" do
      it_behaves_like "expected result size", 'title', '近世仮名遣い', 1, 1
    end
    context "sports  スポーツ (katakana)", :jira => 'VUF-2738' do
      it_behaves_like "expected result size", 'title', 'スポーツ', 34, 50
    end
    context "Study of Buddhism", :jira => 'VUF-2732' do
      it_behaves_like "both scripts get expected result size", 'title', 'modern', ' 仏教学', 'traditional', '佛教學', 50, 200
    end
    context "survey/investigation", :jira => 'VUF-2727' do
      it_behaves_like "both scripts get expected result size", 'title', 'traditional', '調查', 'modern', '調査', 4500, 4750
      # TODO:  want Japanese langauge facet selected
    end
    context "people traveling overseas encyclopedia", :jira => ['VUF-2705', 'VUF-2743', 'VUF-2742', 'VUF-2740'] do
      context "hiragana", :jira => ['VUF-2705', 'VUF-2743'] do
        it_behaves_like "expected result size", 'title', 'ものがたり', 60, 83
      end
      context "kanji", :jira => ['VUF-2705', 'VUF-2742', 'VUF-2740'] do
        it_behaves_like "both scripts get expected result size", 'title', 'traditional', '物語', 'chinese simp', '物语', 2351, 2455
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
    context "South Manchurian Railroad Company" do
      it_behaves_like "both scripts get expected result size", 'author', 'modern', ' 南満州鉄道株式会社', 'traditional', '南滿洲鐵道株式會社', 522
    end
    context "personal name  契沖" do
      it_behaves_like "both scripts get expected result size", 'author', 'kanji', '契沖', 'hiragana', 'けいちゅう', 5
    end
    context "kanji surname  釘貫 (surname of 釘貫亨)" do
      it_behaves_like "expected result size", '釘貫', 'author', 1
      it_behaves_like "expected result size", '釘貫亨', 'author', 1
    end
    context "高橋 (common personal name)", :jira => 'VUF-2711' do
      it_behaves_like "expected result size", '高橋', 'author', 1045
    end
    context "buddhism, 2 char", :jira => ['VUF-2724', 'VUF-2725'] do
      it_behaves_like "both scripts get expected result size", 'author', 'traditional', '佛教', 'script2', '仏教', 'modern', 182
    end
  end # author searches
  
  context "everything searches" do
    context "manchuria kanji   満洲", :jira => 'VUF-2713' do
      it_behaves_like "expected result size", "満洲", nil, 404
    end
    context "manchuria katakana  マンチュリヤ", :jira => 'VUF-2712' do
      it_behaves_like "expected result size", ' マンチュリヤ', nil, 1
    end
    context "TPP", :jira => 'VUF-2694' do
      it_behaves_like "expected result size", 'TPP', nil, 69
    end
    context "publisher's name  日外アソシエーツ", :jira => 'VUF-2699' do
      it_behaves_like "expected result size", '日外アソシエーツ', nil, 455
    end
    context "outside of Japan 日外" do
      it_behaves_like "expected result size", '日外', nil, 2411
    end
    context '(local/regional society) 地域社会', :jira => 'VUF-2717' do
      it_behaves_like "expected result size", '"地域社会', nil, 400
    end
    context 'Edo (old name for Tokyo)', :jira => 'VUF-2726' do
      it_behaves_like "both scripts get expected result size", 'script1', '江戶', 'script2', '江戸', 'everything', 3
    end
    context "investigation", :jira => 'VUF-2727' do
      it_behaves_like "both scripts get expected result size", 'script1', '調查', 'script2', '調査', 'everything', 11139
    end
    context "buddhism", :jira => ['VUF-2724', 'VUF-2725'] do
      it_behaves_like "both scripts get expected result size", 'traditional', '佛教', 'script2', '仏教', 'modern', 'everything', 2336
    end
    context "seven wonders  七不思議", :jira => 'VUF-2710' do
      it_behaves_like "expected result size", '七不思議', nil, 3, 3
    end
    context "seven wonders of sassafras springs  ササフラス・スプリングスの七不思議", :jira => 'VUF-2709' do
      it_behaves_like "expected result size", 'ササフラス・スプリングスの七不思議', nil, 1, 1
    end
    
    context "phrases" do
      context '”地域社会から見る”', :jira => 'VUF-2716' do
        # want 10221504, but dont get it ...
        it_behaves_like "expected result size", '”地域社会から見る”', nil, 3
      end
      context '"地域社会から見る帝国日本と植民地"', :jira => 'VUF-2714' do
        it_behaves_like "expected result size", '"地域社会から見る帝国日本と植民地"', nil, 1
      end
      context '(local/regional society) "地域社会"', :jira => 'VUF-2717' do
        it_behaves_like "expected result size", '""地域社会"', nil, 266
      end
    end
  end # everything searches
  
  context "mixed scripts" do
    context "title searches" do
      context "Japanese art works reference encyclopedia  日本美術作品レファレンス事典", :jira => 'VUF-2698' do
        it_behaves_like "expected result size", '日本美術作品レファレンス事典', 9
      end
      context "modern pseudonym usage  近世仮名遣い" do
        it_behaves_like "expected result size", '近世仮名遣い', 'title', 1
      end
      context "'Blocking' ブロック化 katakana-kanji mix", :jira => 'VUF-2695' do
        it_behaves_like "expected result size", 'ブロック化', 'title', 1
      end
      context "twin story of the swan  mixed hiragana/katakana", :jira => 'VUF-2704' do
        it_behaves_like "expected result size", '白鳥のふたごものがたり', 'title', 1
      end
      context "people traveling overseas encyclopedia", :jira => 'VUF-2084' do
        it_behaves_like "expected result size", '海外渡航者人物事典', 'title', 1
        # FIXME:  the ticket also talks about needing to match substrings of title
        # ckey 5746725
      end
    end
  end # mixed scripts

end