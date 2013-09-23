# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Japanese Author Searches", :japanese => true do

  lang_limit = {'fq'=>'language:Japanese'}
  
  context "buddhism", :jira => 'VUF-2723' do
    # corporate author
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
  
  context "高橋 (common personal name)", :jira => 'VUF-2711' do
    it_behaves_like "expected result size", 'author', '高橋', 1021, 1050
  end
  context "personal name  契沖", :fixme => true do
    it_behaves_like "both scripts get expected result size", 'author', 'kanji', '契沖', 'hiragana', 'けいちゅう', 5, 5
  end
  context "personal name: kanji surname  釘貫 (surname of 釘貫亨)" do
    it_behaves_like "expected result size", 'author', '釘貫', 1, 1
    it_behaves_like "expected result size", 'author', '釘貫亨', 1, 1
  end
  context "South Manchurian Railroad Company", :jira => ['VUF-2736', 'VUF-2739'], :fixme => true do
    it_behaves_like "both scripts get expected result size", 'author', 'modern', '南満州鉄道株式会社', 'traditional', '南滿洲鐵道株式會社', 400, 700
  end
  
end