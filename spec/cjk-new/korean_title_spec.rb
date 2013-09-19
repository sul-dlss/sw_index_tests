# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Korean Titles", :korean => true do
  
  lang_limit = {'fq'=>'language:Korean'}

  context "History of Korean contemporary literature", :jira => 'VUF-2741' do
    shared_examples_for "good title results for 韓國現代文學史" do | query |
      # 7620045:  exact title:  Hanʼguk hyŏndae munhaksa  韓國現代文學史
      it_behaves_like 'good results for query', 'title', query, 5, 10, '7620045', 1, lang_limit
      # 7595618: title plus   Hanʼguk hyŏndae munhaksa kaegwan  韓國現代文學史槪觀
      it_behaves_like 'best matches first', 'title', query, '7595618', 2, lang_limit
      # 6317536: title plus (almost)   Hanʼguk hyŏndae munhak pipʻyŏngsa.  韓國現代文學批評史
      # 6317537: title plus (almost)  Hanʼguk hyŏndae munhak pipʻyŏngsa.  韓國現代文學批評史
      it_behaves_like 'best matches first', 'title', query, ['6317536', '6317537'], 7, lang_limit
      # 8802461: almost title  Han'guk hyŏndae yŏsŏng munhaksa  韓國 現代 女性 文學史 (History of Korean women’s contemporary literature) 
      it_behaves_like 'best matches first', 'title', query, '8802461', 5, lang_limit
      # 7595639: title with all but last char  Hanʼguk hyŏndae munhak yŏnpʻyo and  with publisher name 文學思想史
      # 9220810: title with all but last char  Han'guk hyŏndae munhak kwa sidae chŏngsin
      it_behaves_like 'best matches first', 'title', '韓國現代文學史', ['7595639', '9220810'], 7, lang_limit
      # FIXME:  should this be true?
      # 7596241: 246 in variant Chinese characters, 韓國現代文學大事典. There is no 史 (meaning history)
      #it_behaves_like 'best matches first', 'title', '韓國現代文學史', '7596241', 10, lang_limit
    end
    context "韓國現代文學史 (no spaces)" do
      it_behaves_like "good title results for 韓國現代文學史", '韓國現代文學史'
    end
    context "韓國  現代  文學史 (with spaces)" do
      it_behaves_like "good title results for 韓國現代文學史", '韓國  現代  文學史'
    end
  end # History of Korean contemporary literature, VUF-2741

end