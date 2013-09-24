# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Chinese Unigrams", :chinese => true do
  
  context "Gone with the Wind", :jira => 'VUF-2789' do
    it_behaves_like "result size and vern short title matches first", 'title', '飘', 120, 130, /(飘|飄)/, 2
  end

  context "Zen", :jira => 'VUF-2790' do
    it_behaves_like "result size and vern short title matches first", 'title', '禪', 900, 1100, /(禪|禅)/, 100
    it_behaves_like "both scripts get expected result size", 'title', 'traditional', '禪', 'modern', '禅', 900, 1100
  end
  
end