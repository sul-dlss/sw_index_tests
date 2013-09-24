# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Japanese Series", :japanese => true do

  context "humorous", :jira => 'VUF-2753' do
    it_behaves_like "good results for query", 'series', 'ユニークな', 1, 3, '6329172', 1
    context "phrase" do
      it_behaves_like "good results for query", 'series', '"宣伝会議ユニークブックス"', 1, 3, '6329172', 1
    end
  end

end