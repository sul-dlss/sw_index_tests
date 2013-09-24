# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Chinese Everything", :chinese => true do

  context "Chu Anping", :jira => 'VUF-2689' do
    # see also chinese_han_variants spec, as there are two traditional forms of the second character
    it_behaves_like "good results for query", 'everything', '储安平', 22, 30, ['6710188', '6342768', '6638798'], 25, 'rows' => 25
  end

end