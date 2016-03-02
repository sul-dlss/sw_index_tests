# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Japanese: imported words", :japanese => true, :fixme => true do

  it "word breaks for romanji (kanazukairon)" do
    resp = solr_resp_doc_ids_only({'q'=>'Kinsei kanazukairon'}) 
    expect(resp).to include("7926218")
    resp2 = solr_resp_doc_ids_only({'q'=>'Kinsei kanazukai'})
    expect(resp2.size).to be >= resp.size  # 'Kinsei kanazukai'  also matches 6279261
    expect(resp2).to include("7926218")
  end

  # "imported word"
  it "supotsu (sports) should get the same results as スポーツ" do
    resp = solr_resp_doc_ids_only({'q'=>'supotsu'}) # 67 in prod, 67 in soc
    expect(resp.size).to be >= 65
    expect(resp.size).to be_within(10).of(solr_resp_doc_ids_only({'q'=>'スポーツ'}).size) # 8 in prod, 59 in soc
  end
  
  context "author name  釘貫亨   Kuginuki Toro" do
    it "shorter query string for romanji" do
      resp = solr_resp_doc_ids_only({'q'=>'Kuginuki Toro'})
      resp2 = solr_resp_doc_ids_only({'q'=>'Kuginuki'})
      expect(resp2).to have_results
      expect(resp).to have_the_same_number_of_results_as(resp2) 
    end
  end
  
end