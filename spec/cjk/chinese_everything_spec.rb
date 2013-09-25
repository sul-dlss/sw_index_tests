# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Chinese Everything", :chinese => true do

  context "china economic policy", :jira => 'SW-100' do
    it_behaves_like "both scripts get expected result size", 'everything', 'traditional', '中國經濟政策', 'simplified', '中国经济政策', 250, 300
    it_behaves_like "matches in vern short titles first", 'everything', '中國經濟政策', /^中國經濟政策$/, 1
    it_behaves_like "matches in vern short titles first", 'everything', '中國經濟政策', /(中國經濟政策|中国经济政策)/, 6
    it_behaves_like "both scripts get expected result size", 'everything', 'traditional', '中國 經濟 政策', 'simplified', '中国 经济 政策', 200, 250
    it_behaves_like "matches in vern short titles first", 'everything', '中國 經濟 政策', /^中國經濟政策$/, 1
    it_behaves_like "matches in vern short titles first", 'everything', '中國 經濟 政策', /(中國經濟政策|中国经济政策)/, 6
  end

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
  
  context "women marriage", :jira => 'SW-100' do
    it_behaves_like "both scripts get expected result size", 'everything', 'traditional', '婦女婚姻', 'simplified', '妇女婚姻', 25, 40
    it_behaves_like "both scripts get expected result size", 'everything', 'traditional', '婦女 婚姻', 'simplified', '妇女 婚姻', 25, 40
  end

end