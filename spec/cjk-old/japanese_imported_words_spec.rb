# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Japanese: imported words", :japanese => true, :fixme => true do

  it "supotsu (sports) should get the same results as スポーツ" do
    resp = solr_resp_doc_ids_only({'q'=>'supotsu'}) # 67 in prod, 67 in soc
    resp.should have_at_least(65).documents
    resp.size.should be_within(10).of(solr_resp_doc_ids_only({'q'=>'スポーツ'}).size) # 8 in prod, 59 in soc
  end
  
end