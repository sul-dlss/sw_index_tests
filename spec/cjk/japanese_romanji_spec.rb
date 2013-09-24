# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Japanese: imported words", :japanese => true, :fixme => true do

  it "word breaks for romanji (kanazukairon)" do
    resp = solr_resp_doc_ids_only({'q'=>'Kinsei kanazukairon'}) 
    resp.should include("7926218")
    resp2 = solr_resp_doc_ids_only({'q'=>'Kinsei kanazukai'})
    resp2.should have_at_least(resp.size).results  # 'Kinsei kanazukai'  also matches 6279261
    resp2.should include("7926218")
  end

  # "imported word"
  it "supotsu (sports) should get the same results as スポーツ" do
    resp = solr_resp_doc_ids_only({'q'=>'supotsu'}) # 67 in prod, 67 in soc
    resp.should have_at_least(65).documents
    resp.size.should be_within(10).of(solr_resp_doc_ids_only({'q'=>'スポーツ'}).size) # 8 in prod, 59 in soc
  end
  
  context "author name  釘貫亨   Kuginuki Toro" do
    it "shorter query string for romanji" do
      resp = solr_resp_doc_ids_only({'q'=>'Kuginuki Toro'})
      resp2 = solr_resp_doc_ids_only({'q'=>'Kuginuki'})
      resp2.should have_results
      resp.should have_the_same_number_of_results_as(resp2) 
    end
  end
  
end