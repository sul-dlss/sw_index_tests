# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'rspec-solr'

describe "Non-Latin, Non-CJK scripts" do
    
    it "Hebrew (עברית)" do
      resp = solr_resp_doc_ids_only({'q'=>'עברית'})
      resp.should have_at_least(850).results
      resp.should include("3370152").in_first(3)
      resp.should have_fewer_results_than(solr_resp_doc_ids_only({'q'=>'ivrit'}))
    end
    
    it "Cyrillic:  Восемьсoт семьдесят один день" do
      resp = solr_resp_doc_ids_only({'q'=>'Восемьсoт семьдесят один день'})
      resp.should include("9091779")
    end

    it "Cyrillic: пушкин pushkin" do
      resp = solr_resp_doc_ids_only(title_search_args('пушкин pushkin'))
      resp.should have_at_least(50).documents # 128 in soc?  2012-08-16
      resp.should include(["7829897", "2972618", "7773771"])
    end

end