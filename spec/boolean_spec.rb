describe 'boolean operators' do
  # TODO: more better tests for lowercase and?
  context 'default operator:  AND' do
    context 'everything search' do
      it 'more search terms should get fewer results' do
        resp = solr_resp_ids_from_query 'horn'
        expect(resp).to have_more_documents_than(solr_resp_ids_from_query 'french horn')
      end
      it 'loggerhead turtles should not have Shakespeare in facets' do
        resp = solr_response('q' => 'loggerhead turtles', 'fl' => 'id')
        # Shakespeare was in the facets when default was 'OR'
        expect(resp).not_to have_facet_field('author_person_facet').with_value('Shakespeare, William, 1564-1616')
        resp = solr_response('q' => 'turtles', 'fl' => 'id')
        expect(resp).to have_facet_field('author_person_facet').with_value('Shakespeare, William, 1564-1616')
      end
    end

    context 'author search' do
      it 'more search terms should get fewer results' do
        resp = solr_resp_doc_ids_only(author_search_args('michaels'))
        expect(resp).to have_more_documents_than(solr_resp_doc_ids_only(author_search_args('leonard michaels')))
      end
    end

    context 'title search' do
      it 'more search terms should get fewer results' do
        resp = solr_resp_doc_ids_only(title_search_args('turtles'))
        expect(resp).to have_more_documents_than(solr_resp_doc_ids_only(title_search_args('sea turtles')))
      end
    end

    it 'across MARC fields (author and title)' do
      resp = solr_resp_ids_from_query 'gulko sea turtles'
      expect(resp.size).to eq(1)
      expect(resp).to include('5958831')
      resp = solr_resp_ids_from_query 'eckert sea turtles'
      expect(resp.size).to eq(2)
      expect(resp).to include('5958831')
    end

    context '5 terms with AND' do
      before(:all) do
        @resp = solr_resp_ids_from_query 'Catholic thought AND papal jewry policy'
      end
      it 'should include doc 1711043' do
        expect(@resp.size).to eq(1)
        expect(@resp).to include('1711043')
      end
      it "should get the same results as lowercase 'and'" do
        expect(@resp).to have_the_same_number_of_documents_as(solr_resp_ids_from_query 'Catholic thought and papal jewry policy')
      end
    end

    context 'history man by malcolm bradbury', jira: 'SW-805' do
      # lowercase and is considered a query term
      it 'history man and bradbury', pending: 'fixme' do
        resp = solr_resp_ids_from_query 'history man and bradbury'
        expect(resp).to include('1433520').in_first(5)
      end
      it 'history man AND bradbury' do
        resp = solr_resp_ids_from_query 'history man AND bradbury'
        expect(resp).to include('1433520').in_first(5)
      end
      it 'history man bradbury' do
        resp = solr_resp_ids_from_query 'history man bradbury'
        expect(resp).to include('1433520').in_first(5)
      end
      it 'history man bradbury malcolm' do
        resp = solr_resp_ids_from_query 'history man bradbury malcolm'
        expect(resp).to include('1433520').in_first(5)
      end
      it 'history man malcolm bradbury' do
        resp = solr_resp_ids_from_query 'history man malcolm bradbury'
        expect(resp).to include('1433520').in_first(5)
      end
      it 'history man' do
        resp = solr_resp_ids_from_query 'history man'
        expect(resp).to include('1433520').in_first(5)
      end
    end

    it "lower case 'and' behaves like upper case AND", jira: 'VUF-626' do
      resp = solr_resp_ids_from_query 'South Africa, Shakespeare AND post-colonial culture'
      expect(resp).to include(%w(8505958 4745861 7837826 7756621))
      resp2 = solr_resp_ids_from_query 'South Africa, Shakespeare and post-colonial culture'
      expect(resp2).to include(%w(8505958 4745861 7837826 7756621))
      expect(resp).to have_the_same_number_of_documents_as(resp2)
    end
  end # context AND

  # TODO: what about lowercase not?

  context 'NOT operator' do
    shared_examples_for 'NOT negates following term' do |query, exp_ids, un_exp_ids, first_n|
      before(:all) do
        @resp = solr_resp_ids_from_query query
      end
      it 'should have expected results', pending: 'fixme' do
        expect(@resp).to include(exp_ids).in_first(first_n).documents
      end
      it 'should not have unexpected results' do
        expect(@resp).not_to include(un_exp_ids)
      end
      it 'query that includes term should match unexpected ids' do
        # or we don't have good unexpected ids for the test
        resp_w_term = solr_resp_ids_from_query query.sub(' NOT ', ' ')
        expect(resp_w_term).to include(un_exp_ids)
      end
      it 'should have fewer results than query without NOT clause' do
        expect(@resp).to have_fewer_documents_than(solr_resp_ids_from_query query.sub(/ NOT \S+ ?/, ' '))
      end
      it "hyphen with space before but not after (' -a') should be equivalent to NOT" do
        expect(@resp).to have_the_same_number_of_documents_as(solr_resp_ids_from_query query.sub(' NOT ', ' -'))
      end
    end # shared examples for NOT in query

    #  per Google Analytics mid-April - mid- May 2013
    context 'actual user queries' do
      # the following is busted due to Solr edismax bug
      # https://issues.apache.org/jira/browse/SOLR-2649
      context 'space exploration NOT nasa' do
        it_behaves_like 'NOT negates following term', 'space exploration NOT nasa', '4146206', '2678639', 5
        it 'has an appropriate number of results', pending: 'fixme' do
          resp = solr_resp_ids_from_query 'space exploration NOT nasa'
          expect(resp.size).to be >= 6300
          expect(resp.size).to be <= 7250 # 2013-05-21  space exploration: 7896 results
        end
      end
      # all caps queries:  didn't mean it as boolean
      #   COVENANTS NOT TO COMPETE: A STATE-BY-STATE SURVEY
      #   THE BEAUTYFUL ONES ARE NOT YET BORN
      #   WHY SOME THINGS SHOULD NOT BE FOR SALE
    end

    context 'twain NOT sawyer' do
      before(:all) do
        @resp = solr_resp_ids_from_query 'twain NOT sawyer'
      end
      it "should have fewer results than query 'twain'" do
        expect(@resp).to have_documents
        expect(@resp).to have_fewer_documents_than(solr_resp_ids_from_query 'twain')
      end
      it 'should be equivalent to twain -sawyer' do
        expect(@resp).to have_the_same_number_of_documents_as(solr_resp_ids_from_query 'twain -sawyer')
      end
    end

    context "query with NOT applied to phrase:  mark twain NOT 'tom sawyer'" do
      before(:all) do
        @resp = solr_resp_ids_from_query 'mark twain NOT "tom sawyer"'
      end

      it "should have no results with 'tom sawyer' as a phrase" do
        resp = solr_response('q' => 'mark twain NOT "tom sawyer"', 'fl' => 'id,title_245a_display', 'facet' => false)
        expect(@resp.size).to be >= 1400
        expect(resp).not_to include('title_245a_display' => /tom sawyer/i).in_each_of_first(20).documents
      end
      it "should be equivalent to mark twain -'tom sawyer'" do
        @resp =  have_the_same_number_of_documents_as(solr_resp_ids_from_query 'mark twain -"tom sawyer"')
      end
      it "should get more results than 'mark twain 'tom sawyer''" do
        expect(@resp).to have_more_results_than(solr_resp_ids_from_query 'mark twain "tom sawyer"')
      end
      it "should get more results than 'mark twain tom sawyer'" do
        expect(@resp).to have_more_results_than(solr_resp_ids_from_query 'mark twain tom sawyer')
      end

      it 'should work with parens', jira: 'VUF-379' do
        resp = solr_resp_ids_from_query 'mark twain NOT (tom sawyer)'
        expect(resp.size).to be >= 1400
      end
      it 'with parens inside quote' do
        resp = solr_resp_ids_from_query 'mark twain NOT "(tom sawyer)"' # 0 documents
        expect(resp.size).to be >= 1400
        expect(resp).to have_the_same_number_of_documents_as(@resp)
      end
      it 'with parens outside quote' do
        resp = solr_resp_ids_from_query 'mark twain NOT ("tom sawyer")' # 0 documents
        expect(resp.size).to be >= 1400
        expect(resp).to have_the_same_number_of_documents_as(@resp)
      end
      it 'with unmatched paren inside quotes' do
        expect(@resp).to have_the_same_number_of_documents_as(solr_resp_ids_from_query 'mark twain NOT "(tom sawyer"')
        expect(@resp).to have_the_same_number_of_documents_as(solr_resp_ids_from_query 'mark twain NOT "tom( sawyer"')
        expect(@resp).to have_the_same_number_of_documents_as(solr_resp_ids_from_query 'mark twain NOT "tom (sawyer"')
        expect(@resp).to have_the_same_number_of_documents_as(solr_resp_ids_from_query 'mark twain NOT "tom sawyer("')
        expect(@resp).to have_the_same_number_of_documents_as(solr_resp_ids_from_query 'mark twain NOT ")tom sawyer"')
        expect(@resp).to have_the_same_number_of_documents_as(solr_resp_ids_from_query 'mark twain NOT "tom) sawyer"')
        expect(@resp).to have_the_same_number_of_documents_as(solr_resp_ids_from_query 'mark twain NOT "tom )sawyer"')
        expect(@resp).to have_the_same_number_of_documents_as(solr_resp_ids_from_query 'mark twain NOT "tom sawyer)"')
      end
      it 'with unmatched parent outside quote', pending: 'fixme' do
        expect(@resp).to have_the_same_number_of_documents_as(solr_resp_ids_from_query 'mark twain NOT ("tom sawyer"')
        expect(@resp).to have_the_same_number_of_documents_as(solr_resp_ids_from_query 'mark twain NOT "tom sawyer"(')
        expect(@resp).to have_the_same_number_of_documents_as(solr_resp_ids_from_query 'mark twain NOT )"tom sawyer"')
        expect(@resp).to have_the_same_number_of_documents_as(solr_resp_ids_from_query 'mark twain NOT "tom sawyer")')
      end
    end
  end # context NOT

  # TODO: what about lowercase or ?

  context 'OR' do
    #  per Google Analytics mid-April - mid- May 2013
    context 'actual user queries' do
      context 'indochine OR indochina' do
        before(:all) do
          @indochine_or_indochina = solr_resp_doc_ids_only(
            q: '_query_:"{!dismax mm=1}indochine OR indochina"',
            defType: 'lucene'
          )
          @indochine = solr_resp_ids_from_query 'indochine' # 513 docs  2013-05-21
          @indochina = solr_resp_ids_from_query 'indochina' # 1522 docs  2013-05-21
        end
        it 'should have more results than either term alone' do
          expect(@indochine_or_indochina).to have_more_results_than(@indochine)
          expect(@indochine_or_indochina).to have_more_results_than(@indochina)
        end
        it "should have more results than query without OR (terms become 'should match' clauses)" do
          expect(@indochine_or_indochina).to have_more_results_than(solr_resp_ids_from_query 'indochine indochina') # 288 docs 2013-05-21
        end
        it 'should have more results than query with AND substituted for OR' do
          expect(@indochine_or_indochina).to have_more_results_than(solr_resp_ids_from_query 'indochine AND indochina') # 288 docs 2013-05-21
        end
        it 'should have results that match first term but not second term' do
          # titles 'Indochine'
          indochine_results = %w(383033 430603 1921469 3065221 2134301 10316540)
          expect(@indochine).to include(indochine_results)
          expect(@indochine_or_indochina).to include(indochine_results)
          expect(@indochina).not_to include(indochine_results)
        end
        it 'should have results that match second term but not first term' do
          #  titles 'Indochina.'
          indochina_results = %w(1116305 2643130 604830)
          expect(@indochina).to include(indochina_results).in_first(5).documents
          expect(@indochine_or_indochina).to include(indochina_results)
          expect(@indochine).not_to include(indochina_results)
        end
      end
      #   context 'sanitation ethiopia OR addis' do
      #     pending 'to be implemented'
      #   end
      #   context ''mental illness' OR 'mental disorders'' do
      #   end
      #   context 'asian american narratives OR personal essay identity' do
      #    # user probably meant OR to apply to more than two terms on either side
      #    pending 'to be implemented'
      #   end
      #   # all caps queries:  didn't mean it as boolean
      #   #   JOEL-PETER WITKIN: ENFER OU CIEL/HEAVEN OR HELL.
      #   #   WITKIN: ENFER OU CIEL/HEAVEN OR HELL.
      #   #   WITKIN: HEAVEN OR HELL.
    end # actual user queries

    it 'lesbian OR gay videos', jira: ['VUF-300', 'VUF-301', 'VUF-311'] do
      # eloader records cause results to explode; add access facet to keep expected results stable
      resp = solr_resp_doc_ids_only(
        'q' => '_query_:"{!dismax pf2=$p2 pf3=$pf3 mm=1}lesbian OR gay"',
        'defType' => 'lucene',
        'fq' => [
          'format:("Video")',
          'access_facet:("At the Library")'
        ]
      )
      expect(resp.size).to be >= 1200
      expect(resp.size).to be <= 1400
    end

    context 'street art and graffiti', jira: 'VUF-1013' do
      it '((street art) OR graffiti) AND aspects', pending: 'fixme' do
        # this search returns 47 results when the solr query is sent from SearchWorks
        #  47 here is bigger than using quotes below;  probably that is "good enough" for this
        #  test as the use case is not a common one (complex boolean query, nested parens)
        # Solr gets this query from SW app (subject serarch):
        # "q"=>"( ( _query_:\"{!edismax qf=$qf_subject pf=$pf_subject pf3=$pf3_subject pf2=$pf2_subject}street art\" OR
        # _query_:\"{!dismax qf=$qf_subject pf=$pf_subject pf3=$pf3_subject pf2=$pf2_subject}graffiti\" ) AND
        # _query_:\"{!dismax qf=$qf_subject pf=$pf_subject pf3=$pf3_subject pf2=$pf2_subject}aspects\" )"
        resp = solr_resp_doc_ids_only(subject_search_args '((street art) OR graffiti) AND aspects')
        expect(resp.size).to be >= 3820
        expect(resp.size).to be <= 4070
      end
      it '("street art" OR graffiti) AND aspects' do
        # this search returns 39 results when the solr query is sent from SearchWorks
        # "q"=>"( _query_:\"{!dismax qf=$qf_subject pf=$pf_subject pf3=$pf3_subject pf2=$pf2_subject mm=1}\\\"street art\\\" graffiti\" AND
        # _query_:\"{!dismax qf=$qf_subject pf=$pf_subject pf3=$pf3_subject pf2=$pf2_subject}aspects\" )"
        resp = solr_resp_doc_ids_only(subject_search_args '("street art" OR graffiti) AND aspects')
        expect(resp.size).to be >= 30
        expect(resp.size).to be <= 50
        resp_parens = solr_resp_doc_ids_only(subject_search_args '((street art) OR graffiti) AND aspects')
        expect(resp.size).to be < resp_parens.size
      end
    end

    context 'nested OR within NOT as subject', jira: 'VUF-1387' do
      it 'digestive organs' do
        resp = solr_resp_doc_ids_only(subject_search_args 'digestive organs')
        expect(resp.size).to be >= 600
        expect(resp.size).to be <= 650
      end
      it 'digestive organs NOT disease', pending: 'fixme' do
        # the following is busted due to Solr edismax bug that sets mm=1 if it encounters a NOT
        # https://issues.apache.org/jira/browse/SOLR-2649
        resp = solr_resp_doc_ids_only(subject_search_args 'digestive organs NOT disease')
        expect(resp.size).to be >= 100
        expect(resp.size).to be <= 200
      end
      it 'digestive organs NOT disease NOT cancer', pending: 'fixme' do
        # the following is busted due to Solr edismax bug that sets mm=1 if it encounters a NOT
        # https://issues.apache.org/jira/browse/SOLR-2649
        resp = solr_resp_doc_ids_only(subject_search_args 'digestive organs NOT disease NOT cancer')
        expect(resp.size).to be >= 80
        expect(resp.size).to be <= 100
      end
      it 'with parens', pending: 'fixme' do
        # the following is busted due to Solr edismax bug that sets mm=1 if it encounters a NOT
        # https://issues.apache.org/jira/browse/SOLR-2649
        resp = solr_resp_doc_ids_only(subject_search_args 'digestive organs NOT (disease OR cancer)')
        expect(resp.size).to be >= 80
        expect(resp.size).to be <= 100
      end
    end # nested OR within NOT
  end # context OR
end
