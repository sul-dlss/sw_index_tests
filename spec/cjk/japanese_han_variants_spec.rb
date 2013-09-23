# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Japanese Kanji variants", :japanese => true, :fixme => true do

  lang_limit = {'fq'=>'language:Japanese'}

  context "modern Kanji != simplified Han" do
    context "Buddhism" do
      # First character of traditional doesn't translate to first char of modern with ICU traditional->simplified 
      context "buddhism", :jira => ['VUF-2724', 'VUF-2725'] do
        it_behaves_like "both scripts get expected result size", 'everything', 'traditional', '佛教', 'modern', '仏教', 2200, 2300
        it_behaves_like "result size and short title matches first", 'everything', '佛教', 2200, 2300, /(佛教|仏教)/, 20
        it_behaves_like "result size and short title matches first", 'everything', '仏教', 2200, 2300, /(佛教|仏教)/, 20
        context "w lang limit" do
          it_behaves_like "result size and short title matches first", 'everything', '佛教', 1000, 1100, /(佛教|仏教)/, 20, lang_limit
          it_behaves_like "result size and short title matches first", 'everything', '仏教', 1000, 1100, /(佛教|仏教)/, 20, lang_limit
        end
      end
    end
  end

end