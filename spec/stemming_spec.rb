describe "Stemming of English words" do
  context "exact matches before stemmed matches" do

    it "cooking", :jira => 'VUF-212' do
      resp = solr_response({'q'=>'cooking', 'fl'=>'id,title_245a_display', 'facet'=>false})
      expect(resp).to include("4779910").as_first_result
      expect(resp).to include("title_245a_display" => /Cooking/i).in_each_of_first(20).documents
    end

    it "modeling", :jira => 'VUF-212' do
      resp = solr_response({'q'=>'modeling', 'fl'=>'id,title_245a_display', 'facet'=>false})
      expect(resp).to include("title_245a_display" => /modeling/i).in_each_of_first(20).documents
    end

    it "photographing", :jira => 'VUF-212' do
      resp = solr_response({'q'=>'photographing', 'fl'=>'id,title_245a_display', 'facet'=>false})
      expect(resp).to include("title_245a_display" => /photographing/i).in_each_of_first(20).documents
      # example of a two word title, starting with query term
      expect(resp).to include("685794").in_first(10).results
    end

    it "arabic (rather than arab or arabs)", :jira => 'VUF-212' do
      resp = solr_response({'q'=>'arabic', 'fl'=>'id,title_245a_display', 'facet'=>false})
      expect(resp).to include("title_245a_display" => /arabic/i).in_each_of_first(20).documents
    end

    it "'searching'", :jira => ['VUF-212', 'SW-64'] do
      resp = solr_response({'q'=>'searching', 'fl'=>'id,title_245a_display', 'facet'=>false})
      expect(resp).to include("title_245a_display" => /searching/i).in_each_of_first(20).documents
      expect(resp).not_to include("4216963") # has 'search' in 245a and 880
      expect(resp).not_to include("4216961") # has 'search' in 245a and 880
    end

    it "Austen also gives Austenland, Austen's" do
      resp = solr_resp_doc_ids_only({'q'=>'Austen', 'sort'=>'title_sort asc, pub_date_sort desc', 'rows'=>200})
      # 3393754  "Austen"
      # 6865948  "Austenland"
      # 5847283  "Austen's"
      expect(resp).to include("3393754").before("6865948")
      expect(resp).to include("6865948").before("5847283")
    end

    it "tattoo, tattoos, tattooed" do
      resp = solr_resp_doc_ids_only({'q'=>'tattoo'})
      expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'tattoos'}))
      expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'tattooed'}))
    end

    it "latin ae should stem to a" do
      resp = solr_resp_doc_ids_only({'q'=>'musicae disciplinae'})
      expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'musica disciplina'}))
    end

    it "stemming of 'figurine' should match 'figure'", pending: 'fixme', :jira => 'VUF-598' do
      expect(solr_resp_doc_ids_only(title_search_args 'byzantine figurine')).to include('7096823')
      expect(solr_resp_doc_ids_only(title_search_args 'byzantine figure')).to include('7096823')

      resp = solr_resp_doc_ids_only({'q'=>'figurine'})
      expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'figure'}))
    end

    it "stemming of 'figural' matches 'figure'", :jira => 'VUF-598' do
      resp = solr_resp_doc_ids_only(title_search_args 'byzantine figure')
      expect(resp).to include("3013697")  # title_245a_display => "Byzantine figural processional crosses"
      expect(resp).to include("7769264") # 7769264: title has only byzantine; 505t has "figural"
    end

    # TODO:  see VUF-1657   Plutarch's Morals should also lead to records on Plutarch's "Moralia."
    # TODO:  see VUF-1765   eugenics vs eugene
    # TODO:  see VUF-1451   musicals vs music
    #
    # FIXME: stemming cyrillic?  VUF-489
    #  Пушкинa is not stemmed.  Пушкинa does not give the same results as a search for Пушкин.

    context "volney ruines", :jira => 'VUF-2009' do
      # user wanted french results without having to select french in lang facet
      it "les ruines volney" do
        resp = solr_resp_ids_titles_from_query('volney ruines')
        expect(resp).to include('title_245a_display' => /les ruines/i)
      end
      it "volney ruines" do
        resp = solr_resp_ids_titles_from_query('les ruines volney')
        expect(resp).to include('title_245a_display' => /les ruines/i).in_each_of_first(3)
      end
    end

    it "stemming of periodization", :jira => 'VUF-1765', pending: 'fixme' do
      resp = solr_resp_doc_ids_only(subject_search_args '"Arts periodization"')
      expect(resp).not_to include('1699858')
      expect(resp).not_to have_the_same_number_of_results_as(solr_resp_doc_ids_only(subject_search_args '"Arts periodicals"'))
      expect(resp.size).to be <= 150
    end

  end # context exact before stemmed

  # note Porter2 changes from Porter, as of 2013-07   http://snowball.tartarus.org/algorithms/english/stemmer.html

  context "ly suffix" do
    # eedly
    # edly
    # ingly
    it "lonely should stem to same as lone" do
      resp = solr_resp_ids_titles(title_search_args('lonely trail'))
      expect(resp).to include('title_245a_display' => /lone /i)
      expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only(title_search_args 'lone trail'))
    end
    it "silently should stem to same as silent" do
      resp = solr_resp_ids_titles(title_search_args 'silently')
      expect(resp).to include('title_245a_display' => /silent /i)
      expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only(title_search_args 'silent'))
    end
    it "knightly should stem to same as knight" do
      resp = solr_resp_ids_full_titles(title_search_args('knightly').merge({:rows => '30'}))
      expect(resp).to include('title_full_display' => /knights? /i)
      expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only(title_search_args 'knight'))
    end
    it "deeply should stem to same as deep" do
      resp = solr_resp_ids_full_titles(title_search_args('deeply').merge({:rows => '500'}))
      expect(resp).to include('title_full_display' => /deep /i)
      # not sure why this isn't true
      # resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(title_search_args 'deep'))
    end
  end

  context "terminating y" do
    it "stayed should stem to same as stay" do
      resp = solr_resp_ids_titles(title_search_args 'stayed up')
      expect(resp).to include('title_245a_display' => /stays? up/i)
      expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only(title_search_args 'stay up'))
    end
    it "stay should not stem to stai" do
      resp = solr_resp_ids_titles(title_search_args('stay').merge({:rows => '200'}))
      expect(resp).to include('title_245a_display' => /stay/i).in_each_of_first(200).results
      expect(resp).not_to include('title_245a_display' => /stai/i)
      stai = solr_resp_ids_titles(title_search_args 'stai')
      expect(stai.size).to be <= 50
      expect(stai).not_to include('title_245a_display' => /stay/i)
      expect(resp).to have_more_results_than stai
    end
    it "play should not stem to plai" do
      resp = solr_resp_ids_full_titles(title_search_args('play').merge({:rows => '200'}))
      expect(resp).to include('title_full_display' => /play/i).in_each_of_first(200).results
      expect(resp).not_to include('title_full_display' => /plai/i)
      plai = solr_resp_ids_titles(title_search_args 'plai')
      expect(plai.size).to be <= 100
      expect(plai).not_to include('title_245a_display' => /play/i)
      expect(resp).to have_more_results_than plai
    end
    it "destroy should not stem to destroi" do
      resp = solr_resp_ids_full_titles(title_search_args('destroy').merge({:rows => '200'}))
      expect(resp).to include('title_full_display' => /destroy/i).in_each_of_first(200).results
      expect(resp).not_to include('title_full_display' => /destroi/i)
      destroi = solr_resp_ids_titles(title_search_args 'destroi')
      expect(destroi.size).to be <= 15
      expect(destroi).not_to include('title_245a_display' => /destroy/i)
      expect(resp).to have_more_results_than destroi
    end
    it "wary should not stem to wari", :jira => 'VUF-633', pending: 'fixme' do
      resp = solr_resp_doc_ids_only(title_search_args 'wary')
      expect(resp).not_to include(['9855173', '3751655', '4532829']) # 245a  Wari
      expect(resp).not_to have_the_same_number_of_results_as solr_resp_doc_ids_only(title_search_args 'wari')
    end
    it "cries and cry should stem to cri, not crie" do
      cries = solr_resp_doc_ids_only(title_search_args 'cries')
      cry = solr_resp_doc_ids_only(title_search_args 'cry')
      cri = solr_resp_doc_ids_only(title_search_args 'cri')
      crie = solr_resp_doc_ids_only(title_search_args 'crie')
      expect(cries).to have_the_same_number_of_results_as cry
      expect(cries).to have_the_same_number_of_results_as cri
      expect(cries).not_to have_the_same_number_of_results_as crie
    end
    it "ties and tie should stem to tie, not ti" do
      ties = solr_resp_doc_ids_only(title_search_args 'ties')
      tie = solr_resp_doc_ids_only(title_search_args 'tie')
      ti = solr_resp_doc_ids_only(title_search_args 'ti')
      expect(ties).to have_the_same_number_of_results_as tie
      expect(ties).not_to have_the_same_number_of_results_as ti
    end
  end

  context "us suffix keeps its s", pending: 'fixme' do
    # populus
    # focus
    # modus
    # modulus
    # locus
    it "alumnus" do
      skip "to be implemented"
    end
  end

  context "ative suffix", pending: 'fixme' do
    # nominative?
    # generative?
    # "is removed only when in region R2"
  end

  context "collisions" do
    # Also:
    # populate <--> population but not populus
    # compute = computes = computer = computing  computation = computational
    # territory = territorial = territories
    # addition = additional = additive
    # terra = terrae (but not territory)
    # fantastic = fantastical but not fantasy
    # authority author
    # wander wand

    context "animal <--> animate, animation, animism" do
      it "animal should not match animation" do
        resp = solr_resp_ids_titles(title_search_args 'animal')
        expect(resp).not_to include('title_245a_display' => /animation/i)
      end
      it "animation should not match animal" do
        resp = solr_resp_ids_titles(title_search_args 'animation')
        expect(resp).not_to include('title_245a_display' => /animal/i)
      end
      it "animal should not match animism" do
        resp = solr_resp_ids_titles(title_search_args 'animal')
        expect(resp).not_to include('title_245a_display' => /animism/i)
      end
      it "animism should not match animal" do
        resp = solr_resp_ids_titles(title_search_args 'animism')
        expect(resp).not_to include('title_245a_display' => /animal/i)
      end
    end

    context "ironic <--> iron" do
      it "ironic should not match iron", pending: 'fixme' do
        resp = solr_resp_ids_titles(title_search_args('ironic').merge({:rows => '100'}))
        expect(resp).not_to include('title_245a_display' => /iron /i)
      end
      it "iron should not match ironic" do
        # too many titles with iron for this to be a good test
        resp = solr_resp_ids_titles(title_search_args('iron').merge({:rows => '500'}))
        expect(resp).not_to include('title_245a_display' => /ironic/i)
      end
    end

    context "conversion <-> converse <-> conversation" do
      it "conversion should not match converse" do
        # too many titles with conversion for this to be a good test
        resp = solr_resp_ids_titles(title_search_args('conversion').merge({:rows => '500'}))
        expect(resp).not_to include('title_245a_display' => /converse/i)
      end
      it "conversion should not match conversation" do
        resp = solr_resp_ids_titles(title_search_args 'conversion')
        expect(resp).not_to include('title_245a_display' => /conversation/i)
      end
      it "converse should not match conversion", pending: 'fixme' do
        resp = solr_resp_ids_titles(title_search_args('converse').merge({:rows => '30'}))
        expect(resp).not_to include('title_245a_display' => /conversion/i)
      end
      it "converse should not match conversation", pending: 'fixme' do
        resp = solr_resp_ids_titles(title_search_args('converse').merge({:rows => '30'}))
        expect(resp).not_to include('title_245a_display' => /conversation/i)
      end
      it "conversation should not match conversion" do
        resp = solr_resp_ids_titles(title_search_args('conversation').merge({:rows => '100'}))
        expect(resp).not_to include('title_245a_display' => /conversion/i)
      end
      it "conversation should not match converse" do
        # not enough title with converse for this to be a good test
        resp = solr_resp_ids_titles(title_search_args('conversation').merge({:rows => '500'}))
        expect(resp).not_to include('title_245a_display' => /converse/i)
      end
    end
  end # collisions

  context "irregular plurals", pending: 'fixme' do
    context "woman <--> women", pending: 'fixme' do
      it "woman should match women" do
        resp = solr_resp_ids_titles(title_search_args('woman').merge({:rows => '100'}))
        expect(resp).to include('title_245a_display' => /women/i)
      end
      it "women should match woman" do
        resp = solr_resp_ids_titles(title_search_args('women').merge({:rows => '100'}))
        expect(resp).to include('title_245a_display' => /woman/i)
      end
    end
  end

end
