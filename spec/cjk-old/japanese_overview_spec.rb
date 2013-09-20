# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Japanese Overview", :japanese => true, :fixme => true do

  lang_limit = {'fq'=>'language:Japanese'}

  context "title searches" do
    # note:  moved title searches to japanese_title spec
  end

  context "author searches", :fixme => true do
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
  
  context "everything searches", :fixme => true do
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