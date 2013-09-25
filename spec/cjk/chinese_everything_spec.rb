# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Chinese Everything", :chinese => true do

  context "Chu Anping", :jira => 'VUF-2689' do
    # see also chinese_han_variants spec, as there are two traditional forms of the second character
    it_behaves_like "good results for query", 'everything', '储安平', 22, 30, ['6710188', '6342768', '6638798'], 25, 'rows' => 25
  end

  context "Nanyang or Nanʼyō", :jira => 'SW-100' do
    it_behaves_like "result size and vern short title matches first", 'everything', '南洋', 750, 825, /南洋/, 100
    it_behaves_like "matches in vern titles", 'everything', '南洋', /南洋群島/, 20
    # Nan'yō Guntō
    it_behaves_like "result size and vern short title matches first", 'everything', '南洋群島', 50, 60, /南洋群島/, 15
    it_behaves_like "good results for query", 'everything', '椰風蕉雨話南洋', 1, 1, '5564542', 1
  end

end