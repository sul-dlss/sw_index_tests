# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Chinese Han variants", :chinese => true, :fixme => true do

  context "Guangxu (pinyin input method vs our data)", :jira => ['VUF-2757', 'VUF-2751'] do
    # The Unicode code point of the "with dot" version (緖) is U+7DD6. And the code point for the "without dot" version (緒) is U+7DD2
    # In the Unicode standard, it is the "without dot" version (U+7DD2) that is linked to the simplified form (U+7EEA). The "with dot" version is not. 
    # We have more records with the "with dot" version than the "without dot" version. 
    it_behaves_like "both scripts get expected result size", 'everything', 'with dot', '光緖', 'without dot', '光緒', 5100, 5300
    it_behaves_like "both scripts get expected result size", 'everything', 'traditional (with dot)', '光緖', 'simplified', '光绪', 5100, 5300
    it_behaves_like "both scripts get expected result size", 'everything', 'without dot', '光緒', 'simplified', '光绪', 5100, 5300
    context "with dot U+7DD6  緖" do
      it_behaves_like "expected result size", 'everything', '光緖', 5100, 5300
    end
    context "without dot U+7DD2 緒" do
      it_behaves_like "expected result size", 'everything', '光緒', 5100, 5300
    end
    context "simplified U+7EEA 绪" do
      it_behaves_like "expected result size", 'everything', '光绪', 5100, 5300
    end
  end

end