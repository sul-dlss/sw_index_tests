# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Japanese Hiragana-Han translations", :japanese => true do

  lang_limit = {'fq'=>'language:Japanese'}

  # TODO:  we have no such translations at this time

  context "personal name (hiragana)  けいちゅう", :jira => 'VUF-2772' do
    # "There are several kanji conversions, such as ”けいちゅう”　<=>  契沖,  傾注　 景中,  刑中, etc.,
    # and if "けいちゅう" retrieves all that, the search results may be too inclusive & not useful"
    it '', pending: 'fixme' do
      it_behaves_like "both scripts get expected result size", 'author', 'hiragana', 'けいちゅう', 'kanji', '契沖', 5, 5
    end
    context "hiragana  けいちゅう" do
      it_behaves_like "expected result size", 'author', 'けいちゅう', 0, 5
      it_behaves_like "does not find irrelevant results", 'author', 'けいちゅう', '4227249'
    end
  end
  
  # hiragana-kanji:  see 'lantern shop' title search, :jira => 'VUF-2702'

  context "tale", :jira => ['VUF-2705', 'VUF-2743', 'VUF-2742', 'VUF-2740'] do
    it '', pending: 'fixme' do
      it_behaves_like "both scripts get expected result size", 'title', 'hiragana', 'ものがたり', 'kanji', '物語', 5, 5
    end
    context "hiragana", :jira => ['VUF-2705', 'VUF-2743'] do
      it_behaves_like "expected result size", 'title', 'ものがたり', 60, 83
      it '', pending: 'fixme' do
        it_behaves_like "matches in vern short titles first", 'title', 'ものがたり', /ものがたり/, 35
      end
    end
    context "kanji", :jira => ['VUF-2705', 'VUF-2742', 'VUF-2740'] do
      # note:  Japanese do not use 语 (2nd char as simplified chinese) but rather 語
      it '', pending: 'fixme: potentially brittle range' do
        it_behaves_like "both scripts get expected result size", 'title', 'traditional', '物語', 'chinese simp', '物语', 2351, 2455
      end
      it_behaves_like "matches in vern titles first", 'title', '物語', /物語/, 13  # 14 is 4223454 which has it in 240a
    end
  end
end
