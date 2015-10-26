require 'spec_helper'

describe 'Subject Search' do
  it 'Quoted individual subjects vs. Quoting the entire subject', jira: 'SW-196' do
    resp = solr_resp_doc_ids_only(subject_search_args '"Older people" "Abuse of"')
    resp.should have_documents
    resp.should_not include('7631176')
    resp.should have_more_documents_than(solr_resp_doc_ids_only(subject_search_args '"Older people Abuse of"'))
  end

  it "'Archaeology and literature' vs. 'Archaeology in literature'", jira: 'SW-372' do
    resp = solr_resp_doc_ids_only(subject_search_args '"Archaeology and literature"')
    resp.should have_at_most(5).results
    resp.should include(%w(8517619 6653471))
    resp.should_not include('9388767')  # only has 'in
    resp.should_not include('8545853')  # has neither
    resp = solr_resp_doc_ids_only(subject_search_args('"Archaeology in literature"').merge(rows: 25))
    resp.should have_at_least(15).results
    resp.should have_at_most(25).results
    resp.should include(%w(8517619 9388767))
    resp.should_not include('6653471') #  only has 'and'
    resp.should_not include('8545853') # has neither
  end

  context 'china women history', jira: 'VUF-873' do
    it 'not as phrase' do
      # not a heading, but a combo of words from 3 diff headings
      resp = solr_resp_doc_ids_only(subject_search_args('China women history').merge(fq: 'language:English'))
      resp.should have_at_least(170).results
      resp.should have_at_most(250).results
    end
    it 'as phrase' do
      resp = solr_resp_doc_ids_only(subject_search_args '"China women history"')
      resp.should have_at_most(3).documents
      resp.should include('8482996')
    end
  end

  it 'Rock music 1951-1960', jira: 'VUF-388' do
    resp = solr_resp_doc_ids_only(subject_search_args 'Rock music 1951-1960')
    resp.should have_at_least(20).results
    resp.should have_at_most(35).results
  end

  context 'Hmong asia(N) people', jira: 'VUF-1245' do
    it 'Hmong (asia people)', jira: 'VUF-1245' do
      resp = solr_resp_doc_ids_only(subject_search_args 'Hmong (asia people)')
      resp.should include(%w(5341021 5739779 2833710)) # also has word Asia in another subject
    end
    it 'Hmong (asiaN people) - correct heading as phrase' do
      resp = solr_resp_doc_ids_only(subject_search_args '"Hmong (asiaN people)"')
      resp.should have_at_least(150).results
      resp.should_not include(%w(5341021 5739779 2833710)) # also has word Asia in another subject
    end
  end

  context 'home schooling vs home and school', jira: 'VUF-1353' do
    it 'home schooling' do
      resp = solr_resp_doc_ids_only(subject_search_args '"home schooling"')
      resp.should have_at_least(500).results
      resp.should have_at_most(625).results
      resp.should include('8834110')
    end
    it 'home and school' do
      resp = solr_resp_doc_ids_only(subject_search_args('"home and school"').merge('rows' => 100))
      resp.should have_at_least(425).results
      resp.should have_at_most(550).results
      resp.should include('337849')
    end
  end

  context 'name as subject', jira: 'VUF-1007' do
    it 'jackson pollock' do
      resp = solr_resp_doc_ids_only(subject_search_args('jackson pollock').merge('rows' => 100))
      resp.should have_at_least(75).results
      resp.should have_at_most(125).results
      resp.should include(%w(4786630 4298910)) # name as subject (but not as author)
      resp.should include(%w(7837994 7206001)) # name as both author and subject
      resp.should_not include(%w(611300 817515)) # name as author, but not subject
      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(subject_search_args('pollock jackson').merge('rows' => 100)))
    end
    it 'pollock, jackson, phrase' do
      resp = solr_resp_doc_ids_only(subject_search_args('"pollock, jackson"').merge('rows' => 100))
      resp.should have_at_least(75).results
      resp.should have_at_most(125).results
      resp.should include(%w(4786630 4298910)) # name as subject (but not as author)
      resp.should include(%w(7837994 7206001)) # name as both author and subject
      resp.should_not include(%w(611300 817515)) # name as author, but not subject
    end
    it 'Pollock, Jackson, 1912-1956., phrase' do
      resp = solr_resp_doc_ids_only(subject_search_args('"Pollock, Jackson, 1912-1956."').merge('rows' => 100))
      resp.should have_at_least(75).results
      resp.should have_at_most(125).results
      resp.should include(%w(4786630 4298910)) # name as subject (but not as author)
      resp.should include(%w(7837994 7206001)) # name as both author and subject
      resp.should_not include(%w(611300 817515)) # name as author, but not subject
    end
  end

  context 'world war 1945 dictionaries', jira: 'VUF-1067' do
    # actual heading is World War, 1939-1945 > Dictionaries.
    # 367056  dictionaries in separate heading
    it 'not as phrase' do
      resp = solr_resp_doc_ids_only(subject_search_args 'world war 1945 dictionaries')
      resp.should have_at_least(150).results
      resp.should have_at_most(200).results
      resp.should include('4148453')
    end
    it 'as phrase' do
      resp = solr_resp_doc_ids_only(subject_search_args '"world war 1945 dictionaries"')
      resp.should have_at_least(35).results
      resp.should have_at_most(50).results
      resp.should include('4148453')
    end
  end

  context 'C programming', jira: 'VUF-1993' do
    it 'not as phrase' do
      resp = solr_response(subject_search_args('C programming').merge('fl' => 'id,topic_display', 'facet' => false))
      resp.should have_at_least(1100).results
      resp.should have_at_most(2000).results
      resp.should include('topic_display' => /C \(?programming/i).in_each_of_first(17).documents
      resp.should include('4617632')
    end
    it 'as phrase' do
      resp = solr_response(subject_search_args('"C programming"').merge('fl' => 'id,topic_display', 'facet' => false))
      resp.should have_at_least(500).results
      resp.should have_at_most(1200).results
      resp.should include('topic_display' => /C \(?programming/i).in_each_of_first(17).documents
      resp.should include('4617632') # 16th in production as of 2013-07-01
      resp.should have_fewer_results_than(solr_resp_doc_ids_only(subject_search_args 'C programming'))
    end
  end

  context 'have catchall field that includes sub vxyz', jira: ['SW-283', 'SW-212'] do
    it 'two phrases' do
      resp = solr_resp_doc_ids_only(subject_search_args '"Handel, George Frideric, 1685-1759" "Thematic catalogs."')
      resp.should include(%w(1242420 1428890))
      resp.should have_at_most(20).results
    end
    it 'single phrase' do
      resp = solr_resp_doc_ids_only(subject_search_args '"Handel, George Frideric, 1685-1759 Thematic catalogs."')
      resp.should include(%w(1242420 1428890))
      resp.should have_at_most(20).results
    end
    it 'two phrases' do
      resp = solr_resp_doc_ids_only(subject_search_args '"Handel, George Frideric, 1685-1759" "Chronology"')
      resp.should include(%w(1651552 1428890))
      resp.should have_at_most(20).results
    end
    it 'single phrase' do
      resp = solr_resp_doc_ids_only(subject_search_args '"Handel, George Frideric, 1685-1759 Chronology."')
      resp.should include(%w(1651552 1428890))
      resp.should have_at_most(20).results
    end
    context 'Older people, abuse of', jira: 'SW-196' do
      it 'as a phrase' do
        resp = solr_resp_doc_ids_only(subject_search_args('"Older people abuse of"').merge('rows' => 100))
        resp.should include(%w(4544375 11417477))
        resp.should_not include('7631176')
        resp.should have_at_most(225).results
      end
      it 'Older people > Abuse of > Illinois > Prevention.' do
        resp = solr_resp_doc_ids_only(subject_search_args '"Older people abuse of illinois prevention"')
        resp.should include('2947517')
        resp.should_not include('4544375')
        resp.should have_at_most(10).results
      end
    end
    context 'imaginary places', jira: 'VUF-495' do
      it 'as a phrase' do
        resp = solr_resp_doc_ids_only(subject_search_args('"imaginary places"').merge('rows' => 100))
        resp.should have_at_least(350).results
      end
      it 'imaginary places > drama' do
        resp = solr_resp_doc_ids_only(subject_search_args '"imaginary places drama"')
        resp.should have_documents
      end
      it ' Imaginary places in literature' do
        resp = solr_resp_doc_ids_only(subject_search_args '" Imaginary places in literature"')
        resp.should have_documents
      end
      it 'Middle Earth (Imaginary place)' do
        resp = solr_resp_doc_ids_only(subject_search_args '"Middle Earth (Imaginary place)"')
        resp.should have_documents
      end
    end
  end

  context 'subject with apostrophe' do
    it "stanford artists' books collection", jira: 'SW-867' do
      resp = solr_resp_doc_ids_only(subject_search_args '"stanford artists\' books collection"')
      resp.should include('7513019')
    end
  end

  context 'left anchored subjects desired', jira: ['SW-393', 'SW-394'] do
    context 'Authorship history 18th century but not poetry' do
      it 'as phrase', fixme: true do
        resp = solr_resp_doc_ids_only(subject_search_args '"Authorship history 18th century"')
        resp.should include(%w(9544929 2889425))
        resp.should_not include('4144101') # poetry > authorship > history > 18th century
        resp.should have_at_most(25).results
      end
      it 'AND NOT poetry' do
        resp = solr_resp_doc_ids_only(subject_search_args '"Authorship history 18th century" AND NOT Poetry')
        resp.should include(%w(9544929 2889425))
        resp.should_not include('4144101') # poetry > authorship > history > 18th century
        resp.should have_at_most(25).results
      end
    end
  end

  context 'database subjects' do
    it 'geology', jira: 'VUF-1740' do
      resp = solr_resp_doc_ids_only(subject_search_args('geology').merge(fq: 'format:Database'))
      resp.should have_at_least(10).results
      resp.should include('3982587')
      resp.should have_at_most(30).results
    end
    it 'geology theses', jira: 'VUF-1740' do
      # note:  NOT a subject search
      resp = solr_resp_doc_ids_only('q' => 'geology theses', fq: 'format:Database')
      resp.should include('3755800')
      resp.should have_at_most(5).results
    end
    it 'PAIS International subjects', jira: 'SW-644' do
      resp = solr_resp_doc_ids_only('q' => 'political science', fq: 'format:Database')
      resp.should include('600922')
    end
  end

  context 'includes 655 (genre)' do
    it 'graphic novels', jira: 'VUF-906' do
      resp = solr_resp_doc_ids_only(subject_search_args '"graphic novels"')
      resp.should have_at_least(2500).results
    end
    it 'musical feature', jira: 'VUF-906' do
      resp = solr_resp_doc_ids_only(subject_search_args '"Musical-Feature"')
      resp.should have_at_least(75).results
    end
  end
end
