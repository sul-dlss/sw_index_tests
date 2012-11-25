# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'rspec-solr'

describe "Chinese: Word Breaks", :chinese => true, :fixme => true, :wordbreak => true do
  
  # TODO:  two char terms.  three char terms.  longer terms.  phrase vs. non-phrase searching.
  # TODO:  phrase searches for bigram pieces in query.   Tests for single last character, too.

  # 中国地方志集成   breaks up to   中国  地方志   集成  (people's republic of china ?)
  # 
  # 245  9206370  5 char in sub a   is 2 + 1 + 2

  # women and marriage:  妇女  与   婚姻     妇女与婚姻
  #  title search with space:    5  zh_dict
  #  title search without space:  2  zh_dict_phrase
  #  

end