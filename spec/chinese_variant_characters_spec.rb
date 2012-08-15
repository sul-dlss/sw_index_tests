# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'rspec-solr'

describe "Chinese Searching - Variant Characters" do
  
  it "囯 vs  国" do
    resp = solr_resp_doc_ids_only({'q'=>'民囯时期社会调查丛编'}) # A (囯) is second char
    resp.should have_at_least(3).documents
    resp.should include("8940619")  # has title 民国时期社会调查丛编 - B (国) is second char
    pending("need to implement regex matcher to look for  民国时期社会调查丛编  in vern_title_display-ish")
  end
  
  it "敎 vs  教" do
    pending "to be implemented"
  end

  it "戦 vs  戰" do
    pending "to be implemented"
  end
  
  it "户 vs  戸" do
    pending "to be implemented"
  end
  
end