describe "Terms with Numbers or other oddities" do

  it "q of 'Two3' should have excellent results", :jira => 'VUF-386', :icu => true do
    # record is Two³;  icu treats superscript as distinct from number?  but also gets 192793 docs  2013-05-20
    resp = solr_resp_ids_from_query 'Two3'
    expect(resp.size).to be <= 10
    expect(resp).to include("5732752").as_first_result
    expect(resp).to include("5732855")
    expect(resp).not_to include("5727394")
    expect(resp).to have_the_same_number_of_results_as(solr_resp_ids_from_query 'two3')
    expect(resp).to have_the_same_number_of_results_as(solr_resp_ids_from_query 'Two³') # how it appears in the record
    expect(resp).to have_fewer_results_than(solr_resp_ids_from_query 'two 3')
  end

  context "square brackets" do
    # if they're not for a range query, they should be ignored
    it "preceded by space as part of q string should be ignored" do
      resp = solr_resp_ids_from_query 'mark twain [pseud]'
      expect(resp.size).to be >= 125
      expect(resp).to have_the_same_number_of_results_as(solr_resp_ids_from_query "mark twain pseud")
    end

    it "preceded by space as part of phrase query should be ignored" do
      resp = solr_resp_ids_from_query '"mark twain [pseud]"'
      expect(resp.size).to be >= 125
      expect(resp).to have_the_same_number_of_results_as(solr_resp_ids_from_query '"mark twain pseud"')
    end

    it "not preceded by space as part of a query string should be ignored", pending: 'fixme' do
      resp = solr_resp_ids_from_query 'Alice Wonderland serie[s]'
      expect(resp.size).to be >= 2
      expect(resp).to have_the_same_number_of_results_as(solr_resp_ids_from_query "Alice Wonderland series")
    end
  end

  it "period at end of term should be ignored" do
    resp = solr_resp_doc_ids_only(title_search_args('Nature.'))
    expect(resp).to include("1337040")
    # Journal:  7917346, 3195844  Other books:  581294, 1361438
    expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only(title_search_args('Nature')))
  end

  context "ellipses" do
    it "leading ellipsis should be ignored", pending: :fixme do
      # this is an interesting definition of 'ignored'..
      resp = solr_resp_doc_ids_only(title_search_args('...Nature'))
      expect(resp).to include("1361438")
      expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only(title_search_args('Nature')))
    end
    it "trailing ellipsis should be ignored" do
      resp = solr_resp_doc_ids_only(title_search_args('why...'))
      expect(resp).to include(["85217", "4272319"]).in_first(10).results
      expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only(title_search_args('why')))
      expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only(title_search_args('why ...')))
      expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only(title_search_args('why... ')))
    end
    it "trailing ellipsis preceded by a space should be ignored (title search)" do
      resp = solr_resp_doc_ids_only(title_search_args('I want ...'))
      expect(resp).to include('10062710')
      expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only(title_search_args('I want')))
      expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only(title_search_args('I want...')))
      expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only(title_search_args('I want ... ')))
    end
    it "trailing ellipsis preceded by a space should be ignored", pending: 'fixme' do
      #  This works for a title search, but not for an everything search ...
      resp = solr_resp_doc_ids_only({'q' => 'I want ...'})
      expect(resp).to include('10062710')
      expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only(title_search_args('I want')))
      expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only(title_search_args('I want...')))
      expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only(title_search_args('I want ... ')))
    end
  end

  context "slash" do
    it "surrounded by spaces should be ignored" do
      resp = solr_resp_ids_from_query 'Physical chemistry / Ira N Levine'
      expect(resp).to include(["1726910", "3016212", "4712578", "7633476"]).in_first(5).results
    end

    it "surrounded by spaces", :jira => 'VUF-522' do
      resp = solr_resp_ids_from_query 'The Beatles as musicians : Revolver through the Anthology / Walter Everett'
      expect(resp).to include('4103922').as_first
      expect(resp.size).to be <= 5
    end

    it "within numbers, no letters (56 1/2)", :jira => 'VUF-389' do
      resp = solr_resp_ids_from_query '56 1/2'
      resp = solr_resp_ids_full_titles_from_query('56 1/2')
      expect(resp).to include({'title_full_display' => /56 1\/2/i}).in_each_of_first(3)
      expect(resp).to include(["6031340", "5491883"]).in_first(3).results
    end

    it "within numbers, no letters (33 1/3)", :jira => 'VUF-178' do
      resp = solr_resp_ids_titles(title_search_args('33 1/3'))
      expect(resp.size).to be >= 85  # Socrates gets 104 titles as of 2010-11-03
      expect(resp).to include({'title_245a_display' => /33 1\/3/i}).in_each_of_first(5)
      expect(resp).to include("6721172").in_first(6).results
    end
  end # context slash

  it "should ignore punctuation inside a phrase" do
    resp = solr_resp_ids_from_query '"Alice in Wonderland : a serie[s]"'
    expect(resp.size).to be >= 2
    expect(resp).to have_the_same_number_of_results_as(solr_resp_ids_from_query '"Alice in Wonderland a serie[s]"')
  end

  context "unmatched pairs" do
    it "unmatched double quote should be ignored", :edismax => true do
      resp = solr_resp_ids_from_query '"space traveler'
      expect(resp).to have_documents
      expect(resp).to have_the_same_number_of_results_as(solr_resp_ids_from_query 'space traveler')
      expect(resp).to have_the_same_number_of_results_as(solr_resp_ids_from_query 'space" traveler')
      expect(resp).to have_the_same_number_of_results_as(solr_resp_ids_from_query'space "traveler')
      # single char on its lonesome becomes a term?
#      resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query 'space " traveler')  # works for dismax, not edismax
      expect(resp).to have_the_same_number_of_results_as(solr_resp_ids_from_query 'space traveler"')
    end

    it "unmatched single quote should be ignored" do
      resp = solr_resp_ids_from_query "'space traveler"
      expect(resp).to have_documents
      expect(resp).to have_the_same_number_of_results_as(solr_resp_ids_from_query "space traveler")
      expect(resp).to have_the_same_number_of_results_as(solr_resp_ids_from_query "space' traveler")
      expect(resp).to have_the_same_number_of_results_as(solr_resp_ids_from_query "space 'traveler")
      # single char on its lonesome becomes a term?
#      resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query "space ' traveler")
      expect(resp).to have_the_same_number_of_results_as(solr_resp_ids_from_query "space traveler'")
    end

    it "unmatched square bracked should be ignored" do
      resp = solr_resp_ids_from_query "[wise up"
      expect(resp).to have_documents
      expect(resp).to have_the_same_number_of_results_as(solr_resp_ids_from_query "wise up")
      expect(resp).to have_the_same_number_of_results_as(solr_resp_ids_from_query "wise[ up")
      expect(resp).to have_the_same_number_of_results_as(solr_resp_ids_from_query "wise [up")
      # single char on its lonesome becomes a term?
#      resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query "wise [ up")
      expect(resp).to have_the_same_number_of_results_as(solr_resp_ids_from_query "wise up[")
      expect(resp).to have_the_same_number_of_results_as(solr_resp_ids_from_query "]wise up")
      expect(resp).to have_the_same_number_of_results_as(solr_resp_ids_from_query "wise] up")
      expect(resp).to have_the_same_number_of_results_as(solr_resp_ids_from_query "wise ]up")
      # single char on its lonesome becomes a term?
#      resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query "wise ] up")
      expect(resp).to have_the_same_number_of_results_as(solr_resp_ids_from_query "wise up]")
    end

    it "unmatched curly brace should be ignored" do
      resp = solr_resp_ids_from_query "{final chord"
      expect(resp).to have_documents
      expect(resp).to have_the_same_number_of_results_as(solr_resp_ids_from_query "final chord")
      expect(resp).to have_the_same_number_of_results_as(solr_resp_ids_from_query "final{ chord")
      expect(resp).to have_the_same_number_of_results_as(solr_resp_ids_from_query "final {chord")
      # single char on its lonesome becomes a term?
#      resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query "final { chord")
      expect(resp).to have_the_same_number_of_results_as(solr_resp_ids_from_query "final chord{")
      expect(resp).to have_the_same_number_of_results_as(solr_resp_ids_from_query "}final chord")
      expect(resp).to have_the_same_number_of_results_as(solr_resp_ids_from_query "final} chord")
      expect(resp).to have_the_same_number_of_results_as(solr_resp_ids_from_query "final }chord")
      # single char on its lonesome becomes a term?
#      resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query "final } chord")
      expect(resp).to have_the_same_number_of_results_as(solr_resp_ids_from_query "final chord}")
    end

    it "unmatched paren should be ignored" do
      resp = solr_resp_ids_from_query '(french horn'
      expect(resp).to have_documents
      expect(resp).to have_the_same_number_of_results_as(solr_resp_ids_from_query 'french horn')
      expect(resp).to have_the_same_number_of_results_as(solr_resp_ids_from_query 'french( horn')
      expect(resp).to have_the_same_number_of_results_as(solr_resp_ids_from_query 'french (horn')
      expect(resp).to have_the_same_number_of_results_as(solr_resp_ids_from_query 'french horn(')
      expect(resp).to have_the_same_number_of_results_as(solr_resp_ids_from_query ')french horn')
      expect(resp).to have_the_same_number_of_results_as(solr_resp_ids_from_query 'french) horn')
      expect(resp).to have_the_same_number_of_results_as(solr_resp_ids_from_query 'french )horn')
      expect(resp).to have_the_same_number_of_results_as(solr_resp_ids_from_query 'french horn)')
    end

  end # unmatched pairs

  context "dollar sign - ignored" do
    it "socrates truncation symbol: 'byzantine figur$' should >= Socrates result quality", :jira => 'VUF-598' do
      resp = solr_resp_doc_ids_only(title_search_args 'byzantine figur$')
      #  note:  Solr ignores the $ so it is the same as
      expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only(title_search_args 'byzantine figur'))

      # these four have (stemmed) byzantine figure in the title
      expect(resp).to include(["2440554", "3013697", "1498432", "5165378"]).in_first(5).results
      # 7769264: title has only byzantine; 505t has "figural"
      expect(resp).to include(["3013697", "1498432", "5165378"]).before("7769264")
      # 7096823 has "Byzantine" "figurine" in separate 505t subfields.
      #   apparently "figurine" does not stem to the same word as "figure" - this is in stemming spec
  #    resp.should include(["2440554", "3013697", "1498432", "5165378"]).before("7096823")
    end

    context "$en$e" do
      it "dollars and $en$e" do
        resp = solr_resp_ids_from_query "dollars and $en$e"
        expect(resp).to include('1127423').as_first # Dollars & $en$e
      end
      it "dollars AND $en$e" do
        resp = solr_resp_ids_from_query "dollars AND $en$e"
        expect(resp).to include('1127423').as_first # Dollars & $en$e
      end
      it "$en$e" do
        resp = solr_resp_ids_from_query "$en$e"
        expect(resp.size).to be >= 300  # this actually matches  " en e"
      end
    end
  end # dollar sign

  it "non-dismax special lone characters should politely return 0 results" do
    # lucene query parsing special chars that are not special to dismax:
    # && || ! ( ) { } [ ] ^ ~ * ? : \
    resp = solr_resp_ids_from_query '&'
    expect(resp).not_to have_documents
    expect(resp).to have_the_same_number_of_results_as(solr_resp_ids_from_query('|'))
    expect(resp).to have_the_same_number_of_results_as(solr_resp_ids_from_query('('))
    expect(resp).to have_the_same_number_of_results_as(solr_resp_ids_from_query(')'))
    expect(resp).to have_the_same_number_of_results_as(solr_resp_ids_from_query('['))
    expect(resp).to have_the_same_number_of_results_as(solr_resp_ids_from_query(']'))
    expect(resp).to have_the_same_number_of_results_as(solr_resp_ids_from_query(':'))
    expect(resp).to have_the_same_number_of_results_as(solr_resp_ids_from_query('\\'))
    expect(resp).to have_the_same_number_of_results_as(solr_resp_ids_from_query(';'))
    expect(resp).to have_the_same_number_of_results_as(solr_resp_ids_from_query('&&'))
    expect(resp).to have_the_same_number_of_results_as(solr_resp_ids_from_query('||'))
    # get results
#    resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('{')) # gets 880 results
#    resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('}')) # gets 880 results
#    resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('^')) # gets 10107977
#    resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('~')) # gets 880 results
#    resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('-')) # gets 880 results
#    resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('!'))  # gets 881 results
#    resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('.'))  # gets a result (398240)
#    resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('%2B'))  # gets 923 results
  end

end
