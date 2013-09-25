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

  context "Zhang, Ailing" do
    # simplified: 张爱玲 vs. traditional: 張愛玲 
    
  end

  context "Shao, Dongfang" do
    # simplified 邵东方  vs. traditional 邵東方  
  end

end