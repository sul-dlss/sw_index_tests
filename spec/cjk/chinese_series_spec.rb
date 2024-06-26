# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Chinese Series", :chinese => true do

  context "contemporary literary criticism", :jira => 'VUF-2768' do
    it_behaves_like "expected result size", 'series', '当代文学批评', 5, 15
    it_behaves_like "best matches first", 'series', '当代文学批评', ['9853238', '9652358', '10139659', '8931473'], 10
    context "phrase" do
      it_behaves_like "expected result size", 'series', '"当代文学批评"', 0, 0  # it is not the exact name of a series
      it_behaves_like "good results for query", 'series', '"九十年代文学批评丛书"', 1, 3, '4470843', 1
      it_behaves_like "good results for query", 'series', '"中國古代文學批評要籍叢書"', 1, 3, '11836877', 1
      it_behaves_like "good results for query", 'series', '"中国当代文学研究与批评书系"', 6, 8, ['9853238', '9652358', '10139659', '8931473'], 10
    end
  end

end
