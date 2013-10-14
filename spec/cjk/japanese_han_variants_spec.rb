# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Japanese Kanji variants", :japanese => true, :fixme => true do

  lang_limit = {'fq'=>'language:Japanese'}

  context "modern Kanji != simplified Han" do
    context "buddhism", :jira => ['VUF-2724', 'VUF-2725'] do
      # First char of traditional doesn't translate to first char of modern with ICU traditional->simplified 
      # (traditional and simplified are the same;  modern is different)
      it_behaves_like "both scripts get expected result size", 'everything', 'traditional', '佛教', 'modern', '仏教', 2200, 2300
      it_behaves_like "matches in vern short titles first", 'everything', '佛教', /(佛教|仏教)/, 100
      it_behaves_like "matches in vern short titles first", 'everything', '仏教', /(佛教|仏教)/, 100
      exact_245a = ['6854317', '4162614', '6276328', '10243029', '10243045', '10243039']
      it_behaves_like "matches in vern short titles first", 'everything', '仏教', /^(佛教|仏教)[^[[:alnum:]]]*$/, 3 # exact title match
      it_behaves_like "matches in vern short titles first", 'title', '仏教', /^(佛教|仏教).*$/, 7 # title starts w match
      context "w lang limit" do
        # trad
        it_behaves_like "result size and vern short title matches first", 'everything', '佛教', 1000, 1100, /(佛教|仏教)/, 100, lang_limit
        # modern
        it_behaves_like "result size and vern short title matches first", 'everything', '仏教', 1000, 1100, /(佛教|仏教)/, 100, lang_limit
      end
    end # buddhism

    context "cherry blossoms", :jira => 'VUF-2781' do
      it_behaves_like "both scripts get expected result size", 'title', 'traditional', '櫻', 'modern', '桜', 175, 200
      it_behaves_like "matches in vern short titles first", 'everything', '櫻', /^桜$/, 2  # trad
      it_behaves_like "matches in vern short titles first", 'everything', '桜', /^桜$/, 2  # modern
    end

    context 'Edo (old name for Tokyo)', :jira => ['VUF-2726', 'VUF-2770'] do
      # Second char of traditional doesn't translate to second char of modern with ICU traditional->simplified 
      it_behaves_like "both scripts get expected result size", 'everything', 'traditional', '江戶', 'modern', '江戸', 1900, 2000
      it_behaves_like "matches in vern short titles first", 'everything', '江戶', /(江戶|江戸)/, 100  # trad
      it_behaves_like "matches in vern short titles first", 'everything', '江戸', /(江戶|江戸)/, 100  # modern
      # exact match
      it_behaves_like "matches in vern short titles first", 'everything', '江戶', /^(江戶|江戸)[^[[:alnum:]]]*$/, 3  # trad
      it_behaves_like "matches in vern short titles first", 'everything', '江戸', /^(江戶|江戸)[^[[:alnum:]]]*$/, 3  # modern
      # starts w
      it_behaves_like "matches in vern short titles first", 'everything', '江戶', /^(江戶|江戸)/, 12  # trad
      it_behaves_like "matches in vern short titles first", 'everything', '江戸', /^(江戶|江戸)/, 12  # modern
    end

    context 'Jien (personal name)', :jira => 'VUF-2779' do
      # Second char of traditional doesn't translate to second char of modern with ICU traditional->simplified 
      it_behaves_like "both scripts get expected result size", 'author', 'traditional', '慈圓', 'modern', '慈円', 13, 20
      it_behaves_like "matches in vern person authors first", 'author', '慈圓', /(慈圓|慈円)/, 4
      it_behaves_like "matches in vern person authors first", 'author', '慈円', /(慈圓|慈円)/, 4
    end
    
    context "(a journal title)", :jira => 'VUF-2762' do
      # 文芸戦線 (modern Japanese way of writing title of an early 20th century journal, 
      # which used the traditional characters for its title 文藝戰線)
      it_behaves_like "both scripts get expected result size", 'title', 'traditional', '文藝戰線', 'modern', '文芸戦線', 5, 10, lang_limit
      it_behaves_like "best matches first", 'title', '文芸戦線', '6622409', 1
    end
    
    context "Keio Gijuku University", :jira => 'VUF-2780' do
      # 2nd char "応(modern)" VS "應(traditional)". 
      # "慶応義塾大学(Keio Gijuku University)" + "Search everything" retrieves 146 hits (all relevant). "慶應義塾大学" retrieves 262 hits (all relevant). 
# FIXME:  these do not give the same numbers of results.  Even with lang_limit  2013-10-14
#      it_behaves_like "both scripts get expected result size", 'everything', 'traditional', '慶應義塾大学', 'modern', '慶応義塾大学', 375, 450
      it_behaves_like "expected result size", 'everything', '慶應義塾大学', 375, 450  # trad
      it_behaves_like "expected result size", 'everything', '慶応義塾大学', 375, 450  # modern
    end
    
    context "Mahayana Buddhism", :jifra => 'VUF-2761' do
      # 大乘仏教 (Mahayana Buddhism; 大乘 = traditional Japanese characters, 仏教 = modern Japanese)
      # Socrates retrieves ten records: the same two Japanese records and 
      # eight Chinese records that contain the term written in traditional characters, 大乘佛教. 
      it_behaves_like "expected result size", 'everything', '大乘仏教', 10, 15
    end
    
    context "the origin", :jira => 'VUF-2782' do
      # first char doesn't translate the same (modern != simplified) 
      # both retrieve 24 results, but they do not retrieve the SAME results 
      it_behaves_like "both scripts get expected result size", 'title', 'traditional', '緣起', 'modern', '縁起', 48, 60, lang_limit
    end

    context "painting dictionary", :jira => 'VUF-2697' do
      # first character of traditional doesn't translate to first char of modern with ICU traditional->simplified
      it_behaves_like "both scripts get expected result size", 'title', 'traditional', '繪畫辞典', 'modern', '絵画辞典', 1, 1
      it_behaves_like "best matches first", 'title', '繪畫辞典', '8448289', 1
      it_behaves_like "best matches first", 'title', '絵画辞典', '8448289', 1
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

    context "South Manchurian Railroad Company (kanji)", :jira => ['VUF-2736', 'VUF-2739'] do
      #  満 (U+6E80) and 鉄 (U+9244) are Modern Japanese-only variants for traditional Han  滿 (U+6EFF) and 鐵 (U+9435)
      #  (chars 2 and 4)
      # simplified Chinese version of these two characters are 满 (U+6EE1) and 铁 (U+94C1). These are used in Chinese and not Japanese.
      # we don't care about  南满洲铁道株式會社 (simplified (non-Japanese) chars 2,4) - a Japanese query wouldn't have it
      it_behaves_like "both scripts get expected result size", 'author', 'modern', '南満州鉄道株式会社', 'traditional', '南滿洲鐵道株式會社', 690, 750
      # note: Han simplified:  南滿洲鐵道株式会社
      it_behaves_like "matches in vern corp authors first", 'author', '南滿洲鐵道株式會社', /(南滿洲鐵道株式會社|南滿洲鐵道株式会社|南満州鉄道株式会社)/, 100
      it_behaves_like "matches in vern corp authors first", 'author', '南滿洲鐵道株式会社', /(南滿洲鐵道株式會社|南滿洲鐵道株式会社|南満州鉄道株式会社)/, 100
      it_behaves_like "matches in vern corp authors first", 'author', '南満州鉄道株式会社', /(南滿洲鐵道株式會社|南滿洲鐵道株式会社|南満州鉄道株式会社)/, 100
    end

    context "tale", :jira => ['VUF-2705', 'VUF-2742', 'VUF-2740'] do
      # note:  Japanese do not use 语 (2nd char as simplified chinese) but rather 語
      it_behaves_like "both scripts get expected result size", 'title', 'traditional', '物語', 'chinese simp', '物语', 2351, 2455
      it_behaves_like "both scripts get expected result size", 'title', 'traditional', '物語', 'modern', '物語', 2351, 2455
      it_behaves_like "matches in vern titles first", 'title', '物語', /物語/, 13  # 14 is 4223454 which has it in 240a
    end
    
    context "weather", :jira => 'VUF-2756' do
      # note:  2nd modern char isn't translated to simp 
      it_behaves_like "both scripts get expected result size", 'title', 'traditional', '天氣', 'modern', '天気', 10, 17
      it_behaves_like "both scripts get expected result size", 'title', 'traditional', '天氣', 'chinese', '天气', 10, 17
    end

    context "weekly" do
      # 2nd trad char isn't translated to modern - these should be equivalent
      it_behaves_like "both scripts get expected result size", 'title', 'modern', '週刊', 'traditional', '週刋', 83, 440, lang_limit
    end

  end # modern Kanji != simplified Han

end