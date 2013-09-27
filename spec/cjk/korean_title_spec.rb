# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Korean Titles", :korean => true do
  
  lang_limit = {'fq'=>'language:Korean'}

  context "Hancha: History of Korean contemporary literature", :jira => 'VUF-2741' do
    shared_examples_for "good title results for 韓國現代文學史" do | query |
      # 7620045:  exact title:  Hanʼguk hyŏndae munhaksa  韓國現代文學史
      it_behaves_like 'good results for query', 'title', query, 5, 10, '7620045', 1, lang_limit
      # 7595618: title plus   Hanʼguk hyŏndae munhaksa kaegwan  韓國現代文學史槪觀
      it_behaves_like 'best matches first', 'title', query, '7595618', 2, lang_limit
      # 6317536: title plus (almost)   Hanʼguk hyŏndae munhak pipʻyŏngsa.  韓國現代文學批評史
      # 6317537: title plus (almost)  Hanʼguk hyŏndae munhak pipʻyŏngsa.  韓國現代文學批評史
      it_behaves_like 'best matches first', 'title', query, ['6317536', '6317537'], 7, lang_limit
      # 8802461: almost title  Han'guk hyŏndae yŏsŏng munhaksa  韓國 現代 女性 文學史 (History of Korean women’s contemporary literature) 
      it_behaves_like 'best matches first', 'title', query, '8802461', 7, lang_limit
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


  context "Hangul: film industry", :jira => 'VUF-2728' do
    shared_examples_for "good title results for 영화산업" do | query |
      # exact 영화 산업 starts 245a
      it_behaves_like 'good results for query', 'title', query, 9, 15, '7197421', 1
      # exact  영화 산업 ends 245a
      it_behaves_like 'best matches first', 'title', query, '9423181', 3
      # exact  영화 산업 or 영화산업 in middle of 245a
      it_behaves_like 'best matches first', 'title', query, ['6971471', '9724759', '7906632', '6827294', '9252364'], 7
      # both 2 char combos in title, but not together
      it_behaves_like 'best matches first', 'title', query, ['9925013', '9563618'], 10
    end
    context "영화산업 (no spaces)" do
      it_behaves_like "good title results for 영화산업", '영화산업'
    end
    context "영화  산업 (with spaces)" do
      it_behaves_like "good title results for 영화산업", '영화 산업'
      # (one 2 char combo in note field)
      it_behaves_like 'best matches first', 'title', '영화 산업', '7793893', 12
    end
  end # Hangul: film industry, VUF-2728


  context "Hangul: Korean modern history", :jira => 'VUF-2722' do
    shared_examples_for "good title results for 한국 근대사" do | query |
      it "titles match regex" do
        resp = solr_response({'q'=>cjk_q_arg('title', query), 'fl'=>'id,vern_title_display', 'facet'=>false} )
        resp.should include({'vern_title_display' => /한국[[:space:]]*근대[[:space:]]*사/i}).in_each_of_first(20)
      end
      # 세계 속 한국 근대사 (Korean modern history in the world)
      # 고쳐 쓴 한국 근대사 (Revised Korean modern history)
      # 한국 근현대사 강의 (lecture on Korean modern and contemporary history)  includes the subject but not exactly top relevant topic.
    
      # “한국 근대 의 사회 복지” (ckey: 6718961) and “통계로 본 한국 근현대사” (ckey: 6686526)
      it_behaves_like 'does not find irrelevant results', 'title', query, ['6718961', '6686526'], 'rows' => 45
    end
    context "한국 근대사 (space, not a phrase)" do
      it_behaves_like "expected result size", 'title', '한국 근대사', 200, 250
      it_behaves_like "good title results for 한국 근대사", '한국 근대사'
    end
    context '"한국 근대사" (phrase)' do
      it_behaves_like "expected result size", 'title', '"한국 근대사"', 40, 50
      it_behaves_like "good title results for 한국 근대사", '"한국 근대사"'
    end
  end # Hangul: Korean modern history   VUF-2722

end