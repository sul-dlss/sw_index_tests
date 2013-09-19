# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Korean spacing", :korean => true do
  
  lang_limit = {'fq'=>'language:Korean'}

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

  context "author: Ŭn, Hŭi-gyŏng", :jira => 'VUF-2729' do
    shared_examples_for "good author results for 은희경" do | query |
      #  "top 15 results are all relevant for searches both with and without whitespace between author’s last and first name."
      relevant = ['9628681',
                  '8814719',
                  '7874461',
                  '8299426',
                  '9097174',
                  '8532805',
                  '8823369',
                  '7874535',
                  '7890077',
                  '7868363',
                  '7849970',
                  '8827330',
                  '7880024',
                  '7841550',
                  '6972331',
                ]
      it_behaves_like 'good results for query', 'author', query, 15, 30, relevant, 20
      irrelevant = ['10150829', # has one contributor with last name, another contributor with first name
                    '9588786',  # has 3 chars jumbled in 710:  경희 대학교. 밝은 사회 연구소
                    ]
      it_behaves_like 'does not find irrelevant results', 'author', query, irrelevant
    end
    context "은희경 (no spaces)" do
      it_behaves_like "good author results for 은희경", '은희경'
    end
    context "은 희경 (spaces:  은: last name  희경:first name)" do
      it_behaves_like "good author results for 은희경", '은희경'
    end
  end # author: Ŭn, Hŭi-gyŏng  VUF-2729

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


  context "phrases" do
    context "Korea's modern history", :jira => 'VUF-2722', :fixme => true do
      context '"“한국  근대사"' do
        it_behaves_like "expected result size", 'title', '"“한국  근대사"', 1, 1
        it_behaves_like "best matches first", 'title', '"“한국  근대사"', '8375648', 1
      end
    end
  end  # phrases
  
  context "mixed scripts" do
  end # mixed scripts

end