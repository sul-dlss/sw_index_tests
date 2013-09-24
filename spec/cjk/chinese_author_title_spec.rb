# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Chinese Author Title", :chinese => true do

  context "author Yu, Pingbo + Red Chamber", :jira => 'VUF-2773' do
    # 俞平伯 Yu, Pingbo, author's name, 红楼梦 Red Chamber, a famous Chinese novel
    it_behaves_like "good results for query", 'everything', '俞平伯 红楼梦', 19, 25, ['4322255', '5790412', '4222223', '6696432', '6696429'], 20
    it_behaves_like "good results for query", 'everything', '俞平伯红楼梦', 19, 25, ['4322255', '5790412', '4222223', '6696432', '6696429'], 20
  end
  
  context "author Lü, Simian + title (Northern and Southern Dynasties)", :jira => 'VUF-2690' do
    # 呂思勉 is author, 两晋南北朝 is title
    it_behaves_like "good results for query", 'everything', '呂思勉两晋南北朝', 3, 5, ['6435414', '4205313'], 2
    it_behaves_like "matches in vern person authors first", 'everything', '呂思勉两晋南北朝', /呂思勉/, 2
    it_behaves_like "matches in vern short titles first", 'everything', '呂思勉两晋南北朝', /(两晋南北朝|兩晉南北朝)/, 1
  end

end