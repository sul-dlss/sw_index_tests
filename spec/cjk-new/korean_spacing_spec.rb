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
  end 


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