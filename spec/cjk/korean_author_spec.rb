# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Korean author", :korean => true do

  context "Ŭn, Hŭi-gyŏng  은희경", :jira => 'VUF-2729' do
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
                #'6972331', # only has author in 700 field
                '10561883', # has author in more fields, ranks higher
              ]
    irrelevant = ['10150829', # has one contributor with last name, another contributor with first name
                  '9588786',  # has 3 chars jumbled in 710:  경희 대학교. 밝은 사회 연구소
                  ]
    shared_examples_for "good author results for 은희경" do | query |
      it_behaves_like 'good results for query', 'author', query, 15, 30, relevant, 20 # 6972331 appears as 21
      it_behaves_like 'does not find irrelevant results', 'author', query, irrelevant
    end
    context "은희경 (no spaces)" do
      it_behaves_like "good author results for 은희경", '은희경'
    end
    context "은 희경 (spaces:  은: last name  희경:first name)" do
      it_behaves_like "good author results for 은희경", '은희경'
    end
  end # Ŭn, Hŭi-gyŏng  VUF-2729


  context "Kang, In-ch'ŏl  강인철", :jira => 'VUF-2721' do
    chars_together_in_100 = ['6914120', '6724932']
    chars_w_space_in_100_space = ['9954769',  # as  강 인철
                              '9927817',
                              '8504300',
                              '9957716',
                              '7692263',
                              '10144316',
                              '10144263' ]
    shared_examples_for "good author results for 강인철" do | query |
      it_behaves_like 'good results for query', 'author', query, 13, 20, chars_together_in_100 + chars_w_space_in_100_space, 11
    end
    shared_examples_for "good everything results for 강인철" do | query |
      it_behaves_like 'good author results for 강인철', query
      in_245c = '9688452' # 245c has 편집 강 인철].
      in_245c_and_700 = '11987524'  # 245c has 편집 강 인철.
      it_behaves_like 'best matches first', 'everything', query, [in_245c, in_245c_and_700], 15
      chars_out_of_order = '9696801' #  철강인  in 245a, 246a
      it_behaves_like 'does not find irrelevant results', 'author', query, chars_out_of_order
    end
    context "author search" do
      context "강인철 (no spaces)" do
        it_behaves_like "good author results for 강인철", '강인철'
      end
      context "강 인철 (spaces:  강: last name  인철:first name)" do
        it_behaves_like "good author results for 강인철", '강 인철'
      end
    end
    context "everything search" do
      context "강인철 (no spaces)" do
        it_behaves_like "good everything results for 강인철", '강인철'
      end
      context "강 인철 (spaces:  강: last name  인철:first name)" do
        it_behaves_like "good everything results for 강인철", '강 인철'
      end
    end
  end # Kang, In-ch'ŏl  VUF-2721


  context "Han, Yŏng-u  한영우" do
    shared_examples_for "good author results for 한영우" do | query |
      it_behaves_like "expected result size", 'author', query, 29, 40
      #  7142656:   김영우 (different last name), and the character "한" appears in the "contributor" field, "한국 교육사 학회."
      it_behaves_like 'does not find irrelevant results', 'author', query, '7142656', 'rows' => 30
      it "author matches regex" do
        resp = solr_response({'q'=>cjk_q_arg('author', query), 'fl'=>'id,vern_author_person_display', 'facet'=>false, 'rows' => 30})
        expect(resp).to include({'vern_author_person_display' => /한[[:space:]]*영우/}).in_each_of_first(25)
      end
    end
    shared_examples_for "good everything results for 한영우" do | query |
      it_behaves_like "good author results for 한영우", query
      # FIXME ...
      # 5424507 245a:  "한・영우리문화용어집" means "Korean(한)-English(영) glossary of Korean culture
      # it_behaves_like 'does not find irrelevant results', 'everything', query, '5424507', 'rows' => 30
      # 6811565 (has ... 10년에대한영향평가와 우... in 245)
      it_behaves_like 'does not find irrelevant results', 'everything', query, '6811565', 'rows' => 25
    end
    context "author search" do
      context "한영우 (no spaces)" do
        it_behaves_like "good author results for 한영우", '한영우'
      end
      context "한 영우 (spaces: 한 last name, 영우 first name)" do
        it_behaves_like "good author results for 한영우", '한 영우'
      end
    end
    context "everything search" do
      context "한영우 (no spaces)" do
        it_behaves_like "good everything results for 한영우", '한영우'
      end
      context "한 영우 (spaces: 한 last name, 영우 first name)" do
        it_behaves_like "good everything results for 한영우", '한 영우'
      end
    end
  end # Han, Yŏng-u

end
