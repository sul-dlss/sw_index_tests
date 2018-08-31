# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Japanese Unigrams", :japanese => true do

  # TODO:  want  hiragana, katakana

  lang_limit = {'fq'=>'language:Japanese'}

  context "Ran (Kurosawa movie)" do
    it_behaves_like "result size and vern short title matches first", 'title', '乱', 300, 400, /乱/, 4
    it_behaves_like "both scripts get expected result size", 'title', 'traditional', '亂', 'modern', '乱', 300, 400
    it_behaves_like "both scripts get expected result size", 'title', 'traditional', '亂', 'modern', '乱', 100, 200, lang_limit
    # 6260985 - modern;  4176905 - trad
    it_behaves_like "best matches first", 'title', '乱', ['6260985', '4176905'], 6
    it_behaves_like "best matches first", 'title', '亂', ['6260985', '4176905'], 6
  end

  context "Zen" do
    it_behaves_like "result size and vern short title matches first", 'title', '禅', 500, 800, /禅/, 4
    it_behaves_like "both scripts get expected result size", 'title', 'traditional', '禪', 'modern', '禅', 500, 800
    it_behaves_like "both scripts get expected result size", 'title', 'traditional', '禪', 'modern', '禅', 300, 450, lang_limit
    # 4193363 - modern;  6667691 - trad
    it_behaves_like "best matches first", 'title', '禅', ['4193363', '6667691'], 8, lang_limit
    # FIXME:  interesting that the sort order changes with the trad char ...
#    it_behaves_like "best matches first", 'title', '禪', ['4193363', '6667691'], 6, lang_limit
    it_behaves_like "best matches first", 'title', '禪', '6667691', 6, lang_limit
  end

end
