# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Korean spacing", :korean => true do

  context "Korea-U.S. alliance relations in the 21st century", :jira => 'VUF-2747' do
    shared_examples_for "good title results for 21세기의  한미동맹관계" do | query |
      it_behaves_like 'good results for query', 'title', query, 1, 10, '8375648', 1
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
        it_behaves_like 'good results for query', 'everything', '한미동맹', 1, 30, '8375648', 10
      end
      context "한미 동맹", pending: 'fixme', skip: true do
        # FIXME:  8375648 is not in these results!
        it_behaves_like 'good results for query', 'everything', '한미 동맹', 1, 30, '8375648', 30
        it_behaves_like "expected result size", 'everything', '한미 동맹', 1, 30
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
        it_behaves_like 'good results for query', 'title', '꿈꾸는 자 가 창조한다', 1, 5, '7378874', 1
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
        it_behaves_like 'good results for query', 'everything', '꿈꾸는 자 가 창조한다', 1, 20, '7378874', 1
      end
      context "꿈꾸는 자가 창조 한다" do
        it_behaves_like "good results for 꿈꾸는 자가 창조한다", 'everything', '꿈꾸는 자가 창조 한다'
      end
      context "꿈꾸는 자가 창 조한다 (but Korean writing would not give space between 창 and 조 )" do
        it_behaves_like "good results for 꿈꾸는 자가 창조한다", 'everything', '꿈꾸는 자가 창 조한다'
      end
      context "꿈꾸는 자가 창조한 다 (but Korean writing would not give space between 한 and 다)" do
        it_behaves_like 'good results for query', 'everything', '꿈꾸는 자가 창조한 다', 1, 2, '7378874', 1
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
    context "강물 이 될 때 까지 (as in the record)", fixme: true do
      # per Korean cataloger, the results should not include ckey 12437806.
      it_behaves_like "good results for 강물이될때까지", '강물 이 될 때 까지'
    end
  end # until the river  VUF-2744


  context "Korean Home Bank  한국주택은행" do
    shared_examples_for "good results for 한국주택은행" do | query |
      it_behaves_like "good results for query", 'everything', query, 2, 2, '7682995', 1
      it_behaves_like "best matches first", 'everything', query, '9163994', 2
    end
    context "한국주택은행 (no spaces)" do
      it_behaves_like "good results for 한국주택은행", '한국주택은행'
    end
    context "한국  주택  은행 (2 spaces)" do
      it_behaves_like "good results for 한국주택은행", '한국 주택 은행'
    end
    context "한국  주택은행 (first spaces)" do
      it_behaves_like "good results for 한국주택은행", '한국 주택은행'
    end
    context "한국주택  은행 (last space)" do
      it_behaves_like "good results for 한국주택은행", '한국주택 은행'
    end
  end # Korean Home Bank


  context "Korean economy" do
    shared_examples_for "good results for 한국경제" do | query |
      it_behaves_like "expected result size", 'everything', query, 850, 1150
      # no spaces, exact 245a
      it_behaves_like 'best matches first', 'everything', query, '6812133', 7
      # spaces, exact 245a
      it_behaves_like 'best matches first', 'everything', query, ['7912628', '8802925'], 7
    end
    context "한국경제 (no spaces)" do
      it_behaves_like "good results for 한국경제", '한국경제'
    end
    context "한국 경제 (space)" do
      it_behaves_like "good results for 한국경제", '한국 경제'
    end
  end # Korean economy


  context "Korean economic future and the survival strategies" do
    shared_examples_for "good results for 한국경제의미래와생존전략" do | query |
      it_behaves_like "good results for query", 'everything', query, 1, 1, '9323348', 1
    end
    shared_examples_for "good results for 한국  경제의  미래와  생존  전략" do | query |
      it_behaves_like "good results for query", 'everything', query, 1, 10, '9323348', 1
    end
    context "한국경제의미래와생존전략 (no spaces)" do
      it_behaves_like "good results for 한국경제의미래와생존전략", '한국경제의미래와생존전략'
    end
    context "한국경제의  미래와  생존전략 (2 spaces)" do
      it_behaves_like "good results for 한국경제의미래와생존전략", '한국경제의  미래와  생존전략'
    end
    context "한국  경제의  미래와  생존  전략 (4 spaces)" do
      it_behaves_like "good results for 한국  경제의  미래와  생존  전략", '한국  경제의  미래와  생존  전략'
    end
    context "한국 경제 의 미래 와 생존 전략 (6 spaces)" do
      it_behaves_like "good results for 한국  경제의  미래와  생존  전략", '한국 경제 의 미래 와 생존 전략'
    end
  end # Korean economic future and the survival strategies

  context "As I listened" do
    shared_examples_for "good results for 귀를 기울이면" do | query |
      it_behaves_like "expected result size", 'everything', query, 1, 40
    end
    context "귀를 기울이면 (normal spacing)" do
      it_behaves_like "good results for 귀를 기울이면", '경계에서'
    end
    context "귀 를 기울이면 (spacing in catalog)" do
      it_behaves_like "good results for 귀를 기울이면", '귀 를 기울이면'
      it_behaves_like "best matches first", 'everything', '귀 를 기울이면', '9439991', 2
    end
    context "귀를기울이면 (no spaces)" do
      it_behaves_like "good results for 귀를 기울이면", '귀를기울이면'
      it_behaves_like "best matches first", 'everything', '귀를기울이면', '9439991', 2
    end
  end # As I listened


  context "Korean economy at the turning point" do
    shared_examples_for "good results for 전환기의 한국경제" do | query |
      it_behaves_like "good results for query", 'everything', query, 3, 800, '7132960', 1
    end
    context "전환기의 한국경제  (normal spacing)" do
      it_behaves_like "good results for 전환기의 한국경제", '전환기의 한국경제'
      it_behaves_like "best matches first", 'everything', '전환기의 한국경제', '7774509', 2  # 245b
      it_behaves_like "best matches first", 'everything', '전환기의 한국경제', '9724831', 5 # almost 245b
    end
    context "전환기 의 한국 경제 (spacing in catalog)" do
      it_behaves_like "good results for 전환기의 한국경제", '전환기 의 한국 경제'
    end
  end # Korean economy at the turning point
  context "Korea today" do
    shared_examples_for "good results for 오늘의 한국" do | query |
      it_behaves_like "good results for query", 'everything', query, 50, 75, '9652283', 1
    end
    context "오늘의 한국 (normal spacing)" do
      it_behaves_like "good results for 오늘의 한국", '오늘의 한국'
    end
    context "오늘 의 한국 (spacing in catalog)" do
      it_behaves_like "good results for 오늘의 한국", '오늘 의 한국'
    end
  end # Korea today
  context "on the borderline" do
    shared_examples_for "good results for 경계에서" do | query |
      it_behaves_like "good results for query", 'everything', query, 7, 40, '8838252', 1
    end
    context "경계에서 (normal spacing)" do
      it_behaves_like "good results for 경계에서", '경계에서'
    end
    context "경계 에서 (spacing in catalog)" do
      it_behaves_like "good results for 경계에서", '경계 에서'
    end
  end # on the borderline
  context "World Inside Korea" do
    shared_examples_for "good results for 한국속의 세계" do | query |
      it_behaves_like "good results for query", 'everything', query, 12, 700, '7906866', 1
    end
    context "한국속의 세계 (normal spacing)" do
      it_behaves_like "good results for 한국속의 세계", '한국속의 세계'
    end
    context " (spacing in catalog)" do
      it_behaves_like "good results for 한국속의 세계", '한국 속 의 세계'
    end
  end # world inside korea
  context "Society of North Korea" do
    shared_examples_for "good results for 북한의 사회" do | query |
      it_behaves_like "good results for query", 'everything', query, 100, 150, ['9250730', '7158417'], 2
    end
    context "북한의 사회 (normal spacing)" do
      it_behaves_like "good results for 북한의 사회", '북한의 사회'
    end
    context "북한 의 사회 (spacing in catalog)" do
      it_behaves_like "good results for 북한의 사회", '북한 의 사회'
    end
  end # Society of North Korea
  context "New writings on understanding of contemporary North Korea" do
    shared_examples_for "good results for 새로 쓴 현대북한의 이해" do | query |
      it_behaves_like "good results for query", 'everything', query, 1, 2, '7755546', 1
    end
    context "새로 쓴 현대북한의 이해  (normal spacing)" do
      it_behaves_like "good results for 새로 쓴 현대북한의 이해", '새로 쓴 현대북한의 이해'
    end
    context "새로 쓴 현대 북한 의 이해 (spacing in catalog)" do
      it_behaves_like "good results for 새로 쓴 현대북한의 이해", '새로 쓴 현대 북한 의 이해'
    end
  end # New writings ...
  context "Contemporary North Korean literature" do
    shared_examples_for "good results for 북한의 현대문학" do | query |
      it_behaves_like "good results for query", 'everything', query, 4, 400, '6827379', 1
    end
    context "북한의 현대문학 (normal spacing)" do
      it_behaves_like "good results for 북한의 현대문학", '북한의 현대문학'
    end
    context "북한 의 현대 문학 (spacing in catalog)" do
      it_behaves_like "good results for 북한의 현대문학", '북한 의 현대 문학'
    end
  end # Contemporary North Korean literature
  context "Art History of the Choson dynasty" do
    shared_examples_for "good results for 조선미술사" do | query |
      it_behaves_like "good results for query", 'everything', query, 20, 40, '7676909', 1
    end
    context "조선미술사 (normal spacing)" do
      it_behaves_like "good results for 조선미술사", '조선미술사'
    end
    context "조선 미술사 (spacing in catalog)" do
      it_behaves_like "good results for 조선미술사", '조선 미술사'
    end
  end  # Art History of the Choson dynasty

  context "History of South Korea" do
    shared_examples_for "good results for 한국의 역사" do | query |
      it_behaves_like "expected result size", 'everything', query, 600, 850
    end
    context "한국의 역사 (normal spacing)" do
      it_behaves_like "good results for 한국의 역사", '한국의 역사'
    end
    context "한국 의 역사 (spacing in catalog)" do
      it_behaves_like "good results for 한국의 역사", '한국 의 역사'
    end
  end # History of South Korea

  context "Experience and the type of novel" do
    shared_examples_for "good results for 경험과 소설의 형식" do | query |
      it_behaves_like "good results for query", 'everything', query, 1, 15, '7875464', 1
    end
    context "경험과 소설의 형식 (normal spacing)" do
      it_behaves_like "good results for 경험과 소설의 형식", '경험과 소설의 형식'
    end
    context "경험 과 소설 의 형식 (spacing in catalog)" do
      it_behaves_like "good results for 경험과 소설의 형식", '경험 과 소설 의 형식'
    end
  end # Experience and the type of novel

  context "hangul + hancha" do
    context "Analysis of Korean economy" do
      shared_examples_for "good results for 韓國經濟의 分析" do | query |
        it_behaves_like "good results for query", 'everything', query, 5, 150, '6647380', 1
      end
      context "韓國經濟의 分析  (normal spacing)" do
        it_behaves_like "good results for 韓國經濟의 分析", '韓國經濟의 分析 '
      end
      context "韓國 經濟 의 分析 (spacing in catalog)" do
        it_behaves_like "good results for 韓國經濟의 分析", '韓國 經濟 의 分析'
      end
    end
    context "Beauty of Korea" do
      shared_examples_for "good results for 韓國의 美" do | query |
        it_behaves_like "good results for query", 'everything', query, 35, 65, '6665111', 1
      end
      context "韓國의 美  (normal spacing)" do
        it_behaves_like "good results for 韓國의 美", '韓國의 美'
      end
      context "韓國 의 美 (spacing in catalog)" do
        it_behaves_like "good results for 韓國의 美", '韓國 의 美'
      end
    end
    context "Economic management and characteristics of North Korea" do
      shared_examples_for "good results for 北韓의 經濟運營과 特性" do | query |
        it_behaves_like "good results for query", 'everything', query, 2, 2, ['6628055', '9342302'], 2
      end
      context "北韓의 經濟運營과 特性  (normal spacing)" do
        it_behaves_like "good results for 北韓의 經濟運營과 特性", '北韓의 經濟運營과 特性'
      end
      context "北韓 의 經濟 運營 과 特性 (spacing in catalog)" do
        it_behaves_like "good results for 北韓의 經濟運營과 特性", '北韓 의 經濟 運營 과 特性'
      end
    end
    context "Right to speak in the Choson dynasty period" do
      shared_examples_for "good results for 鮮時代의 言權" do | query |
        it_behaves_like "good results for query", 'everything', query, 1, 50, '6633303', 1
      end
      context "鮮時代의 言權 (normal spacing)" do
        it_behaves_like "good results for 鮮時代의 言權", '鮮時代의 言權'
      end
      context "朝鮮 時代 의 言權 (spacing in catalog)" do
        it_behaves_like "good results for 鮮時代의 言權", '朝鮮 時代 의 言權'
      end
    end
    context "開化期에서" do
      shared_examples_for "good results for 開化期에서" do | query |
        it_behaves_like "good results for query", 'everything', query, 1, 2, '7148651', 1
      end
      context "開化期에서 (normal spacing)" do
        it_behaves_like "good results for 開化期에서", '開化期에서'
      end
      context "開化期 에서 (spacing in catalog)" do
        it_behaves_like "good results for 開化期에서", '開化期 에서'
      end
    end
    context "韓民族의 主體性과 韓國史의 正統性" do
      shared_examples_for "good results for 韓民族의 主體性과 韓國史의 正統性" do | query |
        it_behaves_like "good results for query", 'everything', query, 1, 2, '7677363', 1
      end
      context "韓民族의 主體性과 韓國史의 正統性 (normal spacing)" do
        it_behaves_like "good results for 韓民族의 主體性과 韓國史의 正統性", '韓民族의 主體性과 韓國史의 正統性'
      end
      context "韓民族 의 主體性 과 韓國史 의 正統性 (spacing in catalog)" do
        it_behaves_like "good results for 韓民族의 主體性과 韓國史의 正統性", '韓民族 의 主體性 과 韓國史 의 正統性'
      end
    end
  end # hangul + hancha

end
