# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Japanese Everything Searches", :japanese => true do

  lang_limit = {'fq'=>'language:Japanese'}

  context "1900 (year)", :jira => 'VUF-2754' do
    it_behaves_like "expected result size", 'everything', '千九百年', 25, 35
    context "w lang limit" do
      it_behaves_like "expected result size", 'everything', '千九百年', 3, 5, lang_limit
    end
  end

  context "buddhism", :jira => 'VUF-2724' do
    # First char of traditional doesn't translate to first char of modern with ICU traditional->simplified 
    # (see japanese_han_variants)
  end

  context 'Edo (old name for Tokyo)', :jira => ['VUF-2726', 'VUF-2770'] do
    # second character of traditional doesn't translate to second char of modern with ICU traditional->simplified
    # (see also japanese_han_variants_spec)
    # FIXME:  these do not give the same numbers of results.
    #it_behaves_like "both scripts get expected result size", 'everything', 'traditional', '江戶', 'modern', '江戸', 1900, 2000, lang_limit
    it_behaves_like "expected result size", 'everything', '江戶', 1975, 2075, lang_limit  # trad
    it_behaves_like "expected result size", 'everything', '江戸', 1975, 2075, lang_limit  # modern

    it_behaves_like "matches in vern short titles first", 'everything', '江戶', /(江戶|江戸)/, 100, lang_limit  # trad
    it_behaves_like "matches in vern short titles first", 'everything', '江戸', /(江戶|江戸)/, 100, lang_limit # modern
    # exact match
    it_behaves_like "matches in vern short titles first", 'everything', '江戶', /^(江戶|江戸)[^[[:alnum:]]]*$/, 3, lang_limit  # trad
    it_behaves_like "matches in vern short titles first", 'everything', '江戸', /^(江戶|江戸)[^[[:alnum:]]]*$/, 3, lang_limit  # modern
    # starts w
    it_behaves_like "matches in vern short titles first", 'everything', '江戶', /^(江戶|江戸)/, 12, lang_limit  # trad
    it_behaves_like "matches in vern short titles first", 'everything', '江戸', /^(江戶|江戸)/, 12, lang_limit  # modern
  end

  context "Imperial" do
    it_behaves_like "both scripts get expected result size", 'everything', 'traditional', '帝國', 'modern', '帝国', 1475, 1575, lang_limit
  end

  context "Japan China thought", :jira => 'VUF-2737' do
    it_behaves_like "expected result size", 'everything', '日本  中国  思想', 65, 80
    context "w lang limit" do
      it_behaves_like "expected result size", 'everything', '日本  中国  思想', 32, 40, lang_limit
    end
  end

  context "kawaru no ka  変わるのか", :jira => 'VUF-2802' do
    it_behaves_like "result size and vern title matches first", 'everything', '変わるのか', 30, 35, /変わるのか/, 4
  end

  context '(local/regional society)', :jira => 'VUF-2717' do
    it_behaves_like "expected result size", 'everything', '地域社会', 490, 600
    it_behaves_like "matches in vern short titles first", 'everything', '地域社会', /^地域社会$/, 1  # exact title match
    context "w lang limit" do
      it_behaves_like "expected result size", 'everything', '地域社会', 450, 500, lang_limit
    end
    context "phrase" do
      it_behaves_like "expected result size", 'everything', '"地域社会"', 266, 300
    end
  end

  context '(local/regional society - longer)', :jira => 'VUF-2716' do
    it_behaves_like "good results for query", 'everything', '地域社会から見る', 3, 5, '10250667', 1
    context "phrase" do
      it_behaves_like "good results for query", 'everything', '”地域社会から見る”', 3, 5, '10250667', 1
    end
  end

  context '(local/regional society - all of Japan)', :jira => 'VUF-2714' do
    it_behaves_like "good results for query", 'everything', '地域社会から見る帝国日本と植民地', 1, 3, '10250667', 1
    context "phrase" do
      it_behaves_like "good results for query", 'everything', '"地域社会から見る帝国日本と植民地"', 1, 3, '10250667', 1
    end
  end

  context "manchuria", :jira => ['VUF-2712', 'VUF-2713'] do
    # FIXME:  we currently have no katakana <-> han mapping.  (see also japanese_katakana_han_spec)
    context "katakana", :jira => 'VUF-2712' do
      it_behaves_like "good results for query", 'everything', ' マンチュリヤ', 2, 3, ['6326474', '10667394'], 2
    end
    context "kanji", :jira => 'VUF-2713' do
      # note: first char is a modern japanese variant
      it_behaves_like "result size and vern short title matches first", 'everything', '満洲', 2000, 2500, /(満|滿|满)(洲|州)/, 100
      context "w lang limit" do
        it_behaves_like "result size and vern short title matches first", 'everything', '満洲', 1775, 2200, /(満|滿|满)(洲|州)/, 100, lang_limit
      end
    end
  end

  context "outside of Japan", :jira => 'VUF-2699' do
    # Socrates everything search for 日外:2411  (this is closer to what I would expect
    #  for this very general search; the Searchworks result makes me wonder)
    it_behaves_like "result size and vern short title matches first", 'everything', '日外', 500, 2500, /日外/, 35
  end
  context "publisher's name starting with 'outside of Japan'", :jira => 'VUF-2699' do
    it_behaves_like "expected result size", 'everything', '日外アソシエーツ', 500, 650
    it_behaves_like "matches in vern corp authors first", 'everything', '日外アソシエーツ', /日外アソシエーツ/, 2
  end

  context "seven wonders 七不思議", :jira => 'VUF-2710' do
    it_behaves_like "result size and vern short title matches first", 'everything', '七不思議', 3, 4, /七不思議/, 1
  end

  context "seven wonders of sassafras springs  ササフラス・スプリングスの七不思議", :jira => 'VUF-2709' do
    it_behaves_like "result size and vern short title matches first", 'everything', 'ササフラス・スプリングスの七不思議', 1, 1, /七不思議/, 1
  end

  context "survey/investigation (kanji)", :jira => 'VUF-2727' do
    # FIXME:  second trad char isn't translated to modern by ICU trad-simp
    # (see japanese_han_variants)
  end

  context "Takamatsu Tumulus", :jira => 'VUF-2801' do
    it_behaves_like "result size and vern short title matches first", 'everything', '高松 塚古墳', 6, 8, /高松\s*塚古墳/, 1
  end

  context "TPP", :jira => 'VUF-2694' do
    it_behaves_like "result size and vern short title matches first", 'everything', 'TPP', 100, 125, /TPP/, 6
    context "w lang limit" do
      it_behaves_like "result size and vern short title matches first", 'everything', 'TPP', 8, 12, /TPP/, 6, lang_limit
    end
  end

end