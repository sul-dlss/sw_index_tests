# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'rspec-solr'

describe "Chinese: Variant Characters", :chinese => true, :fixme => true do
  
  it "囯 vs  国" do
    resp = solr_resp_doc_ids_only({'q'=>'民囯时期社会调查丛编'}) # A (囯) is second char  # 1 in prod: 8593449, 2 in soc
    resp.should have_at_least(3).documents
    resp.should include(["8593449", "6553207"])
    resp.should include("8940619")  # has title 民国时期社会调查丛编 - B (国) is second char  # 1 in prod: 8940619, 1 in soc
    pending("need to implement regex matcher to look for  民国时期社会调查丛编  in vern_title_display-ish")
  end

=begin  
  it "敎 vs  教" do
    pending "to be implemented"
  end

  it "戦 vs  戰" do
    pending "to be implemented"
  end
  
  it "户 vs  戸" do
    pending "to be implemented"
  end
=end  
  
end