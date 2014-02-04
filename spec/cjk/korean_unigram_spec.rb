# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Korean: Unigram Searches", :korean => true do
  # from email from Vitus, Aug 20, 2012

  context "title  창 (window)" do
    it_behaves_like "expected result size", 'title', '창', 300, 575
    before(:all) do
      @resp = solr_response({'q'=>cjk_q_arg('title', '창'), 'fl'=>'id,vern_title_245a_display', 'facet'=>false} )
    end
    it "titles should match regex" do
      @resp.should include({'vern_title_245a_display' => /^창$/}).as_first
      @resp.should include({'vern_title_245a_display' => /창/}).in_each_of_first(9).documents
    end
    it "should have expected ckeys" do
      @resp.should include("7875201").as_first
    end
  end
  
  context "title  꿈 (dream)" do
    it_behaves_like "expected result size", 'title', '꿈', 150, 200
    before(:all) do
      @resp = solr_response({'q'=>cjk_q_arg('title', '꿈'), 'fl'=>'id,vern_title_245a_display', 'facet'=>false, 'rows'=>75} )
    end
    it "titles should match regex" do
      @resp.should include({'vern_title_245a_display' => /꿈/}).in_each_of_first(75).documents
    end
  end
  
end