require 'spec_helper'

describe "Stemming of English words" do
  context "exact matches before stemmed matches" do
    
    it "cooking", :jira => 'VUF-212' do
      resp = solr_response({'q'=>'cooking', 'fl'=>'id,title_245a_display', 'facet'=>false}) 
      resp.should include("4779910").as_first_result
      resp.should include("title_245a_display" => /Cooking/i).in_each_of_first(20).documents
    end
    
    it "modeling", :jira => 'VUF-212' do
      resp = solr_response({'q'=>'modeling', 'fl'=>'id,title_245a_display', 'facet'=>false}) 
      resp.should include("title_245a_display" => /modeling/i).in_each_of_first(20).documents
    end
    
    it "photographing", :jira => 'VUF-212' do
      resp = solr_response({'q'=>'photographing', 'fl'=>'id,title_245a_display', 'facet'=>false}) 
      resp.should include("title_245a_display" => /photographing/i).in_each_of_first(20).documents
      # example of a two word title, starting with query term
      resp.should include("685794").in_first(10).results
    end
    
    it "arabic (rather than arab or arabs)", :jira => 'VUF-212' do
      resp = solr_response({'q'=>'arabic', 'fl'=>'id,title_245a_display', 'facet'=>false}) 
      resp.should include("title_245a_display" => /arabic/i).in_each_of_first(20).documents
    end
    
    it "'searching'", :jira => ['VUF-212', 'SW-64'] do
      resp = solr_response({'q'=>'searching', 'fl'=>'id,title_245a_display', 'facet'=>false}) 
      resp.should include("title_245a_display" => /searching/i).in_each_of_first(20).documents
      resp.should_not include("4216963") # has 'search' in 245a and 880
      resp.should_not include("4216961") # has 'search' in 245a and 880
    end
    
    it "Austen also gives Austenland, Austen's" do
      resp = solr_resp_doc_ids_only({'q'=>'Austen', 'sort'=>'title_sort asc, pub_date_sort desc', 'rows'=>100})
      # 3393754  "Austen"
      # 6865948  "Austenland"
      # 5847283  "Austen's"
      resp.should include("3393754").before("6865948") 
      resp.should include("6865948").before("5847283")
    end

    it "tattoo, tattoos, tattooed" do
      resp = solr_resp_doc_ids_only({'q'=>'tattoo'})
      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'tattoos'}))
      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'tattooed'}))
    end
    
    it "latin ae should stem to a" do
      resp = solr_resp_doc_ids_only({'q'=>'musicae disciplinae'})
      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'musica disciplina'}))
    end

    it "stemming of 'figurine' should match 'figure'", :fixme => 'true', :jira => 'VUF-598' do
      solr_resp_doc_ids_only(title_search_args 'byzantine figurine').should include('7096823')
      solr_resp_doc_ids_only(title_search_args 'byzantine figure').should include('7096823')

      resp = solr_resp_doc_ids_only({'q'=>'figurine'})
      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'figure'}))
    end
    
    it "stemming of 'figural' matches 'figure'", :jira => 'VUF-598' do
      resp = solr_resp_doc_ids_only(title_search_args 'byzantine figure')
      resp.should include("3013697")  # title_245a_display => "Byzantine figural processional crosses"      
      resp.should include("7769264") # 7769264: title has only byzantine; 505t has "figural"
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
        resp.should include('title_245a_display' => /les ruines/i)
      end
      it "volney ruines" do
        resp = solr_resp_ids_titles_from_query('les ruines volney')
        resp.should include('title_245a_display' => /les ruines/i).in_each_of_first(3)
      end
    end

    it "stemming of periodization", :jira => 'VUF-1765', :fixme => true do
      resp = solr_resp_doc_ids_only(subject_search_args '"Arts periodization"')
      resp.should_not include('1699858')
      resp.should_not have_the_same_number_of_results_as(solr_resp_doc_ids_only(subject_search_args '"Arts periodicals"'))
      resp.should have_at_most(150).results
    end
    
  end # context exact before stemmed
  
  context "ly suffix" do
    it "lonely should stem to lone" do
      resp = solr_resp_ids_titles(title_search_args('lonely trail'))
      resp.should include('title_245a_display' => /lone /i)
    end
    it "silently should stem to silent" do
      resp = solr_resp_ids_titles(title_search_args 'silently')
      resp.should include('title_245a_display' => /silent /i)
    end
    it "knightly should stem to knight" do
      resp = solr_resp_ids_titles(title_search_args('knightly').merge({:rows => '30'}))
      resp.should include('title_245a_display' => /knights? /i)
    end
  end
  
  context "terminating y" do
    it "wary", :jira => 'VUF-633' do
      pending "to be implemented"
    end
    it "stay, stayed" do
      pending "to be implemented"
    end
  end
  
  context "us suffix" do
    it "alumnus" do
      pending "to be implemented"
    end
  end
  
  context "collisions", :fixme => true do
    context "animal <--> animate, animation, animism", :fixme => true do
      it "animal should not match animation" do
        resp = solr_resp_ids_titles(title_search_args 'animal')
        resp.should_not include('title_245a_display' => /animation/i)
      end
      it "animation should not match animal" do
        resp = solr_resp_ids_titles(title_search_args 'animation')
        resp.should_not include('title_245a_display' => /animal/i)
      end
      it "animal should not match animism" do
        resp = solr_resp_ids_titles(title_search_args 'animal')
        resp.should_not include('title_245a_display' => /animism/i)
      end
      it "animism should not match animal" do
        resp = solr_resp_ids_titles(title_search_args 'animism')
        resp.should_not include('title_245a_display' => /animal/i)
      end
    end
    context "ironic <--> iron", :fixme => true do
      it "ironic should not match iron" do
        resp = solr_resp_ids_titles(title_search_args('ironic').merge({:rows => '100'}))
        resp.should_not include('title_245a_display' => /iron /i)
      end
      it "iron should not match ironic", :fixme => true do
        # too many titles with iron for this to be a good test
        resp = solr_resp_ids_titles(title_search_args('iron').merge({:rows => '500'}))
        resp.should_not include('title_245a_display' => /ironic/i)
      end
    end
    context "conversion <-> converse <-> conversation" do
      it "conversion should not match converse", :fixme => true do
        # too many titles with conversion for this to be a good test
        resp = solr_resp_ids_titles(title_search_args('conversion').merge({:rows => '500'}))
        resp.should_not include('title_245a_display' => /converse/i)
      end
      it "conversion should not match conversation" do
        resp = solr_resp_ids_titles(title_search_args 'conversion')
        resp.should_not include('title_245a_display' => /conversation/i)
      end
      it "converse should not match conversion" do
        resp = solr_resp_ids_titles(title_search_args('converse').merge({:rows => '30'}))
        resp.should_not include('title_245a_display' => /conversion/i)
      end
      it "converse should not match conversation" do
        resp = solr_resp_ids_titles(title_search_args('converse').merge({:rows => '30'}))
        resp.should_not include('title_245a_display' => /conversation/i)
      end
      it "conversation should not match conversion" do
        resp = solr_resp_ids_titles(title_search_args('conversation').merge({:rows => '100'}))
        resp.should_not include('title_245a_display' => /conversion/i)
      end
      it "conversation should not match converse", :fixme => true do
        # not enough title with converse for this to be a good test
        resp = solr_resp_ids_titles(title_search_args('conversation').merge({:rows => '500'}))
        resp.should_not include('title_245a_display' => /converse/i)
      end
    end
  end # collisions
  
  context "irregular plurals", :fixme => true do
    context "woman <--> women", :fixme => true do
      it "woman should match women" do
        resp = solr_resp_ids_titles(title_search_args('woman').merge({:rows => '100'}))
        resp.should include('title_245a_display' => /women/i)
      end
      it "women should match woman" do
        resp = solr_resp_ids_titles(title_search_args('women').merge({:rows => '100'}))
        resp.should include('title_245a_display' => /woman/i)
      end
    end
  end

end