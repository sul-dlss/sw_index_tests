# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Author Search" do
  
  it "Corporate author should be included in author search", :jira => 'VUF-633' do
    resp = solr_resp_doc_ids_only(author_search_args('Anambra State'))    
    resp.should have_at_least(80).documents
    # other examples:  "Plateau State", tanganyika, gold coast
  end
  
  it "Thesis advisors (720 fields) should be included in author search", :jira => 'VUF-433' do
    resp = solr_response(author_search_args('Zare').merge({'fl'=>'id,format,author_person_display', 'fq'=>'format:Thesis', 'facet'=>false}))
    resp.should have_at_least(100).documents
    resp.should_not include("author_person_display" => /\bZare\W/).in_each_of_first(20).documents
  end
  
  it "added authors (700 fields) should be included in author search", :jira => 'VUF-255' do
    resp = solr_resp_doc_ids_only(author_search_args('jane hannaway'))
    resp.should include("2503795")
    resp.should have_at_least(8).documents
  end
  
  it "added authors (700 fields) : author search for jane austen should get video results", :jira => 'VUF-255' do
    resp = solr_response(author_search_args('jane austen').merge({'fl'=>'id,format,author_person_display', 'facet.field'=>'format'}))
    resp.should have_at_least(275).documents
    resp.should have_facet_field("format").with_value("Video")
  end
  
  it "unstemmed author names should precede stemmed variants", :jira => ['VUF-120', 'VUF-433'] do
    resp = solr_response(author_search_args('Zare').merge({'fl'=>'id,author_person_display', 'facet'=>false}))
    resp.should include("author_person_display" => /\bZare\W/).in_each_of_first(3).documents
    resp.should_not include("author_person_display" => /Zaring/).in_each_of_first(20).documents
  end
  
  it "non-existent author 'jill kerr conway' should get 0 results" do
    resp = solr_resp_doc_ids_only(author_search_args('jill kerr conway'))
    resp.should have(0).documents
  end
  
  it "Wender, Paul A. should not get results for Wender, Paul H", :jira => 'VUF-1398' do
    resp = solr_resp_doc_ids_only(author_search_args('"Wender, Paul A., "').merge({:rows => 150}))
    resp.should have_at_least(75).documents
    resp.should have_at_most(125).documents
    paul_h_docs = ["9242084", "781472", "8923874", "7323029", "750072", "7706164"]
    paul_h_docs.each { |doc_id| resp.should_not include(doc_id) }
    resp = solr_resp_doc_ids_only(author_search_args('"Wender, Paul H., "'))
    resp.should have_at_most(10).documents
    resp.should include(paul_h_docs)
  end
  
  # note: this test is pretty bad
  it "Ivanov Viacheslav has multiple formats", :jira => 'VUF-2280' do
    resp = solr_resp_doc_ids_only(author_search_args('Ivanov, Vi͡acheslav Vsevolodovich'))
    resp.should have_at_least(55).documents
    resp.should have_at_most(75).documents
    resp = solr_resp_doc_ids_only(author_search_args('Ivanov, V. I. (Vi͡acheslav Ivanovich), 1866-1949'))
    resp.should have_at_least(50).documents
    resp.should have_at_most(65).documents
    resp = solr_resp_doc_ids_only(author_search_args('Ivanov Viacheslav'))
    resp.should have_at_least(100).documents
  end
  
  it "Marshall, Deborah", :jira => 'VUF-1185' do
    resp = solr_resp_doc_ids_only(author_search_args('"Marshall, Deborah"'))
    resp.should have_at_most(10).documents
    resp.should include(["1073585", "7840544"])
    resp.should_not include("7929478")
  end
  
  it "period after initial shouldn't matter" do
    resp = solr_resp_doc_ids_only(author_search_args('jill k. conway'))
    resp.should include('4735430')
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(author_search_args('jill k conway')))
  end
  
  it "author matches should appear before editor matches" do
    resp = solr_resp_doc_ids_only(author_search_args('jill k. conway'))
    # author before editor
    resp.should include(['1490381', '1302403', '861080', '1714776', '2911421', '2937495', '3063723', '3832670', '4735430']).before('4343662')
    # editor
    resp.should include(['4343662', '1714390', '2781921'])
    #  in metadata, but not as author
    # book about her, with name in title spelled Ker
    resp.should_not include('5826712')
    # the next two are in spanish and have the name in the 505a
    resp.should_not include('3159425')
    resp.should_not include('4529441')
  end
  
end