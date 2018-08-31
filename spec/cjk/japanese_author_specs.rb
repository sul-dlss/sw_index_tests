# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Japanese Author Searches", :japanese => true do

  lang_limit = {'fq'=>'language:Japanese'}
  
  context "buddhism (corporate author)", :jira => 'VUF-2723' do
    # FIXME:  first character of traditional doesn't translate to first char of 
    #  modern with ICU traditional->simplified    (see also japanese han variants)
    context "traditional 佛教" do
      it_behaves_like "result size and vern corp author matches first", 'author', '佛教', 90, 125, /佛教/, 7
      context "w lang limit" do
        it_behaves_like "result size and vern corp author matches first", 'author', '佛教', 35, 50, /佛教/, 3, lang_limit
      end
    end
    context "modern 仏教" do
      it_behaves_like "result size and vern corp author matches first", 'author', '仏教', 80, 90, /仏教/, 2
      context "w lang limit" do
        it_behaves_like "result size and vern corp author matches first", 'author', '仏教', 80, 90, /仏教/, 2, lang_limit
      end
    end
  end

  context "The Group to Record War Experiences (corp author)", :jira => 'VUF-2763' do
    # not sure if I have traditional and modern labelled correctly
    it_behaves_like "both scripts get expected result size", 'author', 'traditional', '戦争体験を記録する会', 'modern', '戦争体験を記錄する会', 4, 4
  end

  context "Jien (personal name)", :jira => 'VUF-2779' do
    # FIXME:  second character of traditional doesn't translate to second char of 
    #  modern with ICU traditional->simplified    (see also japanese han variants)
    context "modern" do
      it_behaves_like "result size and vern person author matches first", 'author', '慈円', 10, 15, /慈円/, 3
    end
    context "traditional" do
      it_behaves_like "result size and vern person author matches first", 'author', '慈圓', 2, 15, /慈圓/, 1
    end
  end

  context "Keichū (personal name)", :jira => 'VUF-2772' do
    context "hiragana  けいちゅう" do
      it_behaves_like "expected result size", 'author', 'けいちゅう', 0, 5
      it_behaves_like "does not find irrelevant results", 'author', 'けいちゅう', '4227249'
    end
    # There are several kanji conversions, such as ”けいちゅう”　<=>  契沖,  傾注　 景中,  刑中, etc.,
    context "kanji  契沖" do
      it_behaves_like "result size and vern person author matches first", 'author', '契沖', 4, 7, /契沖/, 4
    end
  end

  context "Kuginuki (personal name): kanji surname  釘貫 (surname of 釘貫亨)" do
    it_behaves_like "good results for query", 'author', '釘貫', 1, 1, '7926218', 1
    it_behaves_like "good results for query", 'author', '釘貫亨', 1, 1, '7926218', 1
    it_behaves_like "good results for query", 'author', ' 釘  貫亨', 1, 1, '7926218', 1
  end

  context "South Manchurian Railroad Company", :jira => ['VUF-2736', 'VUF-2739'] do
    # FIXME:  some characters of traditional doesn't translate to modern with
    #  ICU traditional->simplified    (see also japanese han variants)
    context "modern" do
      it_behaves_like "expected result size", 'author', '南満州鉄道株式会社', 35, 45
    end
    context "traditional" do
      # Han simplified:  南滿洲鐵道株式会社
      it_behaves_like "result size and vern corp author matches first", 'author', '南滿洲鐵道株式會社', 690, 725, /(南滿洲鐵道株式會社|南滿洲鐵道株式会社)/, 100
      it_behaves_like "matches in vern corp authors first", 'author', '南滿洲鐵道株式會社', /南滿洲鐵道株式會社/, 6
    end
  end
  
  context "Sugawara no Takasue no Musume (personal name)", :jira => 'VUF-2765' do
    it_behaves_like "result size and vern person author matches first", 'author', '菅原孝標女', 35, 45, /菅原孝標女/, 19
  end
  
  context "Takahashi (common personal name)", :jira => 'VUF-2711' do
    it_behaves_like "result size and vern person author matches first", 'author', '高橋', 1021, 1075, /高橋/, 100
  end

end
