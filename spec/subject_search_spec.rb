require 'spec_helper'

describe 'Subject Search' do
  it 'Quoted individual subjects vs. Quoting the entire subject', jira: 'SW-196' do
    resp = solr_resp_doc_ids_only(subject_search_args '"Older people" "Abuse of"')
    expect(resp).to have_documents
    expect(resp).not_to include('7631176')
    expect(resp).to have_more_documents_than(solr_resp_doc_ids_only(subject_search_args '"Older people Abuse of"'))
  end

  it "'Archaeology and literature' vs. 'Archaeology in literature'", jira: 'SW-372' do
    resp = solr_resp_doc_ids_only(subject_search_args '"Archaeology and literature"')
    expect(resp.size).to be <= 5
    expect(resp).to include(%w(8517619 6653471))
    expect(resp).not_to include('9388767')  # only has 'in
    expect(resp).not_to include('8545853')  # has neither
    resp = solr_resp_doc_ids_only(subject_search_args('"Archaeology in literature"').merge(rows: 25))
    expect(resp.size).to be >= 15
    expect(resp.size).to be <= 25
    expect(resp).to include(%w(8517619 9388767))
    expect(resp).not_to include('6653471') #  only has 'and'
    expect(resp).not_to include('8545853') # has neither
  end

  context 'china women history', jira: 'VUF-873' do
    it 'not as phrase' do
      # not a heading, but a combo of words from 3 diff headings
      resp = solr_resp_doc_ids_only(subject_search_args('China women history').merge(fq: 'language:English'))
      expect(resp.size).to be >= 170
      expect(resp.size).to be <= 250
    end
    it 'as phrase' do
      resp = solr_resp_doc_ids_only(subject_search_args '"China women history"')
      expect(resp.size).to be <= 3
      expect(resp).to include('8482996')
    end
  end

  # subject search returns better results when mm is 8
  context 'France Social Life and customs 20th century', jira: 'SW-1692' do
    it 'not as phrase' do
      resp = solr_resp_doc_ids_only(subject_search_args('France Social Life and customs 20th century'))
      expect(resp.size).to be >= 400
      expect(resp.size).to be <= 600
      expect(resp).not_to include(%w(6064341 8837304 11755085 5793780)).in_first(20).documents
      expect(resp).to include(%w(9730602 2731118 1710052))
    end
    it 'as phrase' do
      resp = solr_resp_doc_ids_only(subject_search_args '"France Social Life and customs 20th century"')
      expect(resp.size).to be <= 400
    end
  end

  it 'Rock music 1951-1960', jira: 'VUF-388' do
    resp = solr_resp_doc_ids_only(subject_search_args 'Rock music 1951-1960')
    expect(resp.size).to be >= 30
    expect(resp.size).to be <= 40
  end

  context 'Hmong asia(N) people', jira: 'VUF-1245' do
    it 'Hmong (asia people)', jira: 'VUF-1245' do
      resp = solr_resp_doc_ids_only(subject_search_args 'Hmong (asia people)')
      expect(resp).to include(%w(5341021 5739779 2833710)) # also has word Asia in another subject
    end
    it 'Hmong (asiaN people) - correct heading as phrase' do
      resp = solr_resp_doc_ids_only(subject_search_args '"Hmong (asiaN people)"')
      expect(resp.size).to be >= 150
      expect(resp).not_to include(%w(5341021 5739779 2833710)) # also has word Asia in another subject
    end
  end

  context 'home schooling vs home and school', jira: 'VUF-1353' do
    it 'home schooling' do
      resp = solr_resp_doc_ids_only(subject_search_args '"home schooling"')
      expect(resp.size).to be >= 500
      expect(resp.size).to be <= 625
      expect(resp).to include('8834110')
    end
    it 'home and school' do
      resp = solr_resp_doc_ids_only(subject_search_args('"home and school"').merge('rows' => 100))
      expect(resp.size).to be >= 425
      expect(resp.size).to be <= 550
      expect(resp).to include('337849')
    end
  end

  context 'name as subject', jira: 'VUF-1007' do
    it 'jackson pollock' do
      resp = solr_resp_doc_ids_only(subject_search_args('jackson pollock').merge('rows' => 100))
      expect(resp.size).to be >= 75
      expect(resp.size).to be <= 125
      expect(resp).to include(%w(4786630 4298910)) # name as subject (but not as author)
      expect(resp).to include(%w(7837994 7206001)) # name as both author and subject
      expect(resp).not_to include(%w(611300 817515)) # name as author, but not subject
      expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only(subject_search_args('pollock jackson').merge('rows' => 100)))
    end
    it 'pollock, jackson, phrase' do
      resp = solr_resp_doc_ids_only(subject_search_args('"pollock, jackson"').merge('rows' => 100))
      expect(resp.size).to be >= 75
      expect(resp.size).to be <= 125
      expect(resp).to include(%w(4786630 4298910)) # name as subject (but not as author)
      expect(resp).to include(%w(7837994 7206001)) # name as both author and subject
      expect(resp).not_to include(%w(611300 817515)) # name as author, but not subject
    end
    it 'Pollock, Jackson, 1912-1956., phrase' do
      resp = solr_resp_doc_ids_only(subject_search_args('"Pollock, Jackson, 1912-1956."').merge('rows' => 100))
      expect(resp.size).to be >= 75
      expect(resp.size).to be <= 125
      expect(resp).to include(%w(4786630 4298910)) # name as subject (but not as author)
      expect(resp).to include(%w(7837994 7206001)) # name as both author and subject
      expect(resp).not_to include(%w(611300 817515)) # name as author, but not subject
    end
  end

  context 'world war 1945 dictionaries', jira: 'VUF-1067' do
    # actual heading is World War, 1939-1945 > Dictionaries.
    # 367056  dictionaries in separate heading
    it 'not as phrase' do
      resp = solr_resp_doc_ids_only(subject_search_args 'world war 1945 dictionaries')
      expect(resp.size).to be >= 150
      expect(resp.size).to be <= 200
      expect(resp).to include('4148453')
    end
    it 'as phrase' do
      resp = solr_resp_doc_ids_only(subject_search_args '"world war 1945 dictionaries"')
      expect(resp.size).to be >= 35
      expect(resp.size).to be <= 50
      expect(resp).to include('4148453')
    end
  end

  context 'C programming', jira: 'VUF-1993' do
    it 'not as phrase' do
      resp = solr_response(subject_search_args('C programming').merge('fl' => 'id,topic_display', 'facet' => false))
      expect(resp.size).to be >= 1100
      expect(resp.size).to be <= 2000
      expect(resp).to include('topic_display' => /C \(?programming/i).in_each_of_first(17).documents
      expect(resp).to include('4617632')
    end
    it 'as phrase' do
      resp = solr_response(subject_search_args('"C programming"').merge('fl' => 'id,topic_display', 'facet' => false))
      expect(resp.size).to be >= 500
      expect(resp.size).to be <= 1200
      expect(resp).to include('topic_display' => /C \(?programming/i).in_each_of_first(17).documents
      expect(resp).to include('4617632') # 16th in production as of 2013-07-01
      expect(resp).to have_fewer_results_than(solr_resp_doc_ids_only(subject_search_args 'C programming'))
    end
  end

  context 'have catchall field that includes sub vxyz', jira: ['SW-283', 'SW-212'] do
    it 'two phrases' do
      resp = solr_resp_doc_ids_only(subject_search_args '"Handel, George Frideric, 1685-1759" "Thematic catalogs."')
      expect(resp).to include(%w(1242420 1428890))
      expect(resp.size).to be <= 20
    end
    it 'single phrase' do
      resp = solr_resp_doc_ids_only(subject_search_args '"Handel, George Frideric, 1685-1759 Thematic catalogs."')
      expect(resp).to include(%w(1242420 1428890))
      expect(resp.size).to be <= 20
    end
    it 'two phrases' do
      resp = solr_resp_doc_ids_only(subject_search_args '"Handel, George Frideric, 1685-1759" "Chronology"')
      expect(resp).to include(%w(1651552 1428890))
      expect(resp.size).to be <= 20
    end
    it 'single phrase' do
      resp = solr_resp_doc_ids_only(subject_search_args '"Handel, George Frideric, 1685-1759 Chronology."')
      expect(resp).to include(%w(1651552 1428890))
      expect(resp.size).to be <= 20
    end
    context 'Older people, abuse of', jira: 'SW-196' do
      it 'as a phrase' do
        resp = solr_resp_doc_ids_only(subject_search_args('"Older people abuse of"').merge('rows' => 100))
        expect(resp).to include(%w(4544375 11417477))
        expect(resp).not_to include('7631176')
        expect(resp.size).to be <= 225
      end
      it 'Older people > Abuse of > Illinois > Prevention.' do
        resp = solr_resp_doc_ids_only(subject_search_args '"Older people abuse of illinois prevention"')
        expect(resp).to include('2947517')
        expect(resp).not_to include('4544375')
        expect(resp.size).to be <= 10
      end
    end
    context 'imaginary places', jira: 'VUF-495' do
      it 'as a phrase' do
        resp = solr_resp_doc_ids_only(subject_search_args('"imaginary places"').merge('rows' => 100))
        expect(resp.size).to be >= 350
      end
      it 'imaginary places > drama' do
        resp = solr_resp_doc_ids_only(subject_search_args '"imaginary places drama"')
        expect(resp).to have_documents
      end
      it ' Imaginary places in literature' do
        resp = solr_resp_doc_ids_only(subject_search_args '" Imaginary places in literature"')
        expect(resp).to have_documents
      end
      it 'Middle Earth (Imaginary place)' do
        resp = solr_resp_doc_ids_only(subject_search_args '"Middle Earth (Imaginary place)"')
        expect(resp).to have_documents
      end
    end
  end

  context 'subject with apostrophe' do
    it "stanford artists' books collection", jira: 'SW-867' do
      resp = solr_resp_doc_ids_only(subject_search_args '"stanford artists\' books collection"')
      expect(resp).to include('7513019')
    end
  end

  context 'left anchored subjects desired', jira: ['SW-393', 'SW-394'] do
    context 'Authorship history 18th century but not poetry' do
      it 'as phrase', fixme: true do
        resp = solr_resp_doc_ids_only(subject_search_args '"Authorship history 18th century"')
        expect(resp).to include(%w(9544929 2889425))
        expect(resp).not_to include('4144101') # poetry > authorship > history > 18th century
        expect(resp.size).to be <= 25
      end
      it 'AND NOT poetry' do
        resp = solr_resp_doc_ids_only(subject_search_args '"Authorship history 18th century" AND NOT Poetry')
        expect(resp).to include(%w(9544929 2889425))
        expect(resp).not_to include('4144101') # poetry > authorship > history > 18th century
        expect(resp.size).to be <= 25
      end
    end
  end

  context 'database subjects' do
    it 'geology', jira: 'VUF-1740' do
      resp = solr_resp_doc_ids_only(subject_search_args('geology').merge(fq: 'format:Database'))
      expect(resp.size).to be >= 10
      # ckey 3982587 withdrawn
      expect(resp).to include('4246894')
      expect(resp.size).to be <= 30
    end
    it 'geology theses', jira: 'VUF-1740' do
      # note:  NOT a subject search
      resp = solr_resp_doc_ids_only('q' => 'geology theses', fq: 'format:Database')
      expect(resp).to include('3755800')
      expect(resp.size).to be <= 5
    end
    it 'PAIS Index', jira: 'SW-644' do
      resp = solr_resp_doc_ids_only('q' => 'political science', fq: 'format:Database')
      expect(resp).to include('11696645')
    end
  end

  context 'includes 655 (genre)' do
    it 'graphic novels', jira: 'VUF-906' do
      resp = solr_resp_doc_ids_only(subject_search_args '"graphic novels"')
      expect(resp.size).to be >= 2500
    end
    it 'musical feature', jira: 'VUF-906' do
      resp = solr_resp_doc_ids_only(subject_search_args '"Musical-Feature"')
      expect(resp.size).to be >= 75
    end
  end
end
