describe "Title Search" do

  it "780t, 758t included in title search: japanese journal of applied physics", :jira => ['VUF-89', 'SW-441'] do
    resp = solr_resp_doc_ids_only(title_search_args('japanese journal of applied physics'))
    expect(resp).to include(["365562", "491322", "491323", "7519522", "7519487", "787934"]).in_first(10).results
    resp = solr_resp_doc_ids_only(title_search_args('japanese journal of applied physics').merge({:fq => 'format:"Journal/Periodical"'}))
    expect(resp).to include(["7519522", "365562", "491322", "491323"]).in_first(5).results
#    pending "need include_at_least in rspec-solr"
#    resp.should include_at_least(4).of(["7519522", "365562", "491322", "491323", "7519487"]).in_first(5).results
  end

  it "780t, 758t included in title search: japanese journal of applied physics PAPERS", :jira => ['VUF-89', 'SW-441'] do
    resp = solr_resp_doc_ids_only(title_search_args('japanese journal of applied physics papers'))
    expect(resp).to include(["365562", "491322", "7519522", "8207522"]).in_first(8).results
    resp = solr_resp_doc_ids_only(title_search_args('japanese journal of applied physics papers').merge({:fq => 'format:"Journal/Periodical"'}))
    expect(resp).to include(["365562", "491322", "7519522", "8207522"]).in_first(5).results
  end

  it "780t, 758t included in title search: japanese journal of applied physics LETTERS", :jira => ['VUF-89', 'SW-441'] do
    resp = solr_resp_doc_ids_only(title_search_args('japanese journal of applied physics letters'))
    expect(resp).to include(["365562", "491323", "7519487", "8207522"]).in_first(8).results
    resp = solr_resp_doc_ids_only(title_search_args('japanese journal of applied physics letters').merge({:fq => 'format:"Journal/Periodical"'}))
    expect(resp).to include(["365562", "491323", "7519487", "8207522"]).in_first(5).results
  end

  it "780t, 758t included in title search: journal of marine biotechnology", :jira => 'SW-441' do
    # 4278409  780t
    # 1963062  785t
    resp = solr_resp_doc_ids_only(title_search_args('journal of marine biotechnology'))
    expect(resp).to include(["1963062", "4278409"]).in_first(3).results
    resp = solr_resp_doc_ids_only(title_search_args('journal of marine biotechnology').merge({:fq => 'format:"Journal/Periodical"'}))
    expect(resp).to include(["1963062", "4278409"]).in_first(3).results
  end

  it "730 field", :jira => 'SW-596' do
    resp = solr_resp_ids_titles(title_search_args '"Huexotzinco codex"')
    expect(resp).to include('4309468')
    expect(resp).to include("title_245a_display" => /Huexotzinco/i).in_each_of_first(3).documents
    expect(resp.size).to be <= 3
  end

  it "Roman de Fauvel", :jira => 'SW-596' do
    resp = solr_resp_ids_titles(title_search_args '"Roman de Fauvel"')
    expect(resp).to include('298416')
    expect(resp).to include("title_245a_display" => /Roman de Fauvel/i).in_each_of_first(3).documents
    expect(resp.size).to be >= 7
    expect(resp.size).to be <= 50
  end

  it "erlking", :jira => 'VUF-89' do
    resp = solr_resp_doc_ids_only(title_search_args 'erlking')
    expect(resp.size).to be >= 5
    expect(resp.size).to be <= 20
  end

  it "mathis der maler", :jira => 'VUF-89' do
    resp = solr_resp_doc_ids_only(title_search_args 'mathis der maler')
    expect(resp.size).to be >= 55
    expect(resp.size).to be <= 75
  end

  it "seriousness", :jira => 'VUF-89' do
    resp = solr_resp_doc_ids_only(title_search_args 'seriousness')
    expect(resp.size).to be >= 5
    expect(resp).to include('5796988').as_first
  end

  it "Concertos flute TWV 51:h1", :jira => 'VUF-89' do
    resp = solr_resp_doc_ids_only(title_search_args 'Concertos flute TWV 51:h1')
    expect(resp).to include('6628978').as_first
    expect(resp.size).to be <= 10
  end

  it "Shape optimization and optimal design : proceedings of the IFIP conference", :jira => 'VUF-1995' do
    resp = solr_resp_ids_titles(title_search_args 'Shape optimization and optimal design : proceedings of the IFIP conference')
    expect(resp).to include("title_245a_display" => /Shape optimization and optimal design/i).as_first
    expect(resp.size).to be <= 30
  end

  it "Grundlagen der Medienkommunikation", :jira => 'VUF-511' do
    # actually a series title and also a separate series search test
    resp = solr_resp_ids_titles(title_search_args 'Grundlagen der Medienkommunikation')
    expect(resp.size).to be >= 9
  end

  it "Zeitschrift", :jira => 'VUF-511' do
    resp = solr_resp_ids_titles(title_search_args 'Zeitschrift')
    expect(resp).to include('title_245a_display' => /^zeitschrift$/i).in_each_of_first(15)
    expect(resp).to include(['4443145', '486819']) # has 245a of Zeitschrift
    resp = solr_resp_ids_titles(title_search_args 'Zeitschrift des historischen Vereines für Steiermark') # 246 of 4443145
    expect(resp).to include('486819') # also has 245a of Zeitschrift
    expect(resp.size).to be >= 10
  end

  context "Studies in History and Philosophy of Science", :jira => 'VUF-2003' do
    it "title search without the, phrase" do
      resp = solr_resp_doc_ids_only(title_search_args '"Studies in History and Philosophy of Science"')
      expect(resp).to include('12209967').as_first  # _Studies in history and philosophy of science_ Lane/Medical record
    end
    it "title search without the, not phrase" do
      resp = solr_resp_doc_ids_only(title_search_args 'Studies in History and Philosophy of Science')
      expect(resp).to include('12209967').as_first  # _Studies in history and philosophy of science_ Lane/Medical record
    end
    it "title search with the, phrase" do
      resp = solr_resp_ids_titles(title_search_args '"Studies in the History and Philosophy of Science"')
      expect(resp).to include("title_245a_display" => /Studies in the History and Philosophy of Science/i).in_each_of_first(4).documents
    end
    it "title search with the, not phrase" do
      resp = solr_resp_ids_titles(title_search_args 'Studies in the History and Philosophy of Science')
      expect(resp).to include("title_245a_display" => /Studies in the History and Philosophy of Science/i).in_each_of_first(4).documents
    end
  end

  context 'Race and Arab Americans', jira: 'VUF-5783' do
    it 'title search not as phrase' do
      resp = solr_resp_ids_titles(title_search_args('race and arab americans'))
      expect(resp).to include('title_245a_display' => /^Race and Arab Americans/i).as_first
    end
    it 'title search as phrase' do
      resp = solr_resp_ids_titles(title_search_args('"race and arab americans"'))
      expect(resp).to include('title_245a_display' => /^Race and Arab Americans/i).as_first
    end
  end

end
