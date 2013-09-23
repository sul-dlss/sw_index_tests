# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Japanese Katakana-Han translations", :japanese => true, :fixme => true do

  lang_limit = {'fq'=>'language:Japanese'}

  # TODO:  we have no such translations at this time

  context "manchuria", :jira => ['VUF-2712', 'VUF-2713'] do
    # see also japanese_everything spec for these searches
    it_behaves_like "both scripts get expected result size", 'everything', 'katakana', 'マンチュリヤ', 'kanji', '満洲', 350, 425
  end

end