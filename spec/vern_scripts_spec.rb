describe "Non-Latin, Non-CJK scripts" do
    
    # TODO:  vernacular with and without diacritics (greek, hebrew, arabic)
    
    it "Hebrew (עברית)" do
      resp = solr_resp_ids_from_query 'עברית'
      expect(resp.size).to be >= 850
      expect(resp).to include("3370152").in_first(5)
      expect(resp).to have_fewer_results_than(solr_resp_ids_from_query 'ivrit')
    end
    
    it "Cyrillic:  Восемьсoт семьдесят один день" do
      resp = solr_resp_ids_from_query 'Восемьсoт семьдесят один день'
      expect(resp).to include("9091779")
    end

    it "Cyrillic: пушкин pushkin", :jira => 'VUF-489' do
      resp = solr_resp_doc_ids_only(title_search_args('пушкин pushkin'))
      expect(resp.size).to be >= 50 # 128 in soc?  2012-08-16
      expect(resp).to include(["7829897", "2972618"])
# FIXME:  move this to a 490 search spec
#      resp.should include(["3420269"]) # last in relevance, from 490
# FIXME: stemming cyrillic?
      #  Пушкинa is not stemmed.  Пушкинa does not give the same results as a search for Пушкин.
    end

end
