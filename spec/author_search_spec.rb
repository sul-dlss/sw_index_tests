describe "Author Search" do

  context "Corporate author should be included in author search", :jira => 'VUF-633' do
    it "Anambra State, not a phrase" do
      resp = solr_resp_doc_ids_only(author_search_args 'Anambra State')
      expect(resp.size).to be >= 85
    end
    it "Anambra State, phrase" do
      resp = solr_resp_doc_ids_only(author_search_args '"Anambra State"')
      expect(resp.size).to be >= 85
    end
    it "Plateau State, not a phrase" do
      resp = solr_resp_doc_ids_only(author_search_args 'Plateau State')
      expect(resp.size).to be >= 90
    end
    it "Plateau State, phrase" do
      resp = solr_resp_doc_ids_only(author_search_args '"Plateau State"')
      expect(resp.size).to be >= 90
    end
    it "Gold Coast, not a phrase" do
      resp = solr_resp_doc_ids_only(author_search_args 'Gold Coast')
      expect(resp.size).to be >= 210
    end
    it "Gold Coast, phrase" do
      resp = solr_resp_doc_ids_only(author_search_args '"Gold Coast"')
      expect(resp.size).to be >= 210
    end
    it "tanganyika" do
      resp = solr_resp_doc_ids_only(author_search_args 'tanganyika')
      expect(resp.size).to be >= 180
    end
  end

  it "Thesis advisors (720 fields) should be included in author search", :jira => 'VUF-433' do
    resp = solr_response(author_search_args('Zare').merge({'fl'=>'id,format,author_person_display', 'fq'=>'genre_ssim:"Thesis/Dissertation"', 'facet'=>false}))
    expect(resp.size).to be >= 100
    expect(resp).not_to include("author_person_display" => /\bZare\W/).in_each_of_first(20).documents
  end

  it "added authors (700 fields) should be included in author search", :jira => 'VUF-255' do
    resp = solr_resp_doc_ids_only(author_search_args 'jane hannaway')
    expect(resp).to include("2503795")
    expect(resp.size).to be >= 8
  end

  it "unstemmed author names should precede stemmed variants", :jira => ['VUF-120', 'VUF-433'] do
    resp = solr_response(author_search_args('Zare').merge({'fl'=>'id,author_person_display', 'facet'=>false}))
    expect(resp).to include("author_person_display" => /\bZare\W/).in_each_of_first(3).documents
    expect(resp).not_to include("author_person_display" => /Zaring/).in_each_of_first(20).documents
  end

  it "non-existent author 'jill kerr conway' should get 0 results" do
    resp = solr_resp_doc_ids_only(author_search_args 'jill kerr conway')
    expect(resp.size).to eq(0)
  end

  it "Wender, Paul A. should not get results for Wender, Paul H", :jira => 'VUF-1398' do
    resp = solr_resp_doc_ids_only(author_search_args('"Wender, Paul A., "').merge({:rows => 150}))
    expect(resp.size).to be >= 85
    expect(resp.size).to be <= 135
    paul_h_docs = ["781472", "10830886", "750072", "11839442", "12576610"]
    paul_h_docs.each { |doc_id| expect(resp).not_to include(doc_id) }
    resp = solr_resp_doc_ids_only(author_search_args '"Wender, Paul H., "')
    expect(resp.size).to be <= 10
    expect(resp).to include(paul_h_docs)
  end

  it "period after initial shouldn't matter" do
    resp = solr_resp_doc_ids_only(author_search_args 'jill k. conway')
    expect(resp).to include('4735430')
    expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only(author_search_args 'jill k conway'))
  end

  it "author matches should appear before editor matches" do
    resp = solr_resp_doc_ids_only(author_search_args 'jill k. conway')
    # author before editor
    expect(resp).to include(['1490381', '1302403', '861080', '1714776', '2911421', '2937495', '3063723', '3832670', '4735430']).before('4343662')
    # editor
    expect(resp).to include(['4343662', '1714390', '2781921'])
    #  in metadata, but not as author
    # book about her, with name in title spelled Ker
    expect(resp).not_to include('5826712')
    # the next two are in spanish and have the name in the 505a
    expect(resp).not_to include('3159425')
    expect(resp).not_to include('4529441')
  end

  context "author name false drop across 2 700 fields" do
    context "deborah marshall", :jira => 'VUF-1185' do
      before(:all) do
        @correct = ['1073585', '7840544']
        @false_drop = '7929478'
      end
      it "author search, not phrase" do
        resp = solr_resp_doc_ids_only(author_search_args 'marshall, deborah')
        expect(resp).to include(@correct).before(@false_drop)
      end
      it "author search, phrase" do
        resp = solr_resp_doc_ids_only(author_search_args '"marshall, deborah"')
        expect(resp.size).to be <= 10
        expect(resp).to include(@correct)
        expect(resp).not_to include(@false_drop)
      end
    end
    context "david sandlin", :jira => 'VUF-1418' do
      before(:all) do
        @correct = ['8610705', '8808239', '8808223', '8610706', '8610701']
        @false_drop = '2927066'
      end
      it "author search, not phrase" do
        resp = solr_resp_doc_ids_only(author_search_args 'david sandlin')
        expect(resp).to include(@correct).before(@false_drop)
      end
      it "author search, phrase - words in wrong order", pending: 'fixme' do
        resp = solr_resp_doc_ids_only(author_search_args '"david sandlin"')
        expect(resp.size).to be <= 10
        expect(resp).to include(@correct)
        expect(resp).not_to include(@false_drop)
      end
      it "author search, phrase - words in right order" do
        resp = solr_resp_doc_ids_only(author_search_args '"sandlin, david"')
        expect(resp.size).to be <= 10
        expect(resp).to include(@correct)
        expect(resp).not_to include(@false_drop)
      end
    end
  end

  context "Vyacheslav Ivanov", :jira => ['VUF-2279', 'VUF-2280', 'VUF-2281'] do
    # there are at least three authors with last name Ivanov, first name Vyacheslav
    #  our official spelling of the desired one is Viacheslav
    it "author search Ivanov Viacheslav", :jira => 'VUF-2279' do
      # at least three authors with last name Ivanov, first name Vyacheslav
      resp = solr_resp_doc_ids_only(author_search_args 'Ivanov Viacheslav')
      expect(resp.size).to be >= 100
      expect(resp.size).to be <= 150
    end
    it "author search Vyacheslav Ivanov", pending: 'fixme' do
      # this is "misspelled" per our data
      resp = solr_resp_doc_ids_only(author_search_args 'Vyacheslav Ivanov')
      expect(resp).to have_results
    end
    # NOTE: there are two different authority headings for same one?
    it "author search Ivanov, Vi͡acheslav Vsevolodovich", :jira => 'VUF-2280' do
      resp = solr_resp_doc_ids_only(author_search_args 'Ivanov, Vi͡acheslav Vsevolodovich')
      expect(resp.size).to be >= 55
      expect(resp.size).to be <= 75
    end
    it "author search Ivanov, V. I. (Vi͡acheslav Ivanovich), 1866-1949", :jira => 'VUF-2280' do
      resp = solr_resp_doc_ids_only(author_search_args 'Ivanov, V. I. (Vi͡acheslav Ivanovich), 1866-1949')
      expect(resp.size).to be >= 50
      expect(resp.size).to be <= 65
    end
  end

  context "william dudley haywood <-> big bill haywood", :jira => 'VUF-2323' do
    it "author search big bill hayward" do
      resp = solr_resp_doc_ids_only(author_search_args 'big bill haywood')
      expect(resp.size).to be >= 10
      expect(resp).to include('141584')
      expect(resp.size).to be <= 50
    end
    it "author phrase search  hayward, big bill " do
      resp = solr_resp_doc_ids_only(author_search_args '"haywood, big bill"')
      expect(resp.size).to be >= 10
      expect(resp).to include('141584')
      expect(resp.size).to be <= 50
    end
    it "author search bill hayward" do
      resp = solr_resp_doc_ids_only(author_search_args 'bill haywood')
      expect(resp.size).to be >= 10
      expect(resp).to include('141584')
      expect(resp.size).to be <= 50
    end
    # waiting for name authorities linkage
    it "author search william haywood", pending: 'fixme' do
      resp = solr_resp_doc_ids_only(author_search_args 'william haywood')
      expect(resp.size).to be >= 20
      expect(resp).to include('141584')
      expect(resp.size).to be <= 50
    end
    it "author phrase search  haywood william", pending: 'fixme' do
      resp = solr_resp_doc_ids_only(author_search_args '"haywood, william"')
      expect(resp.size).to be >= 20
      expect(resp).to include('141584')
      expect(resp.size).to be <= 50
    end
  end

  context "ransch-trill, barbara", :jira => 'VUF-165' do
    it "with and without umlaut" do
      resp = solr_resp_doc_ids_only(author_search_args 'ränsch-trill, barbara')
      expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only(author_search_args 'ransch-trill, barbara'))
      expect(resp).to include(['5455737', '2911735'])
    end
    it "last name only, with and without umlaut" do
      resp = solr_resp_doc_ids_only(author_search_args 'ränsch-trill')
      expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only(author_search_args 'ransch-trill'))
      expect(resp).to include(['5455737', '2911735'])
    end
  end

  context "johann david heinichen", :jira => 'VUF-1449' do
    it "author search" do
      resp = solr_resp_doc_ids_only(author_search_args('johann David Heinichen').merge({'fq' => 'format_main_ssim:Book'}))
      expect(resp.size).to be >= 10
      expect(resp).to include(['9858935', '3301463'])
      expect(resp.size).to be <= 25
    end
    # the following is busted due to Solr edismax bug
    # https://issues.apache.org/jira/browse/SOLR-2649
    it "everything search with author and years", pending: 'fixme' do
      resp = solr_resp_ids_from_query 'johann David Heinichen 1711 OR 1728'
      expect(resp).to include(['9858935', '3301463'])
    end
    it "everything phrase search with author and years", pending: 'fixme' do
      resp = solr_resp_ids_from_query '"Heinichen, johann David" 1711 OR 1728'
      expect(resp).to include(['9858935', '3301463'])
    end
  end

  it "mark applebaum", :jira => 'VUF-89' do
    resp = solr_resp_doc_ids_only(author_search_args 'mark applebaum')
    expect(resp.size).to be >= 85
    expect(resp.size).to be <= 150
    expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only(author_search_args 'applebaum, mark'))
  end

  context "name as author, not subject", :jira => 'VUF-1007' do
    it "jackson pollock" do
      resp = solr_resp_doc_ids_only(author_search_args('jackson pollock').merge({'rows'=>60}))
      expect(resp.size).to be >= 40
      expect(resp.size).to be <= 60
      expect(resp).to include(['611300', '817515']) # name as author, but not subject
      expect(resp).to include(['7837994', '7206001']) # name as both author and subject
      expect(resp).not_to include(['4786630', '4298910']) # name as subject (but not as author)
      expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only(author_search_args('pollock jackson').merge({'rows'=>100})))
    end
    it "pollock, jackson, phrase" do
      resp = solr_resp_doc_ids_only(author_search_args('"pollock, jackson"').merge({'rows'=>60}))
      expect(resp.size).to be >= 40
      expect(resp.size).to be <= 60
      expect(resp).to include(['611300', '817515']) # name as author, but not subject
      expect(resp).to include(['7837994', '7206001']) # name as both author and subject
      expect(resp).not_to include(['4786630', '4298910']) # name as subject (but not as author)
    end
    it "Pollock, Jackson, 1912-1956., phrase" do
      resp = solr_resp_doc_ids_only(author_search_args('"Pollock, Jackson, 1912-1956."').merge({'rows'=>60}))
      expect(resp.size).to be >= 40
      expect(resp.size).to be <= 60
      expect(resp).to include(['611300', '817515']) # name as author, but not subject
      expect(resp).to include(['7837994', '7206001']) # name as both author and subject
      expect(resp).not_to include(['4786630', '4298910']) # name as subject (but not as author)
    end
  end

  context "contributor 710 with |k manuscript", :jira => ['SW-579', 'VUF-1684'] do
    it "phrase search", pending: 'fixme' do
      resp = solr_resp_doc_ids_only(author_search_args('"Bibliothèque nationale de France. Manuscript. Musique 226. "'))
      expect(resp).to include(['278333', '6288243'])
      expect(resp.size).to be <= 5
    end
    # this test fails with mm setting 8; jira ticket SW-1698
    # 710 |k and |n need to be parsed into the author-title index
    # FIXME : StanfordIndexer.java line 951
    it "non-phrase search", pending: 'fixme' do
      resp = solr_resp_doc_ids_only(author_search_args('Bibliothèque nationale de France. Manuscript. Musique 226. '))
      expect(resp).to include(['278333', '6288243'])
      expect(resp.size).to be <= 5
    end
    it "everything phrase search" do
      resp = solr_resp_ids_from_query '"Bibliothèque nationale de France. Manuscript. Musique 226. "'
      expect(resp).to include(['278333', '6288243'])
      expect(resp.size).to be <= 5
    end
  end

  context "corporate author phrase search", :jira => 'VUF-1698' do
    it 'author "Institute for Mathematical Studies in the Social Sciences"' do
      resp = solr_resp_doc_ids_only(author_search_args('"Institute for Mathematical Studies in the Social Sciences"'))
      expect(resp.size).to be >= 650
      expect(resp.size).to be <= 900
    end
  end

  context "Deutsch, Alfred", :jira => 'VUF-1481' do
    # FIXME: finds authors across fields - alfred in one field, deutsch in another
    it "author search" do
      resp = solr_resp_doc_ids_only(author_search_args('Deutsch, Alfred'))
      expect(resp).to include('509722').as_first
    end
    it "author search, phrase" do
      resp = solr_resp_doc_ids_only(author_search_args('"Deutsch, Alfred"'))
      expect(resp).to include('509722')
      expect(resp.size).to be <= 5
    end
  end

end
