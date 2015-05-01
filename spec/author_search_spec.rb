# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Author Search" do
  
  context "Corporate author should be included in author search", :jira => 'VUF-633' do
    it "Anambra State, not a phrase" do
      resp = solr_resp_doc_ids_only(author_search_args 'Anambra State')
      resp.should have_at_least(85).documents
    end
    it "Anambra State, phrase" do
      resp = solr_resp_doc_ids_only(author_search_args '"Anambra State"')
      resp.should have_at_least(85).documents
    end
    it "Plateau State, not a phrase" do
      resp = solr_resp_doc_ids_only(author_search_args 'Plateau State')
      resp.should have_at_least(90).documents
    end
    it "Plateau State, phrase" do
      resp = solr_resp_doc_ids_only(author_search_args '"Plateau State"')
      resp.should have_at_least(90).documents
    end
    it "Gold Coast, not a phrase" do
      resp = solr_resp_doc_ids_only(author_search_args 'Gold Coast')
      resp.should have_at_least(210).documents
    end
    it "Gold Coast, phrase" do
      resp = solr_resp_doc_ids_only(author_search_args '"Gold Coast"')
      resp.should have_at_least(210).documents
    end
    it "tanganyika" do
      resp = solr_resp_doc_ids_only(author_search_args 'tanganyika')
      resp.should have_at_least(180).documents
    end
  end  
  
  it "Thesis advisors (720 fields) should be included in author search", :jira => 'VUF-433' do
    resp = solr_response(author_search_args('Zare').merge({'fl'=>'id,format,author_person_display', 'fq'=>'format:Thesis', 'facet'=>false}))
    resp.should have_at_least(100).documents
    resp.should_not include("author_person_display" => /\bZare\W/).in_each_of_first(20).documents
  end
  
  it "added authors (700 fields) should be included in author search", :jira => 'VUF-255' do
    resp = solr_resp_doc_ids_only(author_search_args 'jane hannaway')
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
    resp = solr_resp_doc_ids_only(author_search_args 'jill kerr conway')
    resp.should have(0).documents
  end
  
  it "Wender, Paul A. should not get results for Wender, Paul H", :jira => 'VUF-1398' do
    resp = solr_resp_doc_ids_only(author_search_args('"Wender, Paul A., "').merge({:rows => 150}))
    resp.should have_at_least(75).documents
    resp.should have_at_most(125).documents
    paul_h_docs = ["9242084", "781472", "10830886", "7323029", "750072", "7706164"]
    paul_h_docs.each { |doc_id| resp.should_not include(doc_id) }
    resp = solr_resp_doc_ids_only(author_search_args '"Wender, Paul H., "')
    resp.should have_at_most(10).documents
    resp.should include(paul_h_docs)
  end
    
  it "period after initial shouldn't matter" do
    resp = solr_resp_doc_ids_only(author_search_args 'jill k. conway')
    resp.should include('4735430')
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(author_search_args 'jill k conway'))
  end
  
  it "author matches should appear before editor matches" do
    resp = solr_resp_doc_ids_only(author_search_args 'jill k. conway')
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
  
  context "author name false drop across 2 700 fields" do
    context "deborah marshall", :jira => 'VUF-1185' do
      before(:all) do
        @correct = ['1073585', '7840544']
        @false_drop = '7929478'
      end
      it "author search, not phrase" do
        resp = solr_resp_doc_ids_only(author_search_args 'marshall, deborah')
        resp.should include(@correct).before(@false_drop)
      end
      it "author search, phrase" do
        resp = solr_resp_doc_ids_only(author_search_args '"marshall, deborah"')
        resp.should have_at_most(10).documents
        resp.should include(@correct)
        resp.should_not include(@false_drop)
      end
    end
    context "david sandlin", :jira => 'VUF-1418' do
      before(:all) do
        @correct = ['8610705', '8808239', '8808223', '8610706', '8610701']
        @false_drop = '2927066'
      end
      it "author search, not phrase" do
        resp = solr_resp_doc_ids_only(author_search_args 'david sandlin')
        resp.should include(@correct).before(@false_drop)
      end
      it "author search, phrase - words in wrong order", :fixme => true do
        resp = solr_resp_doc_ids_only(author_search_args '"david sandlin"')
        resp.should have_at_most(10).documents
        resp.should include(@correct)
        resp.should_not include(@false_drop)
      end
      it "author search, phrase - words in right order" do
        resp = solr_resp_doc_ids_only(author_search_args '"sandlin, david"')
        resp.should have_at_most(10).documents
        resp.should include(@correct)
        resp.should_not include(@false_drop)
      end     
    end
  end
  
  context "Vyacheslav Ivanov", :jira => ['VUF-2279', 'VUF-2280', 'VUF-2281'] do
    # there are at least three authors with last name Ivanov, first name Vyacheslav
    #  our official spelling of the desired one is Viacheslav
    it "author search Ivanov Viacheslav", :jira => 'VUF-2279' do
      # at least three authors with last name Ivanov, first name Vyacheslav
      resp = solr_resp_doc_ids_only(author_search_args 'Ivanov Viacheslav')
      resp.should have_at_least(100).documents
      resp.should have_at_most(150).documents
    end
    it "author search Vyacheslav Ivanov", :fixme => true do
      # this is "misspelled" per our data
      resp = solr_resp_doc_ids_only(author_search_args 'Vyacheslav Ivanov')
      resp.should have_results
    end
    # NOTE: there are two different authority headings for same one?
    it "author search Ivanov, Vi͡acheslav Vsevolodovich", :jira => 'VUF-2280' do
      resp = solr_resp_doc_ids_only(author_search_args 'Ivanov, Vi͡acheslav Vsevolodovich')
      resp.should have_at_least(55).documents
      resp.should have_at_most(75).documents
    end
    it "author search Ivanov, V. I. (Vi͡acheslav Ivanovich), 1866-1949", :jira => 'VUF-2280' do
      resp = solr_resp_doc_ids_only(author_search_args 'Ivanov, V. I. (Vi͡acheslav Ivanovich), 1866-1949')
      resp.should have_at_least(50).documents
      resp.should have_at_most(65).documents
    end
  end
  
  context "william dudley haywood <-> big bill haywood", :jira => 'VUF-2323' do
    it "author search big bill hayward" do
      resp = solr_resp_doc_ids_only(author_search_args 'big bill haywood')
      resp.should have_at_least(10).documents
      resp.should include('141584')
      resp.should have_at_most(50).documents
    end
    it "author phrase search  hayward, big bill " do
      resp = solr_resp_doc_ids_only(author_search_args '"haywood, big bill"')
      resp.should have_at_least(10).documents
      resp.should include('141584')
      resp.should have_at_most(50).documents
    end
    it "author search bill hayward" do
      resp = solr_resp_doc_ids_only(author_search_args 'bill haywood')
      resp.should have_at_least(10).documents
      resp.should include('141584')
      resp.should have_at_most(50).documents
    end
    # waiting for name authorities linkage
    it "author search william haywood", :fixme => true do
      resp = solr_resp_doc_ids_only(author_search_args 'william haywood')
      resp.should have_at_least(20).documents
      resp.should include('141584')
      resp.should have_at_most(50).documents
    end
    it "author phrase search  haywood william", :fixme => true do
      resp = solr_resp_doc_ids_only(author_search_args '"haywood, william"')
      resp.should have_at_least(20).documents
      resp.should include('141584')
      resp.should have_at_most(50).documents
    end
  end
  
  context "ransch-trill, barbara", :jira => 'VUF-165' do
    it "with and without umlaut" do
      resp = solr_resp_doc_ids_only(author_search_args 'ränsch-trill, barbara')
      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(author_search_args 'ransch-trill, barbara'))
      resp.should include(['5455737', '2911735'])
    end
    it "last name only, with and without umlaut" do
      resp = solr_resp_doc_ids_only(author_search_args 'ränsch-trill')
      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(author_search_args 'ransch-trill'))
      resp.should include(['5455737', '2911735'])
    end
  end
  
  context "johann david heinichen", :jira => 'VUF-1449' do
    it "author search" do
      resp = solr_resp_doc_ids_only(author_search_args('johann David Heinichen').merge({'fq' => 'format:Book'}))
      resp.should have_at_least(10).documents
      resp.should include(['9858935', '3301463'])
      resp.should have_at_most(25).documents
    end
    # the following is busted due to Solr edismax bug
    # https://issues.apache.org/jira/browse/SOLR-2649
    it "everything search with author and years", :fixme => true do
      resp = solr_resp_ids_from_query 'johann David Heinichen 1711 OR 1728'
      resp.should include(['9858935', '3301463'])
    end
    it "everything phrase search with author and years", :fixme => true do
      resp = solr_resp_ids_from_query '"Heinichen, johann David" 1711 OR 1728'
      resp.should include(['9858935', '3301463'])
    end
  end
  
  it "mark applebaum", :jira => 'VUF-89' do
    resp = solr_resp_doc_ids_only(author_search_args 'mark applebaum')
    resp.should have_at_least(85).documents
    resp.should have_at_most(150).documents
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(author_search_args 'applebaum, mark'))
  end
  
  context "name as author, not subject", :jira => 'VUF-1007' do
    it "jackson pollock" do
      resp = solr_resp_doc_ids_only(author_search_args('jackson pollock').merge({'rows'=>60}))
      resp.should have_at_least(40).results
      resp.should have_at_most(60).results
      resp.should include(['611300', '817515']) # name as author, but not subject
      resp.should include(['7837994', '7206001']) # name as both author and subject
      resp.should_not include(['4786630', '4298910']) # name as subject (but not as author)
      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(author_search_args('pollock jackson').merge({'rows'=>100})))
    end
    it "pollock, jackson, phrase" do
      resp = solr_resp_doc_ids_only(author_search_args('"pollock, jackson"').merge({'rows'=>60}))
      resp.should have_at_least(40).results
      resp.should have_at_most(60).results
      resp.should include(['611300', '817515']) # name as author, but not subject
      resp.should include(['7837994', '7206001']) # name as both author and subject
      resp.should_not include(['4786630', '4298910']) # name as subject (but not as author)
    end
    it "Pollock, Jackson, 1912-1956., phrase" do
      resp = solr_resp_doc_ids_only(author_search_args('"Pollock, Jackson, 1912-1956."').merge({'rows'=>60}))
      resp.should have_at_least(40).results
      resp.should have_at_most(60).results
      resp.should include(['611300', '817515']) # name as author, but not subject
      resp.should include(['7837994', '7206001']) # name as both author and subject
      resp.should_not include(['4786630', '4298910']) # name as subject (but not as author)
    end
  end
  
  context "contributor 710 with |k manuscript", :jira => ['SW-579', 'VUF-1684'] do
    it "phrase search", :fixme => true do
      resp = solr_resp_doc_ids_only(author_search_args('"Bibliothèque nationale de France. Manuscript. Musique 226. "'))
      resp.should include(['278333', '6288243'])
      resp.should have_at_most(5).results
    end
    it "non-phrase search" do
      resp = solr_resp_doc_ids_only(author_search_args('Bibliothèque nationale de France. Manuscript. Musique 226. '))
      resp.should include(['278333', '6288243'])
      resp.should have_at_most(5).results
    end
    it "everything phrase search" do
      resp = solr_resp_ids_from_query '"Bibliothèque nationale de France. Manuscript. Musique 226. "'
      resp.should include(['278333', '6288243'])
      resp.should have_at_most(5).results
    end
  end
  
  context "corporate author phrase search", :jira => 'VUF-1698' do
    it 'author "Institute for Mathematical Studies in the Social Sciences"' do
      resp = solr_resp_doc_ids_only(author_search_args('"Institute for Mathematical Studies in the Social Sciences"'))
      resp.should have_at_least(650).results
      resp.should have_at_most(900).results
    end
  end
  
  context "Deutsch, Alfred", :jira => 'VUF-1481' do
    # FIXME: finds authors across fields - alfred in one field, deutsch in another
    it "author search" do
      resp = solr_resp_doc_ids_only(author_search_args('Deutsch, Alfred'))
      resp.should include('509722').as_first
    end
    it "author search, phrase" do
      resp = solr_resp_doc_ids_only(author_search_args('"Deutsch, Alfred"'))
      resp.should include('509722').as_first
      resp.should have_at_most(5).results
    end
  end
  
end