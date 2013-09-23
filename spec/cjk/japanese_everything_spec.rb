# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Japanese Everything Searches", :japanese => true do

  lang_limit = {'fq'=>'language:Japanese'}

  context "buddhism", :jira => ['VUF-2724', 'VUF-2725'] do
    # see also japanese han variants as first character of traditional doesn't 
    # translate to first char of modern with ICU traditional->simplified 
    context "traditional 佛教" do
      it_behaves_like "result size and short title matches first", 'everything', '佛教', 1400, 1500, /佛教/, 20
      context "w lang limit" do
        it_behaves_like "result size and short title matches first", 'everything', '佛教', 190, 225, /佛教/, 20, lang_limit
      end
    end
    context "modern 仏教" do
      it_behaves_like "result size and short title matches first", 'everything', '仏教', 820, 850, /仏教/, 20
      exact_245a = ['6854317', '4162614', '6276328', '10243029', '10243045', '10243039']
      it_behaves_like "matches in short titles first", 'everything', '仏教', /^仏教[^[[:alnum:]]]*$/, 3  # exact title match
      context "w lang limit" do
        it_behaves_like "result size and short title matches first", 'everything', '仏教', 820, 850, /仏教/, 20, lang_limit
      end
    end
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
  context "seven wonders 七不思議", :jira => 'VUF-2710' do
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
  
end