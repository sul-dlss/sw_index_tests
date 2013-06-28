# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Non-Latin, Non-CJK scripts" do
    
    # TODO:  vernacular with and without diacritics (greek, hebrew, arabic)
    
    it "Hebrew (עברית)" do
      resp = solr_resp_ids_from_query 'עברית'
      resp.should have_at_least(850).results
      resp.should include("3370152").in_first(3)
      resp.should have_fewer_results_than(solr_resp_ids_from_query 'ivrit')
    end
    
    it "Cyrillic:  Восемьсoт семьдесят один день" do
      resp = solr_resp_ids_from_query 'Восемьсoт семьдесят один день'
      resp.should include("9091779")
    end

    it "Cyrillic: пушкин pushkin", :jira => 'VUF-489' do
      resp = solr_resp_doc_ids_only(title_search_args('пушкин pushkin'))
      resp.should have_at_least(50).documents # 128 in soc?  2012-08-16
      resp.should include(["7829897", "2972618", "7773771"])
# FIXME:  move this to a 490 search spec
#      resp.should include(["3420269"]) # last in relevance, from 490
# FIXME: stemming cyrillic?
      #  Пушкинa is not stemmed.  Пушкинa does not give the same results as a search for Пушкин.
    end

end