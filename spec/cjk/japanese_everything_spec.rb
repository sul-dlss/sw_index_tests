# -*- encoding : utf-8 -*-
require 'spec_helper'

describe 'Japanese Everything Searches', japanese: true do
  lang_limit = { 'fq' => ['language:Japanese', 'collection:sirsi'] }

  context '1900 (year)', jira: 'VUF-2754' do
    it_behaves_like 'expected result size', 'everything', '千九百年', 25, 65
    context 'w lang limit' do
      it_behaves_like 'expected result size', 'everything', '千九百年', 2, 8, lang_limit
    end
  end

  context 'buddhism', jira: 'VUF-2724' do
    # First char of traditional doesn't translate to first char of modern with ICU traditional->simplified
    # (see japanese_han_variants)
  end

  context 'Edo (old name for Tokyo)', jira: ['VUF-2726', 'VUF-2770'] do
    # second character of traditional doesn't translate to second char of modern with ICU traditional->simplified
    # (see also japanese_han_variants_spec)
    # FIXME:  these do not give the same numbers of results.
    # it_behaves_like "both scripts get expected result size", 'everything', 'traditional', '江戶', 'modern', '江戸', 1900, 2000, lang_limit
    it_behaves_like 'expected result size', 'everything', '江戶', 2450, 2750, lang_limit  # trad
    it_behaves_like 'expected result size', 'everything', '江戸', 2450, 2750, lang_limit  # modern

    it_behaves_like 'matches in vern short titles first', 'everything', '江戶', /(江戶|江戸)/, 100, lang_limit # trad
    it_behaves_like 'matches in vern short titles first', 'everything', '江戸', /(江戶|江戸)/, 100, lang_limit # modern
    # exact match
    it_behaves_like 'matches in vern short titles first', 'everything', '江戶', /^(江戶|江戸)[^[[:alnum:]]]*$/, 2, lang_limit  # trad
    it_behaves_like 'matches in vern short titles first', 'everything', '江戸', /^(江戶|江戸)[^[[:alnum:]]]*$/, 1, lang_limit  # modern
    # starts w
    it 'starts with string', pending: 'fixme' do
      it_behaves_like 'matches in vern short titles first', 'everything', '江戶', /^(江戶|江戸)/, 12, lang_limit  # trad
      it_behaves_like 'matches in vern short titles first', 'everything', '江戸', /^(江戶|江戸)/, 12, lang_limit  # modern
    end
  end

  context 'Imperial' do
    # Marked pending as its unclear whether these having different result counts is bad.
    it '', pending: 'fixme' do
      it_behaves_like 'both scripts get expected result size', 'everything', 'traditional', '帝國', 'modern', '帝国', 1475, 1650, lang_limit
    end
  end

  context 'Japan China thought', jira: 'VUF-2737' do
    it_behaves_like 'expected result size', 'everything', '日本  中国  思想', 100, 150
    context 'w lang limit' do
      it_behaves_like 'expected result size', 'everything', '日本  中国  思想', 30, 60, lang_limit
    end
  end

  context 'kawaru no ka  変わるのか', jira: 'VUF-2802' do
    it_behaves_like 'result size and vern title matches first', 'everything', '変わるのか', 20, 35, /変わるのか/, 4
  end

  context '(local/regional society)', jira: 'VUF-2717' do
    it_behaves_like 'expected result size', 'everything', '地域社会', 800, 950
    it_behaves_like 'matches in vern short titles first', 'everything', '地域社会', /^地域社会$/, 1 # exact title match
    context 'w lang limit' do
      it_behaves_like 'expected result size', 'everything', '地域社会', 550, 700, lang_limit
    end
    context 'phrase' do
      it_behaves_like 'expected result size', 'everything', '"地域社会"', 340, 420
    end
  end

  context '(local/regional society - longer)', jira: 'VUF-2716' do
    it_behaves_like 'good results for query', 'everything', '地域社会から見る', 3, 5, '10250667', 1
    context 'phrase' do
      it_behaves_like 'good results for query', 'everything', '”地域社会から見る”', 3, 5, '10250667', 1
    end
  end

  context '(local/regional society - all of Japan)', jira: 'VUF-2714' do
    it_behaves_like 'good results for query', 'everything', '地域社会から見る帝国日本と植民地', 1, 3, '10250667', 1
    context 'phrase' do
      it_behaves_like 'good results for query', 'everything', '"地域社会から見る帝国日本と植民地"', 1, 3, '10250667', 1
    end
  end

  context 'manchuria', jira: ['VUF-2712', 'VUF-2713'] do
    # FIXME:  we currently have no katakana <-> han mapping.  (see also japanese_katakana_han_spec)
    context 'katakana', jira: 'VUF-2712' do
      it '', pending: 'fixem' do
        # More investigation needed.
        it_behaves_like 'good results for query', 'everything', ' マンチュリヤ', 1, 5, %w(6326474 10667394), 2
      end
    end
    context 'kanji', jira: 'VUF-2713' do
      # note: first char is a modern japanese variant
      it_behaves_like 'result size and vern short title matches first', 'everything', '満洲', 2000, 3000, /(満|滿|满)(洲|州)/, 20
      context 'w lang limit' do
        it_behaves_like 'result size and vern short title matches first', 'everything', '満洲', 2000, 2500, /(満|滿|满)(洲|州)/, 20, lang_limit
      end
    end
  end

  context 'outside of Japan', jira: 'VUF-2699' do
    # Socrates everything search for 日外:2411  (this is closer to what I would expect
    #  for this very general search; the Searchworks result makes me wonder)
    it_behaves_like 'expected result size', 'everything', '日外', 500, 2500
    context '', skip: :fixme do
      it_behaves_like 'result size and vern title matches first', 'everything', '日外', 500, 2500, /日外/, 5
    end
  end
  context "publisher's name starting with 'outside of Japan'", jira: 'VUF-2699' do
    it_behaves_like 'expected result size', 'everything', '日外アソシエーツ', 700, 850
    it_behaves_like 'matches in vern corp authors first', 'everything', '日外アソシエーツ', /日外アソシエーツ/, 2
  end

  context 'seven wonders 七不思議', jira: 'VUF-2710' do
    it_behaves_like 'result size and vern short title matches first', 'everything', '七不思議', 2, 4, /七不思議/, 1
  end

  context 'seven wonders of sassafras springs  ササフラス・スプリングスの七不思議', jira: 'VUF-2709' do
    it_behaves_like 'result size and vern short title matches first', 'everything', 'ササフラス・スプリングスの七不思議', 1, 1, /七不思議/, 1
  end

  context 'survey/investigation (kanji)', jira: 'VUF-2727' do
    # FIXME:  second trad char isn't translated to modern by ICU trad-simp
    # (see japanese_han_variants)
  end

  context 'Takamatsu Tumulus', jira: 'VUF-2801' do
    it_behaves_like 'result size and vern short title matches first', 'everything', '高松 塚古墳', 10, 20, /高松\s*塚古墳/, 1
  end

  context 'TPP', jira: 'VUF-2694' do
    context 'w lang limit' do
      it_behaves_like 'result size and vern short title matches first', 'everything', 'TPP', 35, 75, /TPP/, 6, lang_limit
    end
  end
end
