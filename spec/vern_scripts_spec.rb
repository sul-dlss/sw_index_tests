# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Non-Latin, Non-CJK scripts" do
    
    # TODO:  vernacular with and without diacritics (greek, hebrew, arabic)
    
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

    it "Cyrillic: пушкин pushkin", :jira => 'VUF-489' do
      resp = solr_resp_doc_ids_only(title_search_args('пушкин pushkin'))
      resp.should have_at_least(50).documents # 128 in soc?  2012-08-16
      resp.should include(["7829897", "2972618", "7773771"])
# FIXME:  move this to a 490 search spec
#      resp.should include(["3420269"]) # last in relevance, from 490
# FIXME: stemming cyrillic?
      #  Пушкинa is not stemmed.  Пушкинa does not give the same results as a search for Пушкин.
    end

    it "should boost 880 fields less than their counterparts: 'searching'", :fixme => 'true' do
      #  There are two records:  4216963, 4216961  that have the word "search" in the 245, 
      # and also have the word "search" in the 880 vernacular 245 field. 
      # Because the term appears twice:  in the 245a and the corresponding 880a, these records are 
      # appearing first.  I think the solution will be to boost the "regular" instances of fields 
      # slightly more than the 880 vernacular instances of the same.
      resp = solr_resp_doc_ids_only(title_search_args('searching').merge({:rows => 100}))
      resp.should include("228732").before("4216963")  # 228732 has a 245a 'searching'
      resp.should include("228732").before("4216961")
    end

end