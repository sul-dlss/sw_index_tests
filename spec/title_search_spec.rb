# encoding: utf-8
require 'spec_helper'

describe "Title Search" do
  
  it "780t, 758t included in title search: japanese journal of applied physics", :jira => ['VUF-89', 'SW-441'] do
    resp = solr_resp_doc_ids_only(title_search_args('japanese journal of applied physics')) 
    resp.should include(["365562", "491322", "491323", "7519522", "7519487", "787934"]).in_first(8).results
    resp = solr_resp_doc_ids_only(title_search_args('japanese journal of applied physics').merge({:fq => 'format:"Journal/Periodical"'}))
    resp.should include(["7519522", "365562", "491322", "491323"]).in_first(5).results
    pending "need include_at_least in rspec-solr"
    resp.should include_at_least(4).of(["7519522", "365562", "491322", "491323", "7519487"]).in_first(5).results
  end
  
  it "780t, 758t included in title search: japanese journal of applied physics PAPERS", :jira => ['VUF-89', 'SW-441'] do
    resp = solr_resp_doc_ids_only(title_search_args('japanese journal of applied physics papers'))    
    resp.should include(["365562", "491322", "7519522", "8207522"]).in_first(8).results
    resp = solr_resp_doc_ids_only(title_search_args('japanese journal of applied physics papers').merge({:fq => 'format:"Journal/Periodical"'}))    
    resp.should include(["365562", "491322", "7519522", "8207522"]).in_first(5).results
  end
  
  it "780t, 758t included in title search: japanese journal of applied physics LETTERS", :jira => ['VUF-89', 'SW-441'] do
    resp = solr_resp_doc_ids_only(title_search_args('japanese journal of applied physics letters'))    
    resp.should include(["365562", "491323", "7519487", "8207522"]).in_first(8).results
    resp = solr_resp_doc_ids_only(title_search_args('japanese journal of applied physics letters').merge({:fq => 'format:"Journal/Periodical"'}))    
    resp.should include(["365562", "491323", "7519487", "8207522"]).in_first(5).results
  end

  it "780t, 758t included in title search: journal of marine biotechnology", :jira => 'SW-441' do
    # 4278409  780t
    # 1963062  785t
    resp = solr_resp_doc_ids_only(title_search_args('journal of marine biotechnology'))    
    resp.should include(["1963062", "4278409"]).in_first(3).results
    resp = solr_resp_doc_ids_only(title_search_args('journal of marine biotechnology').merge({:fq => 'format:"Journal/Periodical"'}))    
    resp.should include(["1963062", "4278409"]).in_first(3).results
  end
  
  it "130 field", :jira => 'VUF-596' do
    resp = solr_resp_ids_titles(title_search_args '"LEXIS. Rivista di poetica, retorica e comunicazione nella tradizione classica (Online)"')
    resp.should include('9143049')
    resp.should include("title_245a_display" => /LEXIS\. Rivista di poetica, retorica e comunicazione nella tradizione classica/i).in_each_of_first(1).documents
    resp.should have_at_most(3).documents
  end
  
  it "730 field", :jira => 'SW-596' do
    resp = solr_resp_ids_titles(title_search_args '"Huexotzinco codex"')
    resp.should include('4309468')
    resp.should include("title_245a_display" => /Huexotzinco/i).in_each_of_first(3).documents
    resp.should have_at_most(3).documents
  end
  
  it "Roman de Fauvel", :jira => 'SW-596' do
    resp = solr_resp_ids_titles(title_search_args '"Roman de Fauvel"')
    resp.should include('298416')
    resp.should include("title_245a_display" => /Roman de Fauvel/i).in_each_of_first(3).documents
    resp.should have_at_least(7).documents
    resp.should have_at_most(50).documents
  end
  
  it "erlking", :jira => 'VUF-89' do
    resp = solr_resp_doc_ids_only(title_search_args 'erlking')
    resp.should have_at_least(5).documents
    resp.should have_at_most(15).documents
  end
  
  it "mathis der maler", :jira => 'VUF-89' do
    resp = solr_resp_doc_ids_only(title_search_args 'mathis der maler')
    resp.should have_at_least(35).documents
    resp.should have_at_most(50).documents
  end
  
  it "seriousness", :jira => 'VUF-89' do
    resp = solr_resp_doc_ids_only(title_search_args 'seriousness')
    resp.should have_at_least(5).documents
    resp.should include('5796988').as_first
  end
  
  it "Concertos flute TWV 51:h1", :jira => 'VUF-89' do
    resp = solr_resp_doc_ids_only(title_search_args 'Concertos flute TWV 51:h1')
    resp.should include('6628978').as_first
    resp.should have_at_most(10).documents
  end
  
  it "Shape optimization and optimal design : proceedings of the IFIP conference", :jira => 'VUF-1995' do
    resp = solr_resp_ids_titles(title_search_args 'Shape optimization and optimal design : proceedings of the IFIP conference')
    resp.should include("title_245a_display" => /Shape optimization and optimal design/i).as_first
    resp.should have_at_most(25).documents
  end
  
  it "Grundlagen der Medienkommunikation", :jira => 'VUF-511' do
    # actually a series title and also a separate series search test
    resp = solr_resp_ids_titles(title_search_args 'Grundlagen der Medienkommunikation') 
    resp.should have_at_least(9).documents
  end
  
  it "Zeitschrift", :jira => 'VUF-511' do
    resp = solr_resp_ids_titles(title_search_args 'Zeitschrift')
    resp.should include('title_245a_display' => /^zeitschrift$/i).in_each_of_first(15)
    resp.should include(['4443145', '486819']) # has 245a of Zeitschrift
    resp = solr_resp_ids_titles(title_search_args 'Zeitschrift des historischen Vereines für Steiermark') # 246 of 4443145
    resp.should include('486819') # also has 245a of Zeitschrift
    resp.should have_at_least(10).results
  end
  
  context "Studies in History and Philosophy of Science", :jira => 'VUF-2003' do
    it "title search without the, phrase" do
      resp = solr_resp_doc_ids_only(title_search_args '"Studies in History and Philosophy of Science"')
      resp.should include('9902567').as_first  # _Studies in history and philosophy of science [digital]._
    end
    it "title search without the, not phrase" do
      resp = solr_resp_doc_ids_only(title_search_args 'Studies in History and Philosophy of Science')
      resp.should include('9902567').as_first  # _Studies in history and philosophy of science [digital]._
    end
    it "title search with the, phrase" do
      resp = solr_resp_ids_titles(title_search_args '"Studies in the History and Philosophy of Science"')
      resp.should include("title_245a_display" => /Studies in the History and Philosophy of Science/i).in_each_of_first(4).documents
    end
    it "title search with the, not phrase", :fixme => true do
      resp = solr_resp_ids_titles(title_search_args 'Studies in the History and Philosophy of Science')
      resp.should include("title_245a_display" => /Studies in the History and Philosophy of Science/i).in_each_of_first(4).documents
    end
  end
  
end