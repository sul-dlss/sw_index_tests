require 'spec_helper'

describe 'boolean operators' do
  # TODO: more better tests for lowercase and?
  context 'default operator:  AND' do
    context 'everything search' do
      it 'more search terms should get fewer results' do
        resp = solr_resp_ids_from_query 'horn'
        resp.should have_more_documents_than(solr_resp_ids_from_query 'french horn')
      end
      it 'loggerhead turtles should not have Shakespeare in facets' do
        resp = solr_response('q' => 'loggerhead turtles', 'fl' => 'id')
        # Shakespeare was in the facets when default was 'OR'
        resp.should_not have_facet_field('author_person_facet').with_value('Shakespeare, William, 1564-1616')
        resp = solr_response('q' => 'turtles', 'fl' => 'id')
        resp.should have_facet_field('author_person_facet').with_value('Shakespeare, William, 1564-1616')
      end
    end

    context 'author search' do
      it 'more search terms should get fewer results' do
        resp = solr_resp_doc_ids_only(author_search_args('michaels'))
        resp.should have_more_documents_than(solr_resp_doc_ids_only(author_search_args('leonard michaels')))
      end
    end

    context 'title search' do
      it 'more search terms should get fewer results' do
        resp = solr_resp_doc_ids_only(title_search_args('turtles'))
        resp.should have_more_documents_than(solr_resp_doc_ids_only(title_search_args('sea turtles')))
      end
    end

    it 'across MARC fields (author and title)' do
      resp = solr_resp_ids_from_query 'gulko sea turtles'
      resp.should have(1).document
      resp.should include('5958831')
      resp = solr_resp_ids_from_query 'eckert sea turtles'
      resp.should have(2).document
      resp.should include('5958831')
    end

    context '5 terms with AND' do
      before(:all) do
        @resp = solr_resp_ids_from_query 'Catholic thought AND papal jewry policy'
      end
      it 'should include doc 1711043' do
        @resp.should have(1).document
        @resp.should include('1711043')
      end
      it "should get the same results as lowercase 'and'" do
        @resp.should have_the_same_number_of_documents_as(solr_resp_ids_from_query 'Catholic thought and papal jewry policy')
      end
    end

    context 'history man by malcolm bradbury', jira: 'SW-805' do
      # lowercase and is considered a query term
      it 'history man and bradbury', fixme: true do
        resp = solr_resp_ids_from_query 'history man and bradbury'
        resp.should include('1433520').in_first(3)
      end
      it 'history man AND bradbury' do
        resp = solr_resp_ids_from_query 'history man AND bradbury'
        resp.should include('1433520').in_first(3)
      end
      it 'history man bradbury' do
        resp = solr_resp_ids_from_query 'history man bradbury'
        resp.should include('1433520').in_first(3)
      end
      it 'history man bradbury malcolm' do
        resp = solr_resp_ids_from_query 'history man bradbury malcolm'
        resp.should include('1433520').in_first(3)
      end
      it 'history man malcolm bradbury' do
        resp = solr_resp_ids_from_query 'history man malcolm bradbury'
        resp.should include('1433520').in_first(3)
      end
      it 'history man' do
        resp = solr_resp_ids_from_query 'history man'
        resp.should include('1433520').in_first(3)
      end
    end

    it "lower case 'and' behaves like upper case AND", jira: 'VUF-626' do
      resp = solr_resp_ids_from_query 'South Africa, Shakespeare AND post-colonial culture'
      resp.should include(%w(8505958 4745861 7837826 7756621))
      resp2 = solr_resp_ids_from_query 'South Africa, Shakespeare and post-colonial culture'
      resp2.should include(%w(8505958 4745861 7837826 7756621))
      resp.should have_the_same_number_of_documents_as(resp2)
    end
  end # context AND

  # TODO: what about lowercase not?

  context 'NOT operator' do
    shared_examples_for 'NOT negates following term' do |query, exp_ids, un_exp_ids, first_n|
      before(:all) do
        @resp = solr_resp_ids_from_query query
      end
      it 'should have expected results' do
        @resp.should include(exp_ids).in_first(first_n).documents
      end
      it 'should not have unexpected results' do
        @resp.should_not include(un_exp_ids)
      end
      it 'query that includes term should match unexpected ids' do
        # or we don't have good unexpected ids for the test
        resp_w_term = solr_resp_ids_from_query query.sub(' NOT ', ' ')
        resp_w_term.should include(un_exp_ids)
      end
      # the following is busted due to Solr edismax bug
      # https://issues.apache.org/jira/browse/SOLR-2649
      it 'should have fewer results than query without NOT clause', fixme: true do
        @resp.should have_fewer_documents_than(solr_resp_ids_from_query query.sub(/ NOT \S+ ?/, ' '))
      end
      it "hyphen with space before but not after (' -a') should be equivalent to NOT" do
        @resp.should have_the_same_number_of_documents_as(solr_resp_ids_from_query query.sub(' NOT ', ' -'))
      end
    end # shared examples for NOT in query

    #  per Google Analytics mid-April - mid- May 2013
    context 'actual user queries' do
      # the following is busted due to Solr edismax bug
      # https://issues.apache.org/jira/browse/SOLR-2649
      context 'space exploration NOT nasa', fixme: true do
        it_behaves_like 'NOT negates following term', 'space exploration NOT nasa', '4146206', '2678639', 5
        it 'has an appropriate number of results' do
          resp = solr_resp_ids_from_query 'space exploration NOT nasa'
          resp.should have_at_least(6300).documents
          resp.should have_at_most(7250).documents # 2013-05-21  space exploration: 7896 results
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
        @resp.should have_documents
        @resp.should have_fewer_documents_than(solr_resp_ids_from_query 'twain')
      end
      it 'should be equivalent to twain -sawyer' do
        @resp.should have_the_same_number_of_documents_as(solr_resp_ids_from_query 'twain -sawyer')
      end
    end

    context "query with NOT applied to phrase:  mark twain NOT 'tom sawyer'" do
      before(:all) do
        @resp = solr_resp_ids_from_query 'mark twain NOT "tom sawyer"'
      end

      it "should have no results with 'tom sawyer' as a phrase" do
        resp = solr_response('q' => 'mark twain NOT "tom sawyer"', 'fl' => 'id,title_245a_display', 'facet' => false)
        @resp.should have_at_least(1400).documents
        resp.should_not include('title_245a_display' => /tom sawyer/i).in_each_of_first(20).documents
      end
      it "should be equivalent to mark twain -'tom sawyer'" do
        @resp =  have_the_same_number_of_documents_as(solr_resp_ids_from_query 'mark twain -"tom sawyer"')
      end
      it "should get more results than 'mark twain 'tom sawyer''" do
        @resp.should have_more_results_than(solr_resp_ids_from_query 'mark twain "tom sawyer"')
      end
      it "should get more results than 'mark twain tom sawyer'" do
        @resp.should have_more_results_than(solr_resp_ids_from_query 'mark twain tom sawyer')
      end

      it 'should work with parens', jira: 'VUF-379' do
        resp = solr_resp_ids_from_query 'mark twain NOT (tom sawyer)'
        resp.should have_at_least(1400).documents
      end
      it 'with parens inside quote' do
        resp = solr_resp_ids_from_query 'mark twain NOT "(tom sawyer)"' # 0 documents
        resp.should have_at_least(1400).documents
        resp.should have_the_same_number_of_documents_as(@resp)
      end
      it 'with parens outside quote' do
        resp = solr_resp_ids_from_query 'mark twain NOT ("tom sawyer")' # 0 documents
        resp.should have_at_least(1400).documents
        resp.should have_the_same_number_of_documents_as(@resp)
      end
      it 'with unmatched paren inside quotes' do
        @resp.should have_the_same_number_of_documents_as(solr_resp_ids_from_query 'mark twain NOT "(tom sawyer"')
        @resp.should have_the_same_number_of_documents_as(solr_resp_ids_from_query 'mark twain NOT "tom( sawyer"')
        @resp.should have_the_same_number_of_documents_as(solr_resp_ids_from_query 'mark twain NOT "tom (sawyer"')
        @resp.should have_the_same_number_of_documents_as(solr_resp_ids_from_query 'mark twain NOT "tom sawyer("')
        @resp.should have_the_same_number_of_documents_as(solr_resp_ids_from_query 'mark twain NOT ")tom sawyer"')
        @resp.should have_the_same_number_of_documents_as(solr_resp_ids_from_query 'mark twain NOT "tom) sawyer"')
        @resp.should have_the_same_number_of_documents_as(solr_resp_ids_from_query 'mark twain NOT "tom )sawyer"')
        @resp.should have_the_same_number_of_documents_as(solr_resp_ids_from_query 'mark twain NOT "tom sawyer)"')
      end
      it 'with unmatched parent outside quote', fixme: true do
        @resp.should have_the_same_number_of_documents_as(solr_resp_ids_from_query 'mark twain NOT ("tom sawyer"')
        @resp.should have_the_same_number_of_documents_as(solr_resp_ids_from_query 'mark twain NOT "tom sawyer"(')
        @resp.should have_the_same_number_of_documents_as(solr_resp_ids_from_query 'mark twain NOT )"tom sawyer"')
        @resp.should have_the_same_number_of_documents_as(solr_resp_ids_from_query 'mark twain NOT "tom sawyer")')
      end
    end
  end # context NOT

  # TODO: what about lowercase or ?

  context 'OR' do
    #  per Google Analytics mid-April - mid- May 2013
    context 'actual user queries' do
      context 'indochine OR indochina' do
        before(:all) do
          @indochine_or_indochina = solr_resp_ids_from_query 'indochine OR indochina'
          @indochine = solr_resp_ids_from_query 'indochine' # 513 docs  2013-05-21
          @indochina = solr_resp_ids_from_query 'indochina' # 1522 docs  2013-05-21
        end
        it 'should have more results than either term alone' do
          @indochine_or_indochina.should have_more_results_than(@indochine)
          @indochine_or_indochina.should have_more_results_than(@indochina)
        end
        it "should have more results than query without OR (terms become 'should match' clauses)" do
          @indochine_or_indochina.should have_more_results_than(solr_resp_ids_from_query 'indochine indochina') # 288 docs 2013-05-21
        end
        it 'should have more results than query with AND substituted for OR' do
          @indochine_or_indochina.should have_more_results_than(solr_resp_ids_from_query 'indochine AND indochina') # 288 docs 2013-05-21
        end
        it 'should have results that match first term but not second term' do
          # titles 'Indochine'
          indochine_results = %w(383033 430603 4312384 3083716 3065221 2134301)
          @indochine.should include(indochine_results)
          @indochine_or_indochina.should include(indochine_results)
          @indochina.should_not include(indochine_results)
        end
        it 'should have results that match second term but not first term' do
          #  titles 'Indochina.'
          indochina_results = %w(1116305 2643130 604830)
          @indochina.should include(indochina_results).in_first(5).documents
          @indochine_or_indochina.should include(indochina_results)
          @indochine.should_not include(indochina_results)
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
      resp = solr_resp_doc_ids_only('q' => 'lesbian OR gay', 'fq' => 'format:Video')
      resp.should have_at_least(1000).results
      resp.should have_at_most(1500).results
    end

    context 'street art and graffiti', jira: 'VUF-1013' do
      it '((street art) OR graffiti) AND aspects' do
        resp = solr_resp_doc_ids_only(subject_search_args '((street art) OR graffiti) AND aspects')
        resp.should have_at_least(3000).results
        resp.should have_at_most(3700).results
      end
      it '("street art" OR graffiti) AND aspects' do
        resp = solr_resp_doc_ids_only(subject_search_args '("street art" OR graffiti) AND aspects')
        resp.should have_at_least(20).results
        resp.should have_at_most(40).results
      end
    end

    context 'nested OR within NOT as subject', jira: 'VUF-1387' do
      it 'digestive organs' do
        resp = solr_resp_doc_ids_only(subject_search_args 'digestive organs')
        resp.should have_at_least(500).results
        resp.should have_at_most(600).results
      end
      it 'digestive organs NOT disease', fixme: true do
        # the following is busted due to Solr edismax bug that sets mm=1 if it encounters a NOT
        # https://issues.apache.org/jira/browse/SOLR-2649
        resp = solr_resp_doc_ids_only(subject_search_args 'digestive organs NOT disease')
        resp.should have_at_least(100).results
        resp.should have_at_most(200).results
      end
      it 'digestive organs NOT disease NOT cancer', fixme: true do
        # the following is busted due to Solr edismax bug that sets mm=1 if it encounters a NOT
        # https://issues.apache.org/jira/browse/SOLR-2649
        resp = solr_resp_doc_ids_only(subject_search_args 'digestive organs NOT disease NOT cancer')
        resp.should have_at_least(80).results
        resp.should have_at_most(100).results
      end
      it 'with parens', fixme: true do
        # the following is busted due to Solr edismax bug that sets mm=1 if it encounters a NOT
        # https://issues.apache.org/jira/browse/SOLR-2649
        resp = solr_resp_doc_ids_only(subject_search_args 'digestive organs NOT (disease OR cancer)')
        resp.should have_at_least(80).results
        resp.should have_at_most(100).results
      end
    end # nested OR within NOT
  end # context OR
end
