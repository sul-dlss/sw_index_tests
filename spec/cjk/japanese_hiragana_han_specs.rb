# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Japanese Hiragana-Han translations", :japanese => true, :fixme => true do

  lang_limit = {'fq'=>'language:Japanese'}

  # TODO:  we have no such translations at this time

  context "personal name (hiragana)  けいちゅう", :jira => 'VUF-2772' do
    # "There are several kanji conversions, such as ”けいちゅう”　<=>  契沖,  傾注　 景中,  刑中, etc.,
    # and if "けいちゅう" retrieves all that, the search results may be too inclusive & not useful"
    it_behaves_like "both scripts get expected result size", 'author', 'hiragana', 'けいちゅう', 'kanji', '契沖', 5, 5
    context "hiragana  けいちゅう", :fixme => true do
      it_behaves_like "expected result size", 'author', 'けいちゅう', 0, 5
      it_behaves_like "does not find irrelevant results", 'author', 'けいちゅう', '4227249'
    end
  end
  
  # hiragana-kanji:  see 'lantern shop' title search, :jira => 'VUF-2702'
  

end