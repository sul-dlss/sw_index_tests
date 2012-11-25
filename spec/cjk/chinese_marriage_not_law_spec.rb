# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'rspec-solr'

describe "Chinese: Word Breaks - Marriage NOT Marriage Law", :chinese => true, :fixme => true, :wordbreak => true do

  context " 婚姻法 (marriage law) in sirsi dict, but 婚姻 (marriage) is what we wanted" do
    #  妇女 (woman)  婚姻 (marriage) dictionary length-first match misses (but should match):
    #   4200804   woman 245c, 710a;  marriage 245a, 710a  (245 first 3 chars 婚姻法 are indexed together)
    
  end
  
end