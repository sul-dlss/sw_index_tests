# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Chinese Author Title", :chinese => true do

  context "author + Red Chamber", :jira => 'VUF-2773' do
    it_behaves_like "good results for query", 'everything', '俞平伯 红楼梦', 19, 25, ['4322255', '5790412', '4222223', '6696432', '6696429'], 20
    it_behaves_like "good results for query", 'everything', '俞平伯红楼梦', 19, 25, ['4322255', '5790412', '4222223', '6696432', '6696429'], 20
  end

end