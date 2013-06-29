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

    it "stemming of 'figurine' should match 'figure'", :fixme => 'true' do
      resp = solr_resp_doc_ids_only({'q'=>'figurine'})
      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'figure'}))
    end

    # TODO:  see VUF-2009   Volney ruines
    # TODO:  see VUF-1657   Plutarch's Morals should also lead to records on Plutarch's "Moralia."
    # TODO:  see VUF-1765   eugenics vs eugene


    it "stemming of periodization", :jira => 'VUF-1765', :fixme => true do
      resp = solr_resp_doc_ids_only(subject_search_args '"Arts periodization"')
      resp.should_not include('1699858')
      resp.should_not have_the_same_number_of_results_as(solr_resp_doc_ids_only(subject_search_args '"Arts periodicals"'))
      resp.should have_at_most(150).results
    end
  end # context exact before stemmed

end