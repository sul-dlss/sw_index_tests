# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Chinese Author", :chinese => true do

  context "Dong Quai" do
    it_behaves_like "both scripts get expected result size", 'author', 'traditional', '董橋', 'simplified', '董桥', 43, 50
    it_behaves_like "matches in vern person authors first", 'author', '董橋', /(董橋|董桥)/, 40
    it_behaves_like "matches in vern person authors first", 'author', '董桥', /(董橋|董桥)/, 40
  end

  context "(Fang, Baochuan)" do
    it_behaves_like "both scripts get expected result size", 'author', 'traditional', '方寶川', 'simplified', '方宝川', 7, 15
    trad = ['9388854', # 700a, 245c
            '6650839', # 700a, 245c
            '5727562', # 700a, 245c
            '5482057', # 700a, 245c
            '5468624', # 700a, 245c
            '9728468' # 700a, 245c
            ]
    simp = ['4160175', # 700a, 245c
            # '8243512' - in 710, not adjacent
          ]
    it_behaves_like "best matches first", 'author', '方寶川', trad, 8
    it_behaves_like "best matches first", 'author', '方宝川', trad, 8
    it_behaves_like "best matches first", 'author', '方寶川', simp, 8
    it_behaves_like "best matches first", 'author', '方宝川', simp, 8
  end

  context "Liang, Hong", :jira => 'VUF-2688' do
    it_behaves_like "both scripts get expected result size", 'author', 'traditional', '梁鴻', 'simplified', '梁鸿', 8, 15
    it_behaves_like "matches in vern person authors first", 'author', '梁鸿', /(梁鴻|梁鸿)/, 7
    it_behaves_like "matches in vern person authors first", 'author', '梁鸿', /^(梁鴻|梁鸿)[^[[:alpha:]]]*$/, 3
    context "phrase" do
      it_behaves_like "both scripts get expected result size", 'author', 'traditional', '"梁鴻"', 'simplified', '"梁鸿"', 10, 20
      it_behaves_like "matches in vern person authors first", 'author', '"梁鸿"', /(梁鴻|梁鸿)/, 7
      it_behaves_like "matches in vern person authors first", 'author', '"梁鸿"', /^(梁鴻|梁鸿)[^[[:alpha:]]]*$/, 3
    end
  end

  context "Liang, Shiqiu" do
    it_behaves_like "both scripts get expected result size", 'author', 'traditional', '梁實秋', 'simplified', '梁实秋', 75, 90
    it_behaves_like "matches in vern person authors first", 'author', '梁實秋', /^(梁實秋|梁实秋)[^[[:alpha:]]]*$/, 35
  end

  context "Shao, Dongfang", :jira => 'SW-207' do
    # simplified 邵东方  vs. traditional 邵東方
    it_behaves_like "both scripts get expected result size", 'author', 'traditional', '邵東方', 'simplified', '邵东方', 6, 15
    it_behaves_like "matches in vern person authors first", 'author', '邵東方', /^(邵東方|邵东方)[^[[:alpha:]]]*$/, 6
  end

  context "Zhang, Ailing", :jira => 'SW-207' do
    it_behaves_like "both scripts get expected result size", 'author', 'traditional', '張愛玲', 'simplified', '张爱玲', 65, 90
    it_behaves_like "matches in vern person authors first", 'author', '張愛玲', /^(張愛玲|张爱玲)[^[[:alpha:]]]*$/, 50
  end

end
