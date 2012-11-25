require 'spec_helper'

describe "journal titles" do

  it "nature as everything search", :jira => 'VUF-1515' do
    resp = solr_response({'q' => 'nature'}.merge({'fl'=>'id,title_display', 'facet'=>false}))
    resp.should include({'title_display' => /^Nature \[print\/digital\]\./}).in_first(3)
  end

  it "nature as title search" do
    resp = solr_response(title_search_args('nature').merge({'fl'=>'id,title_display', 'facet'=>false}))
    resp.should include({'title_display' => /^Nature \[print\/digital\]\./}).in_first(3)
  end

  it "nature (Natural stems to Nation) with format journal" do
    resp = solr_response(title_search_args('nature').merge({'fq' => 'format:"Journal/Periodical"', 'fl'=>'id,title_display', 'facet'=>false}))
    resp.should have_at_most(1100).documents
    resp.should include({'title_display' => /^Nature \[print\/digital\]\./}).in_first(5)
    resp.should include({'title_display' => /^Nature; international journal of science/}).in_first(5)
  end
  
  it "The Nation as everything search" do
    resp = solr_resp_doc_ids_only({'q' => 'The Nation'})
    resp.should include(['464445', '497417', '3448713']).in_first(4)
  end

  it "The Nation as title search", :fixme => true do
    resp = solr_resp_doc_ids_only(title_search_args('The Nation'))
    resp.should include(['464445', '497417', '3448713']).in_first(4)
  end

  it "The Nation (National stems to Nation) with format journal" do
    resp = solr_resp_doc_ids_only(title_search_args('The Nation').merge({'fq' => 'format:Journal/Periodical'}))
    resp.should include('3448713').in_first(3)
    resp.should include(['3448713', '497417']).in_first(5)
    resp.should include(['464445', '497417', '3448713']).in_first(7)
    # ISSN:  0027-8378
#    And I should get at least 1 of these ckeys in the first 3 results: "8963533, 464445, 497417, 3448713"
#    And I should get at least 2 of these ckeys in the first 5 results: "8963533, 464445, 497417, 3448713"
  end

  it "'Times of London' - common words ... as a phrase  (it's actually a newspaper ...)" do
    resp = solr_resp_doc_ids_only(title_search_args('"Times of London"').merge({'fq' => 'format:Newspaper'}))
    resp.should include(['425948', '425951']).in_first(3)
    # ISSN:  0140-0460
#    Then I should get at least 1 of these ckeys in the first 3 results: "3352297, 425948, 425951"
#    And I should get at least 3 of these ckeys in the first 10 results: "3352297, 425948, 425951"
  end
    
end