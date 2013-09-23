# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Japanese Everything Searches", :japanese => true do

  lang_limit = {'fq'=>'language:Japanese'}

  context "buddhism", :jira => 'VUF-2724' do
    # FIXME:  first character of traditional doesn't translate to first char of 
    #  modern with ICU traditional->simplified    (see also japanese_han_variants_spec)
    context "traditional 佛教" do
      it_behaves_like "result size and vern short title matches first", 'everything', '佛教', 1400, 1500, /佛教/, 100
      context "w lang limit" do
        it_behaves_like "result size and vern short title matches first", 'everything', '佛教', 190, 225, /佛教/, 100, lang_limit
      end
    end
    context "modern 仏教" do
      it_behaves_like "result size and vern short title matches first", 'everything', '仏教', 820, 850, /仏教/, 100
      exact_245a = ['6854317', '4162614', '6276328', '10243029', '10243045', '10243039']
      it_behaves_like "matches in vern short titles first", 'everything', '仏教', /^仏教[^[[:alnum:]]]*$/, 3  # exact title match
      context "w lang limit" do
        it_behaves_like "result size and vern short title matches first", 'everything', '仏教', 820, 850, /仏教/, 100, lang_limit
      end
    end
  end

  context 'Edo (old name for Tokyo)', :jira => ['VUF-2726', 'VUF-2770'] do
    # FIXME:  second character of traditional doesn't translate to second char of 
    #  modern with ICU traditional->simplified    (see also japanese_han_variants_spec)
    context "traditional 江戶" do
      it_behaves_like "result size and vern short title matches first", 'everything', '江戶', 1900, 2000, /江戶/, 100
      context "w lang limit" do
        it_behaves_like "result size and vern short title matches first", 'everything', '江戶', 1900, 1950, /江戶/, 100, lang_limit
      end
    end
    context "modern 江戸" do
      it_behaves_like "expected result size", 'everything', '江戸', 3, 5
      context "w lang limit" do
        it_behaves_like "expected result size", 'everything', '江戸', 3, 5, lang_limit
      end
    end
  end

  context "Japan China thought", :jira => 'VUF-2737' do
    it_behaves_like "expected result size", 'everything', '日本  中国  思想', 65, 70
    context "w lang limit" do
      it_behaves_like "expected result size", 'everything', '日本  中国  思想', 32, 40, lang_limit
    end
  end

  context '(local/regional society)', :jira => 'VUF-2717' do
    it_behaves_like "expected result size", 'everything', '"地域社会', 490, 525
    it_behaves_like "matches in vern short titles first", 'everything', '地域社会', /^地域社会$/, 1  # exact title match
    context "w lang limit" do
      it_behaves_like "expected result size", 'everything', '"地域社会', 430, 450, lang_limit
    end
  end

  context "manchuria", :jira => ['VUF-2712', 'VUF-2713'] do
    # FIXME:  we currently have no katakana <-> han mapping.  (see also japanese_katakana_han_spec)
    context "katakana", :jira => 'VUF-2712' do
      it_behaves_like "good results for query", 'everything', ' マンチュリヤ', 2, 3, ['6326474', '9375973'], 2
    end
    context "kanji", :jira => 'VUF-2713' do
      it_behaves_like "result size and vern short title matches first", 'everything', '満洲', 362, 415, /満洲/, 100
      context "w lang limit" do
        it_behaves_like "result size and vern short title matches first", 'everything', '満洲', 362, 400, /満洲/, 100, lang_limit
      end
    end
  end

  context "outside of Japan", :jira => 'VUF-2699' do
    # Socrates everything search for 日外:2411  (this is closer to what I would expect
    #  for this very general search; the Searchworks result makes me wonder)
    it_behaves_like "result size and vern short title matches first", 'everything', '日外', 500, 2500, /日外/, 35
  end
  context "publisher's name starting with 'outside of Japan'", :jira => 'VUF-2699' do
    it_behaves_like "expected result size", 'everything', '日外アソシエーツ', 500, 600
    it_behaves_like "matches in vern corp authors first", 'everything', '日外アソシエーツ', /日外アソシエーツ/, 2
  end

  context "seven wonders 七不思議", :jira => 'VUF-2710' do
    it_behaves_like "result size and vern short title matches first", 'everything', '七不思議', 3, 3, /七不思議/, 1
  end

  context "seven wonders of sassafras springs  ササフラス・スプリングスの七不思議", :jira => 'VUF-2709' do
    it_behaves_like "result size and vern short title matches first", 'everything', 'ササフラス・スプリングスの七不思議', 1, 1, /七不思議/, 1
  end

  context "survey/investigation (kanji)", :jira => 'VUF-2727' do
    # FIXME:  second trad char isn't translated to modern by ICU trad-simp
    #  (see also japanese_han_variants_spec)
    context "traditional 調查" do
      # NOTE:   调查  => chinese simplified
      it_behaves_like "result size and vern short title matches first", 'everything', '調查', 7000, 12000, /(調查|调查)/, 100
      context "w lang limit" do
        it_behaves_like "result size and vern short title matches first", 'everything', '調查', 7000, 8000, /調查/, 100, lang_limit
      end
    end
    context "modern 調査" do
      it_behaves_like "result size and vern short title matches first", 'everything', '調査', 100, 115, /調査/, 25
    end
  end

  context "TPP", :jira => 'VUF-2694' do
    it_behaves_like "result size and vern short title matches first", 'everything', 'TPP', 69, 85, /TPP/, 6
    context "w lang limit" do
      it_behaves_like "result size and vern short title matches first", 'everything', 'TPP', 8, 12, /TPP/, 6, lang_limit
    end
  end

end