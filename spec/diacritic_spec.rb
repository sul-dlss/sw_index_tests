# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'rspec-solr'

describe "Diacritics" do
    
  it "macron (Kuginuki Tōru)" do
    resp = solr_resp_doc_ids_only({'q'=>'Kuginuki, Tōru'}) # 1 in prod, 1 in soc
    resp.should include("7926218")
    resp2 = solr_resp_doc_ids_only({'q'=>'Kuginuki, Toru'}) # 1 in prod, 1 in soc
    resp2.should have_the_same_number_of_results_as(resp2)
    resp2.should include("7926218")
  end
  
end