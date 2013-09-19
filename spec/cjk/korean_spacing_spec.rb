# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Korean spacing", :korean => true do
  
  context "Korea-U.S. alliance relations in the 21st century", :jira => 'VUF-2747' do
    shared_examples_for "good title results for 21세기의  한미동맹관계" do | query |
      it_behaves_like 'good results for query', 'title', query, 1, 6, '8375648', 1
      it_behaves_like 'best matches first', 'title', query, '8567659', 3
    end
    shared_examples_for "good single result for 21세기의  한미동맹관계" do | query |
      it_behaves_like 'good results for query', 'title', "\"#{query}\"", 1, 1, '8375648', 1
    end    
    context "title searches" do
      context '21세기의  한미동맹관계  (most likely spacing by Koreans)' do
        it_behaves_like "good title results for 21세기의  한미동맹관계", '21세기의  한미동맹관계'
      end
      context '21세기의   한미   동맹관계  (second most likely spacing by Koreans)' do
#        it_behaves_like "good title results for 21세기의  한미동맹관계", '21세기의  한미  동맹관계'
        # split out here for FIXME issue
        it_behaves_like "expected result size", 'title', '21세기의  한미  동맹관계', 1, 6
        # FIXME:  it only gets the single response
        #  it_behaves_like "best matches first", 'title', '21세기의  한미  동맹관계', '8375648'
        it_behaves_like 'best matches first', 'title', '21세기의  한미  동맹관계', '8567659', 3
      end
      context '21세기의   한•미동맹관계  (as written in the book - a middle dot between 한 and 미)' do
        it_behaves_like "good title results for 21세기의  한미동맹관계", '21세기의   한•미동맹관계'
      end
      context '21세기  의  한,  미  동맹  관계  (in our record, per LC rules)' do
        it_behaves_like "good title results for 21세기의  한미동맹관계", '21세기  의  한,  미  동맹  관계'
      end
      context "21세기의 한미동맹  관계 (space between 한미동맹 and 관계)" do
        it_behaves_like "good single result for 21세기의  한미동맹관계", '21세기의 한미동맹  관계'
        # FIXME:  would expect below to work
        # it_behaves_like 'good title results for 21세기의  한미동맹관계', '21세기의 한미동맹  관계'
      end
      context "phrase searching" do
        context '"21세기의한미동맹관계"' do
          it_behaves_like "good single result for 21세기의  한미동맹관계", '21세기의한미동맹관계'
        end
        context '"21세기의  한미동맹관계"' do
          it_behaves_like "good single result for 21세기의  한미동맹관계", '21세기의  한미동맹관계'
        end
      end
    end # title searches
    context "keyword searches" do
      context "한미동맹" do
        it_behaves_like 'good results for query', 'everything', '한미동맹', 1, 25, '8375648', 5
      end
      context "한미 동맹" do
        # FIXME:  8375648 is not in these results!
        # it_behaves_like 'good results for query', 'everything', '한미 동맹', 1, 25, '8375648', 20
        it_behaves_like "expected result size", 'everything', '한미 동맹', 1, 25
      end
    end
  end   # Korea-U.S. alliance relations in the 21st century  VUF-2747


  context "Kkum kkunŭn cha ka chʻangjo handa", :jira => 'VUF-2700' do
    shared_examples_for "good results for 꿈꾸는 자가 창조한다" do | query_type, query |
      it_behaves_like 'good results for query', query_type, query, 1, 1, '7378874', 1
    end
    context "title" do
      context "꿈꾸는 자가 창조한다 (normal spacing by Koreans)" do
        it_behaves_like "good results for 꿈꾸는 자가 창조한다", 'title', '꿈꾸는 자가 창조한다'
      end
      context "꿈 꾸는 자가 창조한다" do
        it_behaves_like "good results for 꿈꾸는 자가 창조한다", 'title', '꿈 꾸는 자가 창조한다'
      end
      context "꿈꾸는 자 가 창조한다" do
        # it has additional results
        # it_behaves_like "good results for 꿈꾸는 자가 창조한다", 'title', '꿈꾸는 자 가 창조한다'
        it_behaves_like 'good results for query', 'title', '꿈꾸는 자 가 창조한다', 1, 3, '7378874', 1
      end
      context "꿈꾸는 자가 창조 한다" do
        it_behaves_like "good results for 꿈꾸는 자가 창조한다", 'title', '꿈꾸는 자가 창조 한다'
      end
      context "꿈꾸는 자가 창 조한다 (but Korean writing would not give space between 창 and 조 )" do
        it_behaves_like "good results for 꿈꾸는 자가 창조한다", 'title', '꿈꾸는 자가 창 조한다'
      end
      context "꿈꾸는 자가 창조한 다 (but Korean writing would not give space between 한 and 다)" do
        it_behaves_like "good results for 꿈꾸는 자가 창조한다", 'title', '꿈꾸는 자가 창조한 다'
      end
    end
    context "everything" do
      context "꿈꾸는 자가 창조한다 (normal spacing by Koreans)" do
        it_behaves_like "good results for 꿈꾸는 자가 창조한다", 'everything', '꿈꾸는 자가 창조한다'
      end
      context "꿈 꾸는 자가 창조한다" do
        # it has additional results
        # it_behaves_like "good results for 꿈꾸는 자가 창조한다", 'everything', '꿈 꾸는 자가 창조한다'
        it_behaves_like 'good results for query', 'everything', '꿈 꾸는 자가 창조한다', 1, 2, '7378874', 1
      end
      context "꿈꾸는 자 가 창조한다" do
        # it has additional results
        # it_behaves_like "good results for 꿈꾸는 자가 창조한다", 'everything', '꿈꾸는 자 가 창조한다'
        it_behaves_like 'good results for query', 'everything', '꿈꾸는 자 가 창조한다', 1, 10, '7378874', 1
      end
      context "꿈꾸는 자가 창조 한다" do
        it_behaves_like "good results for 꿈꾸는 자가 창조한다", 'everything', '꿈꾸는 자가 창조 한다'
      end
      context "꿈꾸는 자가 창 조한다 (but Korean writing would not give space between 창 and 조 )" do
        it_behaves_like "good results for 꿈꾸는 자가 창조한다", 'everything', '꿈꾸는 자가 창 조한다'
      end
      context "꿈꾸는 자가 창조한 다 (but Korean writing would not give space between 한 and 다)" do
        it_behaves_like "good results for 꿈꾸는 자가 창조한다", 'everything', '꿈꾸는 자가 창조한 다'
      end
    end
  end # Kkum kkunŭn cha ka chʻangjo handa  VUF-2700


  context "until the river", :jira => 'VUF-2744' do
    shared_examples_for "good results for 강물이될때까지" do | query |
      it_behaves_like 'good results for query', 'everything', query, 1, 1, '9097052', 1
    end
    context "강물이될때까지 (no spaces)" do
      it_behaves_like "good results for 강물이될때까지", '강물이될때까지'
    end
    context "강물이 될때까지 (space between  이 and 될)" do
      it_behaves_like "good results for 강물이될때까지", '강물이 될때까지'
    end
    context "강물이 될때 까지 (space between  이 and 될,  때 and 까)" do
      it_behaves_like "good results for 강물이될때까지", '강물이 될때 까지'
    end
    context "강물 이 될 때 까지 (as in the record)" do
      it_behaves_like "good results for 강물이될때까지", '강물 이 될 때 까지'
    end
  end # until the river  VUF-2744
  
  context "mixed scripts" do
  end # mixed scripts

end