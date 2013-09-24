# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Japanese Unigrams", :japanese => true do
  
  # TODO:  want  hiragana, katakana
  
  context "Ran  乱 (modern)" do
    it_behaves_like "result size and vern short title matches first", 'title', '乱', 725, 800, /乱/, 4
    it_behaves_like "best matches first", 'title', '乱', '6260985', 4
  end

  context "Zen  禅 (modern)" do
    it_behaves_like "result size and vern short title matches first", 'title', '禅', 900, 1100, /禅/, 6
    it_behaves_like "best matches first", 'title', '禅', '4193363', 6
  end
  
end