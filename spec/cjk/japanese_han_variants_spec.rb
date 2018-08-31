# -*- encoding : utf-8 -*-
require 'spec_helper'

describe 'Japanese Kanji variants', japanese: true do
  lang_limit = { 'fq' => 'language:Japanese' }

  context 'modern Kanji != simplified Han' do
    context 'buddhism', jira: ['VUF-2724', 'VUF-2725'] do
      # First char of traditional doesn't translate to first char of modern with ICU traditional->simplified
      # (traditional and simplified are the same;  modern is different)
      # second char also has variant:   敎 654E (variant) => 教 6559 (std trad)
      it_behaves_like 'both scripts get expected result size', 'everything', 'traditional', '佛教', 'modern', '仏教', 3000, 4000
      it_behaves_like 'matches in vern short titles first', 'everything', '佛教', /(佛|仏)(教|敎)/, 100  # trad
      it_behaves_like 'matches in vern short titles first', 'everything', '仏教', /(佛|仏)(教|敎)/, 100  # modern
      # exact_245a = %w(6854317 4162614 6276328 10243029 10243045 10243039)
      it_behaves_like 'matches in vern short titles first', 'everything', '仏教', /^(佛|仏)(教|敎)[^[[:alnum:]]]*$/, 3 # exact title match
      it_behaves_like 'matches in vern short titles first', 'title', '仏教', /^(佛|仏)(教|敎).*$/, 7 # title starts w match
      context 'w lang limit' do
        # trad
        it_behaves_like 'result size and vern short title matches first', 'everything', '佛教', 1325, 1725, /(佛|仏)(教|敎)/, 100, lang_limit
        # modern
        it_behaves_like 'result size and vern short title matches first', 'everything', '仏教', 1325, 1725, /(佛|仏)(教|敎)/, 100, lang_limit
      end
    end # buddhism

    context 'cherry blossoms', jira: 'VUF-2781' do
      it_behaves_like 'both scripts get expected result size', 'title', 'traditional', '櫻', 'modern', '桜', 175, 250
      it_behaves_like 'matches in vern short titles first', 'everything', '櫻', /^桜$/, 2  # trad
      it_behaves_like 'matches in vern short titles first', 'everything', '桜', /^桜$/, 2  # modern
    end

    context 'Edo (old name for Tokyo)', jira: ['VUF-2726', 'VUF-2770'] do
      # Second char of traditional doesn't translate to second char of modern with ICU traditional->simplified
      # FIXME:  these do not give the same numbers of results.
      # it_behaves_like "both scripts get expected result size", 'everything', 'traditional', '江戶', 'modern', '江戸', 1900, 2000
      it_behaves_like 'expected result size', 'everything', '江戶', 2000, 2100  # trad
      it_behaves_like 'expected result size', 'everything', '江戸', 2000, 2100  # modern

      it_behaves_like 'matches in vern short titles first', 'everything', '江戶', /(江戶|江戸)/, 100  # trad
      it_behaves_like 'matches in vern short titles first', 'everything', '江戸', /(江戶|江戸)/, 100  # modern
      # exact match
      it_behaves_like 'matches in vern short titles first', 'everything', '江戶', /^(江戶|江戸)[^[[:alnum:]]]*$/, 2  # trad
      it_behaves_like 'matches in vern short titles first', 'everything', '江戸', /^(江戶|江戸)[^[[:alnum:]]]*$/, 1  # modern
      # starts w
      it_behaves_like 'matches in vern short titles first', 'everything', '江戶', /^(江戶|江戸)/, 12  # trad
      it_behaves_like 'matches in vern short titles first', 'everything', '江戸', /^(江戶|江戸)/, 12  # modern
    end

    context 'Jien (personal name)', jira: 'VUF-2779' do
      # Second char of traditional doesn't translate to second char of modern with ICU traditional->simplified
      it_behaves_like 'both scripts get expected result size', 'author', 'traditional', '慈圓', 'modern', '慈円', 13, 20
      it_behaves_like 'matches in vern person authors first', 'author', '慈圓', /(慈圓|慈円)/, 4
      it_behaves_like 'matches in vern person authors first', 'author', '慈円', /(慈圓|慈円)/, 4
    end

    context '(a journal title)', jira: 'VUF-2762' do
      # 文芸戦線 (modern Japanese way of writing title of an early 20th century journal,
      # which used the traditional characters for its title 文藝戰線)
      it_behaves_like 'both scripts get expected result size', 'title', 'traditional', '文藝戰線', 'modern', '文芸戦線', 5, 10, lang_limit
      it_behaves_like 'best matches first', 'title', '文芸戦線', '6622409', 1
    end

    context 'Keio Gijuku University', jira: 'VUF-2780' do
      # 2nd char "応(modern)" VS "應(traditional)".
      # "慶応義塾大学(Keio Gijuku University)" + "Search everything" retrieves 146 hits (all relevant). "慶應義塾大学" retrieves 262 hits (all relevant).
      # FIXME:  these do not give the same numbers of results.  Even with lang_limit.  But they are both analyzed to the same char string  2013-10-14
      #      it_behaves_like "both scripts get expected result size", 'everything', 'traditional', '慶應義塾大学', 'modern', '慶応義塾大学', 375, 450
      it_behaves_like 'expected result size', 'everything', '慶應義塾大学', 400, 575  # trad
      it_behaves_like 'expected result size', 'everything', '慶応義塾大学', 400, 575 # modern
    end

    context 'Mahayana Buddhism', jira: 'VUF-2761' do
      # 大乘仏教 (Mahayana Buddhism; 大乘 = traditional Japanese characters, 仏教 = modern Japanese)
      # Socrates retrieves ten records: the same two Japanese records and
      # eight Chinese records that contain the term written in traditional characters, 大乘佛教.
      it_behaves_like 'both scripts get expected result size', 'title', 'traditional', '大乘佛教', 'modern', '大乘仏教', 10, 65
      it_behaves_like 'best matches first', 'title', '大乘佛教', %w(4192936 6667604), 2  # trad
      it_behaves_like 'best matches first', 'title', '大乘仏教', %w(4192936 6667604), 2  # modern
      it_behaves_like 'matches in vern short titles first', 'title', '大乘佛教', /^大(乗|乘)(佛|仏)教[^[[:alnum:]]]*$/, 2 # trad
      it_behaves_like 'matches in vern short titles first', 'title', '大乘仏教', /^大(乗|乘)(佛|仏)教[^[[:alnum:]]]*$/, 2 # modern
    end

    context 'the origin', jira: 'VUF-2782' do
      # first char doesn't translate the same (modern != simplified)
      # both retrieve 24 results, but they do not retrieve the SAME results
      it_behaves_like 'both scripts get expected result size', 'title', 'traditional', '緣起', 'modern', '縁起', 60, 75, lang_limit
    end

    context 'painting dictionary', jira: 'VUF-2697' do
      # first character of traditional doesn't translate to first char of modern with ICU traditional->simplified
      it_behaves_like 'both scripts get expected result size', 'title', 'traditional', '繪畫辞典', 'modern', '絵画辞典', 1, 1
      it_behaves_like 'best matches first', 'title', '繪畫辞典', '8448289', 1
      it_behaves_like 'best matches first', 'title', '絵画辞典', '8448289', 1
    end

    context 'survey/investigation (kanji)', jira: 'VUF-2727' do
      # second trad char isn't translated to modern by ICU trad-simp
      it_behaves_like 'both scripts get expected result size', 'everything', 'traditional', ' 調查', 'modern', '調査', 10_000, 14_500
      # exact title match
      it_behaves_like 'matches in vern short titles first', 'everything', '調查', /^(調查|調査)[^[[:alnum:]]]*$/, 1
      it_behaves_like 'matches in vern short titles first', 'everything', '調査', /^(調查|調査)[^[[:alnum:]]]*$/, 1
      context 'w lang limit' do
        it_behaves_like 'both scripts get expected result size', 'everything', 'traditional', ' 調查', 'modern', '調査', 7000, 7500, lang_limit
        it_behaves_like 'matches in vern short titles first', 'everything', '調查', /(調查|調査)/, 100, lang_limit # trad
        it_behaves_like 'matches in vern short titles first', 'everything', '調査', /(調查|調査)/, 100, lang_limit # modern
        # exact title match
        it_behaves_like 'matches in vern short titles first', 'everything', '調查', /^(調查|調査)[^[[:alnum:]]]*$/, 1
        it_behaves_like 'matches in vern short titles first', 'everything', '調査', /^(調查|調査)[^[[:alnum:]]]*$/, 1
      end
    end

    context 'South Manchurian Railroad Company (kanji)', jira: ['VUF-2736', 'VUF-2739'] do
      #  満 (U+6E80) and 鉄 (U+9244) are Modern Japanese-only variants for traditional Han  滿 (U+6EFF) and 鐵 (U+9435)
      #  (chars 2 and 4) (char 8 also different)
      # simplified Chinese version of these two characters are 满 (U+6EE1) and 铁 (U+94C1). These are used in Chinese and not Japanese.
      # we don't care about  南满洲铁道株式會社 (Han simplified (non-Japanese) chars 2,4) - a Japanese query wouldn't have it
      it_behaves_like 'both scripts get expected result size', 'author', 'traditional', '南滿洲鐵道株式會社', 'modern', '南満州鉄道株式会社', 600, 750
      it_behaves_like 'expected result size', 'author', '南滿洲鐵道株式會社', 600, 750  # trad
      it_behaves_like 'expected result size', 'author', '南満州鉄道株式会社', 600, 750  # modern
      it_behaves_like 'matches in vern corp authors first', 'author', '南滿洲鐵道株式會社', /^南(滿|満)(洲|州)(鉄|鐵)道株式(会|會)社[^[[:alnum:]]]*.*$/, 100 # traditional
      it_behaves_like 'matches in vern corp authors first', 'author', '南満州鉄道株式会社', /^南(滿|満)(洲|州)(鉄|鐵)道株式(会|會)社[^[[:alnum:]]]*.*$/, 100 # modern
    end

    context 'tale', jira: ['VUF-2742', 'VUF-2740'] do
      # see japanese title search
    end

    context 'weather', jira: 'VUF-2756' do
      # note:  2nd modern char isn't translated to simp by ICU
      # traditional:   天氣
      # modern:   天気
      # chinese simp:  天气
      it_behaves_like 'both scripts get expected result size', 'title', 'traditional', '天氣', 'modern', '天気', 10, 17
      it_behaves_like 'both scripts get expected result size', 'title', 'traditional', '天氣', 'chinese', '天气', 10, 17
      it_behaves_like 'matches in vern short titles first', 'title', '天気', /天(氣|気|气)/, 9 # modern
      it_behaves_like 'matches in vern short titles first', 'title', '天氣', /天(氣|気|气)/, 9 # trad
      it_behaves_like 'matches in vern titles first', 'title', '天気', /天(氣|気|气)/, 11 # modern
      it_behaves_like 'matches in vern titles first', 'title', '天氣', /天(氣|気|气)/, 11 # trad
    end

    context 'weekly' do
      # 2nd trad char isn't translated to modern by ICU - these should be equivalent
      #  modern 刊 520A => trad 刋 520B
      # (see also japanese title)
      it_behaves_like 'both scripts get expected result size', 'title', 'traditional', '週刋', 'modern', '週刊', 80, 110, lang_limit
    end
  end # modern Kanji != simplified Han
end
