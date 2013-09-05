# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'rspec-solr'

describe "Japanese Overview", :japanese => true, :fixme => true do
  
  shared_examples_for "expected result size" do | query, query_type, num_exp |
    it "should have #{num_exp} results" do
      case query_type
        when 'title'
          resp = solr_resp_doc_ids_only({'q' => cjk_title_q_arg(query)})
        when 'author'
          resp = solr_resp_doc_ids_only({'q' => cjk_author_q_arg(query)})
        else
          resp = solr_resp_doc_ids_only({'q' => cjk_everything_q_arg(query)})
      end
      resp.should have_exactly(num_exp).results
    end
  end

  shared_examples_for "queries get same result size" do | query1, query2, query_type |
    it "both #{query_type} queries should get same result size" do
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
  
  shared_examples_for "both scripts get expected result size" do | script_name1, query1, script_name2, query2, query_type, num_exp |
    it_behaves_like "queries get same result size", query1, query2, query_type
    context "#{script_name1}: #{query1}" do
      it_behaves_like "expected result size", query1, query_type, num_exp
    end
    context "#{script_name2}: #{query2}" do
      it_behaves_like "expected result size", query2, query_type, num_exp
    end
  end

  #--- end shared examples ---------------------------------------------------

  context "title searches" do
    context "Buddhism 3 char" do
      it_behaves_like "both scripts get expected result size", 'modern', ' 仏教学', 'traditional', '佛教學', 'title', 19
    end
    context "comics/manga" do
      it_behaves_like "both scripts get expected result size", 'hiragana', 'まんが', 'katakana', 'マンガ', 'title', 261      
      it_behaves_like "both scripts get expected result size", 'modern', ' 漫画', 'traditional', '漫畫', 'title', 389
    end
    context "painting dictionary", :jira => 'VUF-2697' do
      it_behaves_like "both scripts get expected result size", 'traditional', '繪̄畫辞典', 'modern', '絵画辞典', 'title', 1      
    end
    context "sports  スポーツ (katakana)" do
      it_behaves_like "expected result size", 'スポーツ', 'title', 34
    end
    context "grandpa  おじいさん (hiragana)", :jira => 'VUF-2715' do
      it_behaves_like "both scripts get expected result size", 'hiragana', 'おじいさん', 'katakana', 'オジいサン', 'title', 10
    end
    context "'Hiragana'  ひらがな", :jira => 'VUF-2693' do
      it_behaves_like "expected result size", 'ひらがな', 'title', 26
    end
    context "TPP", :jira => 'VUF-2694' do
      it_behaves_like "expected result size", 'TPP', 'title', 11
    end
    context "lantern", :jira => 'VUF-2703' do
      it_behaves_like "expected result size", 'ちょうちん', 'title', 2
    end
    context "lantern shop", :jira => 'VUF-2702' do
      it_behaves_like "expected result size", 'ちょうちん屋', 'title', 1
    end
    context "Tsu child remains lantern shop", :jira => 'VUF-2701' do
      it_behaves_like "expected result size", 'ちょうちん屋のままッ子', 'title', 1
    end
    context "seven wonders  七不思議", :jira => 'VUF-2710' do
      it_behaves_like "expected result size", '七不思議', nil, 3
    end
    context "seven wonders of sassafras springs  ササフラス・スプリングスの七不思議", :jira => 'VUF-2709' do
      it_behaves_like "expected result size", 'ササフラス・スプリングスの七不思議', nil, 1
    end
    context "buddhism, 2 char", :jira => ['VUF-2724', 'VUF-2725'] do
      it_behaves_like "both scripts get expected result size", 'traditional', '佛教', 'script2', '仏教', 'modern', 'title', 1984
    end
  end # title searches

  context "author searches" do
    context "South Manchurian Railroad Company" do
      it_behaves_like "both scripts get expected result size", 'modern', ' 南満州鉄道株式会社', 'traditional', '南滿洲鐵道株式會社', 'author', 522
    end
    context "personal name  契沖" do
      it_behaves_like "both scripts get expected result size", 'kanji', '契沖', 'hiragana', 'けいちゅう', 'author', 5
    end
    context "kanji surname  釘貫 (surname of 釘貫亨)" do
      it_behaves_like "expected result size", '釘貫', 'author', 1
      it_behaves_like "expected result size", '釘貫亨', 'author', 1
    end
    context "高橋 (common personal name)", :jira => 'VUF-2711' do
      it_behaves_like "expected result size", '高橋', 'author', 1045
    end
    context "buddhism, 2 char", :jira => ['VUF-2724', 'VUF-2725'] do
      it_behaves_like "both scripts get expected result size", 'traditional', '佛教', 'script2', '仏教', 'modern', 'author', 182
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
    context "buddhism, 2 char", :jira => ['VUF-2724', 'VUF-2725'] do
      it_behaves_like "both scripts get expected result size", 'traditional', '佛教', 'script2', '仏教', 'modern', 'everything', 2336
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