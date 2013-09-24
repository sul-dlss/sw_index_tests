# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Japanese Kanji variants", :japanese => true, :fixme => true do

  lang_limit = {'fq'=>'language:Japanese'}

  context "modern Kanji != simplified Han" do
    context "buddhism", :jira => ['VUF-2724', 'VUF-2725'] do
      # First char of traditional doesn't translate to first char of modern with ICU traditional->simplified 
      it_behaves_like "both scripts get expected result size", 'everything', 'traditional', '佛教', 'modern', '仏教', 2200, 2300
      it_behaves_like "matches in vern short titles first", 'everything', '佛教', /(佛教|仏教)/, 100
      it_behaves_like "matches in vern short titles first", 'everything', '仏教', /(佛教|仏教)/, 100
      exact_245a = ['6854317', '4162614', '6276328', '10243029', '10243045', '10243039']
      it_behaves_like "matches in vern short titles first", 'everything', '仏教', /^(佛教|仏教)[^[[:alnum:]]]*$/, 5  # exact title match
      context "w lang limit" do
        # trad
        it_behaves_like "result size and vern short title matches first", 'everything', '佛教', 1000, 1100, /(佛教|仏教)/, 100, lang_limit
        # modern
        it_behaves_like "result size and vern short title matches first", 'everything', '仏教', 1000, 1100, /(佛教|仏教)/, 100, lang_limit
      end
    end # buddhism

    context 'Edo (old name for Tokyo)', :jira => ['VUF-2726', 'VUF-2770'] do
      # Second char of traditional doesn't translate to second char of modern with ICU traditional->simplified 
      it_behaves_like "both scripts get expected result size", 'everything', 'traditional', '江戶', 'modern', '江戸', 1900, 2000
      # trad  江戶
      it_behaves_like "result size and vern short title matches first", 'everything', '江戶', 1900, 2000, /(江戶|江戸)/, 100
      # modern  江戸
      it_behaves_like "expected result size", 'everything', '江戸', 3, 5
      context "w lang limit" do
        # trad
        it_behaves_like "result size and vern short title matches first", 'everything', '江戶', 1900, 1950, /江戶/, 100, lang_limit
        # modern
        it_behaves_like "expected result size", 'everything', '江戸', 3, 5, lang_limit
      end
    end

    context 'Jien (personal name)', :jira => 'VUF-2779' do
      # Second char of traditional doesn't translate to second char of modern with ICU traditional->simplified 
      it_behaves_like "both scripts get expected result size", 'author', 'traditional', '慈圓', 'modern', '慈円', 13, 20
      it_behaves_like "matches in vern person authors first", 'author', '慈圓', /(慈圓|慈円)/, 4
      it_behaves_like "matches in vern person authors first", 'author', '慈円', /(慈圓|慈円)/, 4
    end

    context "survey/investigation (kanji)", :jira => 'VUF-2727' do
      # second trad char isn't translated to modern by ICU trad-simp
      it_behaves_like "both scripts get expected result size", 'everything', 'traditional', ' 調查', 'modern', '調査', 7000, 12000
      # exact title match
      it_behaves_like "matches in vern short titles first", 'everything', '調查', /^(調查|調査)[^[[:alnum:]]]*$/, 1
      it_behaves_like "matches in vern short titles first", 'everything', '調査', /^(調查|調査)[^[[:alnum:]]]*$/, 1
      context "w lang limit" do
        it_behaves_like "both scripts get expected result size", 'everything', 'traditional', ' 調查', 'modern', '調査', 7000, 8000, lang_limit
        it_behaves_like "matches in vern short titles first", 'everything', '調查', /(調查|調査)/, 100  # trad
        it_behaves_like "matches in vern short titles first", 'everything', '調査', /(調查|調査)/, 100   # modern
        # exact title match
        it_behaves_like "matches in vern short titles first", 'everything', '調查', /^(調查|調査)[^[[:alnum:]]]*$/, 1
        it_behaves_like "matches in vern short titles first", 'everything', '調査', /^(調查|調査)[^[[:alnum:]]]*$/, 1
      end      
    end

  end # modern Kanji != simplified Han

end