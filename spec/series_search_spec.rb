# encoding: utf-8

require 'spec_helper'

describe "Series Search" do

  it "lecture notes in computer science" do
    resp = solr_resp_doc_ids_only(series_search_args 'lecture notes in computer science')
    expect(resp.size).to be >= 7500
    expect(resp.size).to be <= 9000
  end

  it "Lecture notes in statistics (Springer-Verlag)", :jira => 'VUF-1221' do
    resp = solr_resp_doc_ids_only(series_search_args 'Lecture notes in statistics (Springer-Verlag)')
    expect(resp.size).to be >= 175
    expect(resp.size).to be <= 300
  end

  it "Japanese journal of applied physics" do
    resp = solr_resp_doc_ids_only(series_search_args 'Japanese journal of applied physics')
    expect(resp.size).to be >= 15
    expect(resp.size).to be <= 30
  end

  it "Grundlagen der Medienkommunikation", :jira => 'VUF-511' do
    resp = solr_resp_doc_ids_only(series_search_args 'Grundlagen der Medienkommunikation')
    expect(resp.size).to be >= 9
  end

  context "Cahiers series", :jira => 'VUF-1031' do
    before(:all) do
      @exp_ids = ['8787894', '9503087', '10192127']
    end
    it "series search, phrase" do
      resp = solr_resp_doc_ids_only(series_search_args '"Cahiers series"')
      expect(resp.size).to be >= 30
      expect(resp).to include(@exp_ids)
      expect(resp.size).to be <= 70
    end
    it "everything search, phrase" do
      resp = solr_resp_ids_from_query '"Cahiers series"'
      expect(resp.size).to be >= 30
      expect(resp).to include(@exp_ids)
    end
  end

  context "Beiträge zur Afrikakunde", :jira => 'VUF-170' do
    it "series search, phrase" do
      resp = solr_resp_doc_ids_only(series_search_args '"Beiträge zur Afrikakunde"')
      expect(resp.size).to be >= 11
      expect(resp).to include(['1025630', '1554950', '2316903'])
      expect(resp.size).to be <= 125
    end
    it "everything search, phrase" do
      resp = solr_resp_ids_from_query '"Beiträge zur Afrikakunde"'
      expect(resp.size).to be >= 11
      expect(resp).to include(['1025630', '1554950', '2316903'])
      expect(resp.size).to be <= 125
    end
    it "everything search, not phrase" do
      resp = solr_resp_ids_from_query 'Beiträge zur Afrikakunde'
      expect(resp.size).to be >= 11
      expect(resp).to include(['1025630', '1554950', '2316903'])
      expect(resp.size).to be <= 125
    end
  end

  context "Macmillan series in applied computer science", :jira => 'VUF-170' do
    it "series search, phrase" do
      resp = solr_resp_doc_ids_only(series_search_args '"Macmillan series in applied computer science."')
      expect(resp).to include(['1173521', '615340'])
      expect(resp.size).to be <= 125
    end
    it "everything search, phrase" do
      resp = solr_resp_ids_from_query '"Macmillan series in applied computer science."'
      expect(resp).to include(['1173521', '615340'])
      expect(resp.size).to be <= 125
    end
    it "everything search, not phrase" do
      resp = solr_resp_ids_from_query 'Macmillan series in applied computer science.'
      expect(resp).to include(['1173521', '615340'])
      expect(resp.size).to be <= 125
    end
  end

  context "New Cambridge History of Islam", :jira => 'SW-830' do
    it "series search, phrase" do
      resp = solr_resp_doc_ids_only(series_search_args '"New Cambridge History of Islam"')
      expect(resp).to include(['9527411', '9527412', '9527413', '9527414', '9527415', '9527416'])
      expect(resp.size).to be <= 15
    end
    it "everything search, phrase" do
      resp = solr_resp_ids_from_query '"New Cambridge History of Islam"'
      expect(resp).to include(['9527411', '9527412', '9527413', '9527414', '9527415', '9527416'])
      expect(resp.size).to be <= 15
    end
  end

  context "Royal Institution Library of Science", :jira => 'VUF-1685' do
    it "series search, phrase" do
      resp = solr_resp_doc_ids_only(series_search_args '"Royal Institution Library of Science."')
      expect(resp).to include(['1728162', '1391145', '691907', '691908'])
      expect(resp.size).to be <= 10
    end
    it "everything search, phrase" do
      resp = solr_resp_ids_from_query '"Royal Institution Library of Science."'
      expect(resp).to include(['1728162', '1391145', '691907', '691908'])
      expect(resp.size).to be <= 10
    end
    it "add Bragg (an editor)" do
      resp = solr_resp_ids_from_query 'Royal Institution Library of Science bragg'
      expect(resp).to include(['691907', '691908']).in_first(2)
      # past mm threshold
      #resp.should have_at_most(10).results
    end
    it "add physical sciences" do
      resp = solr_resp_ids_from_query 'Royal Institution Library of Science physical sciences'
      expect(resp).to include(['691907', '691908']).in_first(5)
      # past mm threshold
      #resp.should have_at_most(10).results
    end
  end

  context "Studies in Modern Poetry", :jira => 'SW-688' do
    it "series search, phrase" do
      resp = solr_resp_doc_ids_only(series_search_args '"Studies in Modern Poetry"')
      expect(resp.size).to be >= 10
      expect(resp).to include(['5709847', '4075051', '3865171', '10109003', '7146913'])
      expect(resp.size).to be <= 25
    end
    it "everything search, phrase" do
      resp = solr_resp_ids_from_query  '"Studies in Modern Poetry"'
      expect(resp.size).to be >= 15
      expect(resp).to include(['5709847', '4075051', '3865171', '10338326', '7146913'])
    end
  end

  context "inclusion of series publication number", :jira => 'VUF-925' do
    it "series search, 490 field" do
      resp = solr_resp_doc_ids_only(series_search_args 'its proceedings 31')
      expect(resp).to include('2503462')
    end
    it "series search, 811 field" do
      resp = solr_resp_doc_ids_only(series_search_args 'international school of physics proceedings 31')
      expect(resp).to include('2503462')
    end
  end

end
