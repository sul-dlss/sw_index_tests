describe 'advanced search' do
  context 'title with boolean', jira: 'SW-939' do
    context 'color OR colour photography', jira: 'SW-939' do
      before(:all) do
        @color = solr_resp_doc_ids_only({ 'q' => "#{title_query('color photography')}" }.merge(solr_args))
        @colour = solr_resp_doc_ids_only({ 'q' => "#{title_query('colour photography')}" }.merge(solr_args))
      end
      it 'color OR colour photography' do
        resp = solr_resp_ids_titles({ 'q' => "#{title_query('photography')} AND #{title_query_or('(color OR colour)')}" }.merge(solr_args))
        expect(resp).to have_more_results_than(@color)
        expect(resp).to have_more_results_than(@colour)
        expect(resp).to include('title_245a_display' => /color photography/i)
        expect(resp).to include('title_245a_display' => /colour photography/i)
        # as of 2018-08-30, there are 84 color photography titles and 27 colour photography titles
        expect(resp.size).to be >= 50
        expect(resp.size).to be <= 200
      end
    end
    context 'nossa OR nuestra america', jira: 'SW-939' do
      before(:all) do
        @nossa = solr_resp_doc_ids_only({ 'q' => "#{title_query('nossa america')}" }.merge(solr_args))
        @nuestra = solr_resp_doc_ids_only({ 'q' => "#{title_query('nuestra america')}" }.merge(solr_args))
      end
      it 'nossa OR nuestra america' do
        resp = solr_resp_ids_titles({ 'q' => "#{title_query('america')} AND #{title_query_or('(nossa OR nuestra)')}" }.merge(solr_args))
        expect(resp).to have_more_results_than(@nossa)
        expect(resp).to have_more_results_than(@nuestra)
        expect(resp).to include('title_245a_display' => /nossa am[eé]rica/i)
        expect(resp).to include('title_245a_display' => /nuestra am[eé]rica/i)
        # as of 2018-08-30, there are 13 nossa america titles and 471 nuestra america titles
        expect(resp.size).to be >= 375
        expect(resp.size).to be <= 500
      end
    end
  end

  context 'subject and keyword' do
    context 'subject street art OR graffiti', jira: 'VUF-1013' do
      # the following is busted due to Solr edismax bug that sets mm=1 if it encounters a OR
      # https://issues.apache.org/jira/browse/SOLR-2649
      it 'subject ((street art) OR graffiti OR mural)', pending: 'fixme' do
        resp = solr_resp_doc_ids_only({ 'q' => "#{subject_query('(street art) OR graffiti OR mural')}" }.merge(solr_args))
        expect(resp.size).to be >= 1000
        expect(resp.size).to be <= 2000
      end
      it 'keyword chicano' do
        resp = solr_resp_doc_ids_only({ 'q' => 'chicano' }.merge(solr_args))
        expect(resp.size).to be >= 3500
        expect(resp.size).to be <= 4100
      end
      # the following is busted due to Solr edismax bug that sets mm=1 if it encounters a OR
      # https://issues.apache.org/jira/browse/SOLR-2649
      it 'subject ((street art) OR graffiti OR mural) and keyword chicano', pending: 'fixme' do
        resp = solr_resp_doc_ids_only({ 'q' => "#{subject_query('(street art) OR graffiti OR mural')} AND #{description_query('chicano')}" }.merge(solr_args))
        expect(resp).to include(%w(3034294 525462 3120734 1356131 7746467))
        expect(resp.size).to be <= 10
      end
      # the following is busted due to Solr edismax bug that sets mm=1 if it encounters a OR
      # https://issues.apache.org/jira/browse/SOLR-2649
      it "subject ('street art' OR graffiti OR mural) and keyword chicano", pending: 'fixme' do
        resp = solr_resp_doc_ids_only({ 'q' => "#{subject_query('\"street art\" OR graffiti OR mural')} AND #{description_query('chicano')}" }.merge(solr_args))
        expect(resp).to include(%w(3034294 525462 3120734 1356131 7746467))
        expect(resp.size).to be <= 10
      end
    end

    context 'subject -congresses, keyword IEEE xplore', jira: 'SW-623' do
      it 'subject -congresses' do
        resp = solr_resp_doc_ids_only({ 'q' => "#{subject_query('(-congresses)')}" }.merge(solr_args))
        expect(resp.size).to be >= 200_000
      end
      it 'subject NOT congresses' do
        resp = solr_resp_doc_ids_only({ 'q' => "#{subject_query('NOT congresses')}" }.merge(solr_args))
        expect(resp.size).to be >= 200_000
      end
      it 'keyword' do
        resp = solr_resp_doc_ids_only({ 'q' => 'IEEE xplore' }.merge(solr_args))
        expect(resp).to have_the_same_number_of_results_as(solr_resp_ids_from_query('IEEE Xplore'))
        expect(resp.size).to be >= 13_500
        expect(resp.size).to be <= 14_700
        expect(resp).to have_fewer_results_than(solr_resp_doc_ids_only({ 'q' => 'IEEE OR xplore' }.merge(solr_args)))
      end
      it 'subject NOT congresses and keyword' do
        resp = solr_resp_doc_ids_only({ 'q' => "#{subject_query('NOT congresses')} AND IEEE xplore" }.merge(solr_args))
        expect(resp.size).to be >= 1500
        expect(resp.size).to be <= 2500
      end
    end

    context 'subject home schooling, keyword Socialization', jira: 'VUF-1352' do
      before(:all) do
        @sub_no_phrase = solr_resp_doc_ids_only({ 'q' => "#{subject_query('home schooling')}" }.merge(solr_args))
        @sub_phrase = solr_resp_doc_ids_only({ 'q' => "#{subject_query('\"home schooling\"')}" }.merge(solr_args))
      end
      it 'subject not as a phrase' do
        expect(@sub_no_phrase.size).to be >= 600
        expect(@sub_no_phrase.size).to be <= 770
        expect(@sub_no_phrase).to have_the_same_number_of_results_as(solr_resp_doc_ids_only(subject_search_args('home schooling')))
      end
      it 'subject as a phrase' do
        expect(@sub_phrase.size).to be >= 600
        expect(@sub_phrase.size).to be <= 675
        expect(@sub_phrase).to have_fewer_results_than(solr_resp_doc_ids_only(subject_search_args("home schooling")))
        expect(@sub_phrase).to have_fewer_results_than @sub_no_phrase
      end
      it 'keyword' do
        resp = solr_resp_doc_ids_only({ 'q' => 'Socialization' }.merge(solr_args))
        expect(resp).to have_fewer_results_than(solr_resp_ids_from_query('Socialization'))
        expect(resp.size).to be >= 575_000
        expect(resp.size).to be <= 600_000
      end
      it 'subject (not a phrase) and keyword' do
        resp = solr_resp_doc_ids_only({ 'q' => "#{subject_query('home schooling')} AND Socialization" }.merge(solr_args))
        expect(resp).to have_fewer_results_than(@sub_no_phrase)
        expect(resp.size).to be >= 75
        expect(resp.size).to be <= 150
      end
    end
  end # subject and keyword

  context 'author' do
    context 'author phrase "Institute for Mathematical Studies in the Social Sciences"', jira: 'VUF-1698' do
      before(:all) do
        @qterms = 'Institute for Mathematical Studies in the Social Sciences'
        # mark required or mm kicks in, as there are 8 terms
        @no_phrase = solr_resp_doc_ids_only({ 'q' => "#{author_query('+Institute +for +Mathematical +Studies +in +the +Social +Sciences')}" }.merge(solr_args))
        @phrase = solr_resp_doc_ids_only({ 'q' => "#{author_query('\"Institute for Mathematical Studies in the Social Sciences\"')}" }.merge(solr_args))
      end
      it 'number of results with each term required, not as a phrase' do
        expect(@no_phrase.size).to be >= 725
        expect(@no_phrase.size).to be <= 800
      end
      it 'number of results as a phrase' do
        expect(@phrase.size).to be >= 725
        expect(@phrase.size).to be <= 800
      end
      it 'have the same number of results as a plain author query' do
        expect(@no_phrase).to have_the_same_number_of_results_as(solr_resp_doc_ids_only(author_search_args('+Institute +for +Mathematical +Studies +in +the +Social +Sciences')))
        expect(@phrase).to have_the_same_number_of_results_as(solr_resp_doc_ids_only(author_search_args('"' + @qterms + '"')))
      end
    end
  end # author

  context 'author + title' do
    context 'author title: history man by malcolm bradbury', jira: 'SW-805' do
      it 'author' do
        resp = solr_resp_doc_ids_only({ 'q' => "#{author_query('malcolm bradbury')}" }.merge(solr_args))
        expect(resp.size).to be >= 40
        expect(resp.size).to be <= 60
        expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only(author_search_args('malcolm bradbury')))
      end
      it 'title' do
        resp = solr_resp_doc_ids_only({ 'q' => "#{title_query('the history man')}" }.merge(solr_args))
        expect(resp.size).to be >= 1450
        expect(resp.size).to be <= 1550
      end
      it 'author and title' do
        resp = solr_resp_doc_ids_only({ 'q' => "#{author_query('malcolm bradbury')} AND #{title_query('the history man')}" }.merge(solr_args))
        expect(resp).to include('1433520').as_first
        expect(resp.size).to be <= 3
      end
    end

    context "author Stalin title 'rechi OR sochineniia'", jira: 'VUF-1381' do
      before(:all) do
        @author_resp = solr_resp_doc_ids_only({ 'q' => "#{author_query('stalin')}" }.merge(solr_args))
      end
      it 'author' do
        expect(@author_resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only({ 'q' => "#{author_query('stalin')}" }.merge(solr_args)))
        expect(@author_resp.size).to be >= 600
        expect(@author_resp.size).to be <= 700
        expect(@author_resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only(author_search_args('stalin')))
      end
      it 'title rechi OR sochineniia' do
        resp = solr_resp_doc_ids_only({ 'q' => "#{title_query_or('rechi OR sochineniia')}" }.merge(solr_args))
        expect(resp.size).to be >= 2200
        expect(resp.size).to be <= 2400
      end
      it 'author + title rechi' do
        resp = solr_resp_doc_ids_only({ 'q' => "#{author_query('stalin')} AND #{title_query('rechi')}" }.merge(solr_args))
        expect(resp).to have_fewer_results_than @author_resp
        expect(resp.size).to be >= 12
        expect(resp.size).to be <= 20
      end
      it 'author + title sochineniia' do
        resp = solr_resp_doc_ids_only({ 'q' => "#{author_query('stalin')} AND #{title_query('sochineniia')}" }.merge(solr_args))
        expect(resp).to have_fewer_results_than @author_resp
        expect(resp.size).to be >= 5
        expect(resp.size).to be <= 12
      end
      it 'author and title both terms optional' do
        resp = solr_resp_doc_ids_only({ 'q' => "#{author_query('stalin')} AND #{title_query_or('rechi OR sochineniia')}" }.merge(solr_args))
        expect(resp).to have_fewer_results_than @author_resp
        expect(resp.size).to be >= 20
        expect(resp.size).to be <= 30
      end
    end

    context 'author mcrae, title jazz', jira: 'SW-168' do
      it 'author barry mcrae title jazz' do
        resp = solr_resp_doc_ids_only({ 'q' => "#{author_query('mcrae barry')} AND #{title_query('jazz')}" }.merge(solr_args))
        expect(resp).to have_fewer_results_than(solr_resp_ids_from_query 'barry mcrae jazz')
        expect(resp).to include(%w(2130330 336046)).in_first(2)
        expect(resp.size).to be <= 10
      end
      it 'author mcrae title jazz' do
        resp = solr_resp_doc_ids_only({ 'q' => "#{author_query('mcrae')} AND #{title_query('jazz')}" }.merge(solr_args))
        expect(resp).to have_fewer_results_than(solr_resp_ids_from_query 'mcrae jazz')
        expect(resp).to include(%w(2130330 336046 7637875 6634054))
        expect(resp.size).to be <= 50
      end
    end
  end # author + title

  context 'author + keyword' do
    context 'author campana, keywords storia e letteratura', jira: 'VUF-2468' do
      before(:all) do
        @author_resp = solr_resp_doc_ids_only({ 'q' => "#{author_query('campana')}" }.merge(solr_args))
      end
      it 'author' do
        expect(@author_resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only({ 'q' => "#{author_query('campana')}" }.merge(solr_args)))
        expect(@author_resp.size).to be >= 200
        expect(@author_resp.size).to be <= 275
        expect(@author_resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only(author_search_args('campana')))
      end
      it 'keyword' do
        resp = solr_resp_doc_ids_only({ 'q' => 'storia e letteratura' }.merge(solr_args))
        expect(resp).to have_the_same_number_of_results_as(solr_resp_ids_from_query('storia e letteratura'))
        expect(resp.size).to be >= 2050
        expect(resp.size).to be <= 2300
      end
      it 'author and keyword' do
        resp = solr_resp_doc_ids_only({ 'q' => "#{author_query('campana')} AND storia e letteratura" }.merge(solr_args))
        expect(resp).to have_fewer_results_than(@author_resp)
        expect(resp.size).to be <= 10
      end
    end
  end # author + keyword

  context 'nested NOT in subject', jira: 'VUF-1387' do
    it 'digestive organs' do
      resp = solr_resp_doc_ids_only({ 'q' => "#{subject_query('digestive organs')}" }.merge(solr_args))
      expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only(subject_search_args 'digestive organs'))
      expect(resp.size).to be >= 450
      expect(resp.size).to be <= 650
    end
    it 'digestive organs NOT disease' do
      resp = solr_resp_doc_ids_only({ 'q' => "#{subject_query('digestive organs')} AND NOT #{subject_query('disease')}" }.merge(solr_args))
      # the following is busted due to Solr edismax bug that sets mm=1 if it encounters a NOT
      # https://issues.apache.org/jira/browse/SOLR-2649
      # resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(subject_search_args 'digestive organs NOT disease'))
      expect(resp.size).to be >= 200
      expect(resp.size).to be <= 400
    end
    it 'digestive organs NOT disease NOT cancer' do
      resp = solr_resp_doc_ids_only({ 'q' => "#{subject_query('digestive organs')} AND NOT #{subject_query('disease')} AND NOT #{subject_query('cancer')}" }.merge(solr_args))
      # the following is busted due to Solr edismax bug that sets mm=1 if it encounters a NOT
      # https://issues.apache.org/jira/browse/SOLR-2649
      # resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(subject_search_args 'digestive organs NOT disease NOT cancer'))
      expect(resp.size).to be >= 200
      expect(resp.size).to be <= 300
    end
    it 'with parens' do
      resp = solr_resp_doc_ids_only({ 'q' => "#{subject_query('digestive organs')} AND NOT #{subject_query('(disease OR cancer)')}" }.merge(solr_args))
      # the following is busted due to Solr edismax bug that sets mm=1 if it encounters a NOT
      # https://issues.apache.org/jira/browse/SOLR-2649
      # resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(subject_search_args 'digestive organs NOT (disease OR cancer)'))
      expect(resp.size).to be >= 200
      expect(resp.size).to be <= 300
    end
  end

  # summary/ToC is no more - see INDEX-111;  this is left here for historical purposes
  context 'summary/ToC', pending: 'fixme' do
    it 'robert morris', jira: 'VUF-912' do
      resp = solr_resp_doc_ids_only({ 'q' => "#{summary_query('Robert Morris')}" }.merge(solr_args))
      expect(resp).to include('2834765')
      expect(resp.size).to be <= 675
    end
  end

  context 'pub info' do
    it 'publisher and place and year', jira: 'SW-202' do
      resp = solr_resp_doc_ids_only({ 'q' => "#{pub_info_query('Instress, Saratoga, 1999')}" }.merge(solr_args))
      expect(resp).to include(%w(4123450 4282796 4314776 4297734 4233634))
      expect(resp.size).to be <= 10
    end

    context "subject 'soviet union and historiography' and pub info '1910-1911", jira: 'VUF-1781' do
      it 'subject' do
        resp = solr_resp_doc_ids_only({ 'q' => "#{subject_query('soviet union and historiography')}" }.merge(solr_args))
        expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only(subject_search_args 'soviet union and historiography'))
        expect(resp.size).to be >= 200
        expect(resp.size).to be <= 250
      end
      it "subject without 'and'" do
        resp = solr_resp_doc_ids_only({ 'q' => "#{subject_query('soviet union historiography')}" }.merge(solr_args))
        expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only(subject_search_args 'soviet union historiography'))
        expect(resp.size).to be >= 950
        expect(resp.size).to be <= 1050
      end
      it 'pub info 2010' do
        resp = solr_resp_doc_ids_only({ 'q' => "#{pub_info_query('2010')}" }.merge(solr_args))
        expect(resp.size).to be >= 165_000
        expect(resp.size).to be <= 175_000
      end
      it 'pub info 2011' do
        resp = solr_resp_doc_ids_only({ 'q' => "#{pub_info_query('2011')}" }.merge(solr_args))
        expect(resp.size).to be >= 140_000
        expect(resp.size).to be <= 200_000
      end
      it 'subject and pub info 2010' do
        resp = solr_resp_doc_ids_only({ 'q' => "#{subject_query('soviet union and historiography')} AND #{pub_info_query('2010')}" }.merge(solr_args))
        expect(resp.size).to be >= 8
        expect(resp.size).to be <= 15
      end
      it 'subject and pub info 2011' do
        resp = solr_resp_doc_ids_only({ 'q' => "#{subject_query('soviet union and historiography')} AND #{pub_info_query('2011')}" }.merge(solr_args))
        expect(resp.size).to be >= 15
        expect(resp.size).to be <= 25
      end
      it "subject without 'and' and pub info 2010" do
        resp = solr_resp_doc_ids_only({ 'q' => "#{subject_query('soviet union historiography')} AND #{pub_info_query('2010')}" }.merge(solr_args))
        expect(resp.size).to be >= 15
        expect(resp.size).to be <= 25
      end
      it "subject without 'and' and pub info 2011" do
        resp = solr_resp_doc_ids_only({ 'q' => "#{subject_query('soviet union historiography')} AND #{pub_info_query('2011')}" }.merge(solr_args))
        expect(resp.size).to be >= 25
        expect(resp.size).to be <= 40
      end
      context 'search range of years in pub_info', pending: 'fixme' do
        it 'pub info 2010-2011' do
          resp = solr_resp_doc_ids_only({ 'q' => "#{pub_info_query('2010-2011')}" }.merge(solr_args))
          expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only({ 'q' => "#{pub_info_query('2010 2011')}" }.merge(solr_args)))
          expect(resp.size).to be >= 2
          expect(resp.size).to be <= 10
        end
        it 'subject and pub info' do
          resp = solr_resp_doc_ids_only({ 'q' => "#{subject_query('soviet union and historiography')} AND #{pub_info_query('2010-2011')}" }.merge(solr_args))
          expect(resp.size).to be >= 25
          expect(resp.size).to be <= 35
        end
        it "subject without 'and' and pub info" do
          resp = solr_resp_doc_ids_only({ 'q' => "#{subject_query('soviet union historiography')} AND #{pub_info_query('2010-2011')}" }.merge(solr_args))
          expect(resp.size).to be >= 35
          expect(resp.size).to be <= 60
        end
      end
    end # subject + pub info
  end # pub info

  context 'number search' do
    it 'should allow barcode searches', jira: 'SW-682' do
      resp = solr_resp_doc_ids_only({ 'q' => "#{number_query('36105041286266')}" }.merge(solr_args))
      expect(resp).to include('2029735').as_first
      expect(resp.size).to be <= 3
    end
  end

  context 'facets' do
    context 'format video, location green, language english', jira: 'VUF-2460' do
      before(:all) do
      end
      it 'before topics selected' do
        resp = solr_resp_doc_ids_only({ 'fq' => 'format:("Video"), language:("English"), building_facet:("Green")', 'q' => 'collection:*' }.merge(solr_args))
        expect(resp.size).to be >= 150
        expect(resp.size).to be <= 450
      end
      it 'add topic feature films' do
        resp = solr_resp_doc_ids_only({ 'fq' => 'format:("Video"), language:("English"), building_facet:("Green"), topic_facet:("Feature films")', 'q' => 'collection:*' }.merge(solr_args))
        expect(resp.size).to be >= 15
        expect(resp.size).to be <= 50
      end
      it 'add genre feature films' do
        resp = solr_resp_doc_ids_only({ 'fq' => 'format:("Video"), language:("English"), building_facet:("Green"), genre_ssim:("Feature films")', 'q' => 'collection:*' }.merge(solr_args))
        expect(resp.size).to be >= 5
        expect(resp.size).to be <= 15
      end
    end
    context 'format video, location Media Microtext, language english' do
      before(:all) do
      end
      it 'before topics selected' do
        resp = solr_resp_doc_ids_only({ 'fq' => 'format:("Video"), language:("English"), building_facet:("Media & Microtext Center")', 'q' => 'collection:*' }.merge(solr_args))
        expect(resp.size).to be >= 35_000
        expect(resp.size).to be <= 45_000
      end
      it 'add topic feature films' do
        resp = solr_resp_doc_ids_only({ 'fq' => 'format:("Video"), language:("English"), building_facet:("Media & Microtext Center"), topic_facet:("Feature films")', 'q' => 'collection:*' }.merge(solr_args))
        expect(resp.size).to be >= 9_300
        expect(resp.size).to be <= 10_500
      end
      it 'add topic science fiction' do
        resp = solr_resp_doc_ids_only({ 'fq' => 'format:("Video"), language:("English"), building_facet:("Media & Microtext Center"), topic_facet:("Feature films"), topic_facet:("Science fiction films")', 'q' => 'collection:*' }.merge(solr_args))
        expect(resp.size).to be >= 200
        expect(resp.size).to be <= 300
      end
      it 'use genre feature films' do
        resp = solr_resp_doc_ids_only({ 'fq' => 'format:("Video"), language:("English"), building_facet:("Media & Microtext Center"), genre_ssim:("Feature films")', 'q' => 'collection:*' }.merge(solr_args))
        expect(resp.size).to be >= 12_100
        expect(resp.size).to be <= 14_100
      end
      it 'add genre science fiction' do
        resp = solr_resp_doc_ids_only({ 'fq' => 'format:("Video"), language:("English"), building_facet:("Media & Microtext Center"), genre_ssim:("Feature films"), genre_ssim:("Science fiction films")', 'q' => 'collection:*' }.merge(solr_args))
        expect(resp.size).to be >= 400
        expect(resp.size).to be <= 500
      end
    end
  end

  def title_query(terms)
    "_query_:\"{!edismax qf=$qf_title pf=$pf_title pf3=$pf3_title pf2=$pf2_title}#{terms}\""
  end

  # Blacklight Advanced Search uses a modified query for OR queries
  def title_query_or(terms)
    "_query_:\"{!dismax qf=$qf_title pf=$pf_title pf3=$pf3_title pf2=$pf2_title mm=1}#{terms}\""
  end

  def author_query(terms)
    '_query_:"{!edismax qf=$qf_author pf=$pf_author pf3=$pf3_author pf2=$pf2_author}' + terms + '"'
  end

  def subject_query(terms)
    '_query_:"{!edismax qf=$qf_subject pf=$pf_subject pf3=$pf3_subject pf2=$pf2_subject}' + terms + '"'
  end

  def pub_info_query(terms)
    '_query_:"{!edismax qf=$qf_pub_info pf=$pf_pub_info pf3=$pf3_pub_info pf2=$pf2_pub_info}' + terms + '"'
  end

  def number_query(terms)
    '_query_:"{!edismax qf=$qf_number pf=$pf_number pf3=$pf3_number pf2=$pf2_number}' + terms + '"'
  end

  def solr_args
    { 'defType' => 'lucene' }.merge(doc_ids_only)
  end
end
