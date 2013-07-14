require 'spec_helper'

describe "advanced search" do
  
  context "subject and keyword" do
    context "subject street art OR graffiti", :jira => 'VUF-1013' do
      it "subject ((street art) OR graffiti OR mural)" do
        resp = solr_response({'q'=>"#{subject_query('(+street +art) OR graffiti OR mural')}"}.merge(solr_args))
        resp.should have_at_least(1000).results
        resp.should have_at_most(2000).results
      end
      it "keyword chicano" do
        resp = solr_response({'q'=>"#{description_query('+chicano')}"}.merge(solr_args))
        resp.should have_at_least(2300).results
        resp.should have_at_most(3000).results
      end
      it "subject ((street art) OR graffiti OR mural) and keyword chicano" do
        resp = solr_response({'q'=>"#{subject_query('(+street +art) OR graffiti OR mural')} AND #{description_query('+chicano')}"}.merge(solr_args))
        resp.should include(['3034294','525462','3120734','1356131','7746467'])
        resp.should have_at_most(10).results
      end
      # can't do quotes in a local params query
      it 'subject ("street art" OR graffiti OR mural) and keyword chicano', :fixme => true do
        resp = solr_response({'q'=>"#{subject_query('(+"street art") OR graffiti OR mural')} AND #{description_query('+chicano')}"}.merge(solr_args))
        resp.should include(['3034294','525462','3120734','1356131','7746467'])
        resp.should have_at_most(10).results
      end
    end

    context "subject -congresses, keyword IEEE xplore", :jira => 'SW-623' do
      it "subject -congresses" do
        # NOTE: advanced qp currently doesn't support hyphen as NOT
        resp = solr_response({'q'=>"#{subject_query('(-congresses)')}"}.merge(solr_args))
        resp.should have_at_least(200000).results
      end
      it "subject NOT congresses" do
        resp = solr_response({'q'=>"NOT #{subject_query('congresses')}"}.merge(solr_args))
        resp.should have_at_least(200000).results
      end
      it "keyword" do
        resp = solr_response({'q'=>"#{description_query('+IEEE +xplore')}"}.merge(solr_args))
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query("IEEE Xplore"))
        resp.should have_at_least(6000).results
        resp.should have_at_most(7250).results
        #  optional terms (no +)
        resp.should have_fewer_results_than(solr_response({'q'=>"#{description_query('IEEE xplore')}"}.merge(solr_args)))
      end
      it "subject NOT congresses and keyword" do
        resp = solr_response({'q'=>"NOT #{subject_query('congresses')} AND #{description_query('+IEEE +xplore')}"}.merge(solr_args))
        resp.should have_at_least(800).results
        resp.should have_at_most(900).results
      end
    end

    context "subject home schooling, keyword Socialization", :jira => 'VUF-1352' do
      before(:all) do
        @sub_no_phrase = solr_response({'q'=>"#{subject_query('+home +schooling')}"}.merge(solr_args))
        # single term doesn't require +
        @sub_phrase = solr_response({'q'=>"#{subject_query('"home schooling"')}"}.merge(solr_args))
      end
      it "subject not as a phrase" do
        @sub_no_phrase.should have_at_least(575).results
        @sub_no_phrase.should have_at_most(650).results
        @sub_no_phrase.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(subject_search_args('home schooling')))
      end
      it "subject as a phrase", :fixme => true do
        # phrase searching doesn't work with advanced search (local params)
        @sub_phrase.should have_at_least(500).results
        @sub_phrase.should have_at_most(574).results
        @sub_phrase.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(subject_search_args('"home schooling"')))
        @sub_phrase.should have_fewer_results_than @sub_no_phrase
      end
      it "keyword" do
        resp = solr_response({'q'=>"#{description_query('+Socialization')}"}.merge(solr_args))
#          resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query("Socialization"))
        #  optional single term (no +) same as required single term
        resp.should have_the_same_number_of_results_as(solr_response({'q'=>"#{description_query('Socialization')}"}.merge(solr_args)))
        resp.should have_at_least(400000).results
        resp.should have_at_most(500000).results
      end
      it "subject (not a phrase) and keyword" do
        #  optional single term (no +) same as required single term
        resp = solr_response({'q'=>"#{subject_query('+home +schooling')} AND #{description_query('Socialization')}"}.merge(solr_args))
        resp.should have_fewer_results_than(@sub_no_phrase)
        resp.should have_at_least(75).results
        resp.should have_at_most(150).results
      end
    end
  end # subject and keyword
  
  context "author" do
    context 'author phrase "Institute for Mathematical Studies in the Social Sciences"', :jira => 'VUF-1698' do
      before(:all) do
        @qterms = 'Institute for Mathematical Studies in the Social Sciences'
        @no_phrase = solr_response({'q'=>"#{author_query('+Institute +for +Mathematical +Studies +in +the +Social +Sciences')}"}.merge(solr_args))
        #  optional single term (no +) same as required single term
        @phrase = solr_response({'q'=>"#{author_query('"Institute for Mathematical Studies in the Social Sciences"')}"}.merge(solr_args))
      end
      it "number of results with each term required, not as a phrase" do
        @no_phrase.should have_at_least(725).results
        @no_phrase.should have_at_most(800).results
      end
      it "number of results as a phrase", :fixme => true do
        # NOTE:  phrases aren't supposed to work with advanced search (local params)
        #    ?? phrase gets more due to allowed phrase slop?  long query, lots of common words
        @phrase.should have_at_least(900).results
        @phrase.should have_at_most(950).results
      end
      it "have the same number of results as a plain author query", :fixme => true do
        @no_phrase.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(author_search_args(@qterms)))
        @phrase.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(author_search_args('"' + @qterms + '"')))
      end
    end
  end # author
  
  context "author + title" do
    context "author title: history man by malcolm bradbury", :jira => 'SW-805' do
      it "author" do
        resp = solr_response({'q'=>"#{author_query('+malcolm +bradbury')}"}.merge(solr_args))
        resp.should have_at_least(40).results
        resp.should have_at_most(60).results
        resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(author_search_args('malcolm bradbury')))
      end
      it "title" do
        resp = solr_response({'q'=>"#{title_query('+the +history +man')}"}.merge(solr_args))
        resp.should have_at_least(1200).results
        resp.should have_at_most(1300).results
      end
      it "author and title" do
        resp = solr_response({'q'=>"#{author_query('+malcolm +bradbury')} AND #{title_query('+the +history +man')}"}.merge(solr_args))
        resp.should include('1433520').as_first
        resp.should have_at_most(3).results
      end
    end
    
    context "author Stalin title 'rechi OR sochineniia'", :jira => 'VUF-1381' do
      before(:all) do
        @author_resp = solr_response({'q'=>"#{author_query('stalin')}"}.merge(solr_args))
      end
      it "author" do
        # required operator (+) is not needed for single arg
        @author_resp.should have_the_same_number_of_results_as(solr_response({'q'=>"#{author_query('+stalin')}"}.merge(solr_args)))
        @author_resp.should have_at_least(600).results
        @author_resp.should have_at_most(700).results
        @author_resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(author_search_args('stalin')))
      end
      it "title rechi OR sochineniia" do
        resp = solr_response({'q'=>"#{title_query('rechi sochineniia')}"}.merge(solr_args))
        resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(title_search_args('rechi OR sochineniia')))
        resp.should have_at_least(2200).results
        resp.should have_at_most(2400).results
      end
      it "author + title rechi" do
        resp = solr_response({'q'=>"#{author_query('stalin')} AND #{title_query('rechi')}"}.merge(solr_args))
        resp.should have_fewer_results_than @author_resp
        resp.should have_at_least(12).results
        resp.should have_at_most(20).results
      end
      it "author + title sochineniia" do
        resp = solr_response({'q'=>"#{author_query('stalin')} AND #{title_query('sochineniia')}"}.merge(solr_args))
        resp.should have_fewer_results_than @author_resp
        resp.should have_at_least(5).results
        resp.should have_at_most(12).results
      end
      it "author and title both terms optional" do
        resp = solr_response({'q'=>"#{author_query('stalin')} AND #{title_query('rechi sochineniia')}"}.merge(solr_args))
        resp.should have_fewer_results_than @author_resp
        resp.should have_at_least(20).results
        resp.should have_at_most(30).results
      end
    end

    context "author mcrae, title jazz", :jira => 'SW-168' do
      it "author barry mcrae title jazz" do
        resp = solr_response({'q'=>"#{author_query('+mcrae +barry')} AND #{title_query('jazz')}"}.merge(solr_args))
        resp.should have_fewer_results_than(solr_resp_ids_from_query "barry mcrae jazz")
        resp.should include(['2130330', '336046']).in_first(2)
        resp.should have_at_most(10).results
      end
      it "author mcrae title jazz" do
        resp = solr_response({'q'=>"#{author_query('mcrae')} AND #{title_query('jazz')}"}.merge(solr_args))
        resp.should have_fewer_results_than(solr_resp_ids_from_query "mcrae jazz")
        resp.should include(['2130330', '336046', '7637875', '6634054'])
        resp.should have_at_most(50).results
      end
    end
  end # author + title
  
  context "author + keyword" do
    context "author campana, keywords storia e letteratura", :jira => 'VUF-2468' do
      before(:all) do
        @author_resp = solr_response({'q'=>"#{author_query('campana')}"}.merge(solr_args))
      end
      it "author" do
        #  optional single term (without +) same as required single term
        @author_resp.should have_the_same_number_of_results_as(solr_response({'q'=>"#{author_query('+campana')}"}.merge(solr_args)))
        @author_resp.should have_at_least(175).results
        @author_resp.should have_at_most(225).results
        @author_resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(author_search_args('campana')))
      end
      it "keyword" do
        resp = solr_response({'q'=>"#{description_query('+storia +e +letteratura')}"}.merge(solr_args))
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query("storia e letteratura"))
        resp.should have_at_least(1500).results
        resp.should have_at_most(2000).results
      end
      it "author and keyword" do
        resp = solr_response({'q'=>"#{author_query('campana')} AND #{description_query('+storia +e +letteratura')}"}.merge(solr_args))
        resp.should have_fewer_results_than(@author_resp)
        resp.should have_at_most(10).results
      end
    end
  end # author + keyword
  
  context "nested NOT in subject", :jira => 'VUF-1387' do
    it "digestive organs" do
      resp = solr_response({'q'=>"#{subject_query('+digestive +organs')}"}.merge(solr_args))
      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(subject_search_args 'digestive organs'))
      resp.should have_at_least(325).results
      resp.should have_at_most(400).results
    end
    it "digestive organs NOT disease" do
      resp = solr_response({'q'=>"#{subject_query('+digestive +organs')} AND NOT #{subject_query('disease')}"}.merge(solr_args))
      # the following is busted due to Solr edismax bug that sets mm=1 if it encounters a NOT
      # https://issues.apache.org/jira/browse/SOLR-2649
#      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(subject_search_args 'digestive organs NOT disease'))
      resp.should have_at_least(100).results
      resp.should have_at_most(200).results
    end
    it "digestive organs NOT disease NOT cancer" do
      resp = solr_response({'q'=>"#{subject_query('+digestive +organs')} AND NOT #{subject_query('disease')} AND NOT #{subject_query('cancer')}"}.merge(solr_args))
      # the following is busted due to Solr edismax bug that sets mm=1 if it encounters a NOT
      # https://issues.apache.org/jira/browse/SOLR-2649
#      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(subject_search_args 'digestive organs NOT disease NOT cancer'))
      resp.should have_at_least(80).results
      resp.should have_at_most(100).results
    end
    it "with parens" do
      resp = solr_response({'q'=>"#{subject_query('+digestive +organs')} AND NOT #{subject_query('(disease OR cancer)')}"}.merge(solr_args))
      # the following is busted due to Solr edismax bug that sets mm=1 if it encounters a NOT
      # https://issues.apache.org/jira/browse/SOLR-2649
#      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(subject_search_args 'digestive organs NOT (disease OR cancer)'))
      resp.should have_at_least(80).results
      resp.should have_at_most(100).results
    end
  end
  
  context "pub info" do

    it "publisher and place and year", :jira => 'SW-202' do
      resp = solr_response({'q'=>"#{pub_info_query('+Instress, +Saratoga, +1999')}"}.merge(solr_args))
      resp.should include(['4123450', '4282796', '4314776', '4297734', '4233634'])
      resp.should have_at_most(10).results
    end

    context "subject 'soviet union and historiography' and pub info '1910-1911", :jira => 'VUF-1781' do
      it "subject" do
        resp = solr_response({'q'=>"#{subject_query('+soviet +union +and +historiography')}"}.merge(solr_args))
        resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(subject_search_args 'soviet union and historiography'))
        resp.should have_at_least(200).results
        resp.should have_at_most(250).results
      end
      it "subject without 'and'" do
        resp = solr_response({'q'=>"#{subject_query('+soviet +union +historiography')}"}.merge(solr_args))
        resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(subject_search_args 'soviet union historiography'))
        resp.should have_at_least(875).results
        resp.should have_at_most(950).results
      end
      it "pub info 2010" do
        resp = solr_response({'q'=>"#{pub_info_query('+2010')}"}.merge(solr_args))
        resp.should have_at_least(127000).results
        resp.should have_at_most(130000).results
      end
      it "pub info 2011" do
        resp = solr_response({'q'=>"#{pub_info_query('+2011')}"}.merge(solr_args))
        resp.should have_at_least(114000).results
        resp.should have_at_most(116000).results
      end
      it "subject and pub info 2010" do
        resp = solr_response({'q'=>"#{subject_query('+soviet +union +and +historiography')} AND #{pub_info_query('+2010')}"}.merge(solr_args))
        resp.should have_at_least(8).results
        resp.should have_at_most(15).results
      end
      it "subject and pub info 2011" do
        resp = solr_response({'q'=>"#{subject_query('+soviet +union +and +historiography')} AND #{pub_info_query('+2011')}"}.merge(solr_args))
        resp.should have_at_least(15).results
        resp.should have_at_most(25).results
      end
      it "subject without 'and' and pub info 2010" do
        resp = solr_response({'q'=>"#{subject_query('+soviet +union +historiography')} AND #{pub_info_query('+2010')}"}.merge(solr_args))
        resp.should have_at_least(15).results
        resp.should have_at_most(25).results
      end
      it "subject without 'and' and pub info 2011" do
        resp = solr_response({'q'=>"#{subject_query('+soviet +union +historiography')} AND #{pub_info_query('+2011')}"}.merge(solr_args))
        resp.should have_at_least(25).results
        resp.should have_at_most(40).results
      end
      context "search range of years in pub_info", :fixme => true do
        it "pub info 2010-2011" do
          resp = solr_response({'q'=>"#{pub_info_query('+2010-2011')}"}.merge(solr_args))
          resp.should have_the_same_number_of_results_as(solr_response({'q'=>"#{pub_info_query('+2010 +2011')}"}.merge(solr_args)))
          resp.should have_at_least(2).results
          resp.should have_at_most(10).results
        end
        it "subject and pub info" do
          resp = solr_response({'q'=>"#{subject_query('+soviet +union +and +historiography')} AND #{pub_info_query('+2010-2011')}"}.merge(solr_args))
          resp.should have_at_least(25).results
          resp.should have_at_most(35).results
        end
        it "subject without 'and' and pub info" do
          resp = solr_response({'q'=>"#{subject_query('+soviet +union +historiography')} AND #{pub_info_query('+2010-2011')}"}.merge(solr_args))
          resp.should have_at_least(35).results
          resp.should have_at_most(60).results
        end
      end
    end # subject + pub info
  end # pub info
    
  context "number search" do
    it "should allow barcode searches", :jira => 'SW-682' do
      resp = solr_response({'q'=>"#{number_query('36105041286266')}"}.merge(solr_args))
      resp.should include('2029735').as_first
      resp.should have_at_most(3).results
    end
  end
  
  context "facets" do
    context "format video, location green, language english", :jira => 'VUF-2460' do
      before(:all) do
      end
      it "before topics selected" do
        resp = solr_response({'fq' => 'format:("Video"), language:("English"), building_facet:("Green")', 'q'=>'collection:*'}.merge(solr_args))
        resp.should have_at_least(22000).results
        resp.should have_at_most(35000).results
      end
      it "add topic feature films" do
        resp = solr_response({'fq' => 'format:("Video"), language:("English"), building_facet:("Green"), topic_facet:("Feature films")', 'q'=>'collection:*'}.merge(solr_args))
        resp.should have_at_least(14500).results
        resp.should have_at_most(18000).results
      end
      it "add topic science fiction" do
        resp = solr_response({'fq' => 'format:("Video"), language:("English"), building_facet:("Green"), topic_facet:("Feature films"), topic_facet:("Science fiction films")', 'q'=>'collection:*'}.merge(solr_args))
        resp.should have_at_least(525).results
        resp.should have_at_most(650).results
      end
    end
  end
  
  def title_query terms
    '_query_:"{!dismax qf=$qf_title pf=$pf_title pf3=$pf_title3 pf2=$pf_title2}' + terms + '"'
  end
  def author_query terms
    '_query_:"{!dismax qf=$qf_author pf=$pf_author pf3=$pf_author3 pf2=$pf_author2}' + terms + '"'
  end
  def subject_query terms
    '_query_:"{!dismax qf=$qf_subject pf=$pf_subject pf3=$pf_subject3 pf2=$pf_subject2}' + terms + '"'
  end
  def description_query terms
    '_query_:"{!dismax qf=$qf_description pf=$pf_description pf3=$pf_description3 pf2=$pf_description2}' + terms + '"'
  end
  def pub_info_query terms
    '_query_:"{!dismax qf=$qf_pub_info pf=$pf_pub_info pf3=$pf_pub_info3 pf2=$pf_pub_info2}' + terms + '"'
  end
  def number_query terms
    '_query_:"{!dismax qf=$qf_number pf=$pf_number pf3=$pf_number3 pf2=$pf_number2}' + terms + '"'
  end
  def solr_args
    {"qt"=>"advanced"}.merge(doc_ids_only)
  end
end