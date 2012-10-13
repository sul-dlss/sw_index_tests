require 'spec_helper'
require 'rspec-solr'

describe "Stemming of English words" do
  context "exact matches before stemmed matches" do
    
    it "cooking" do
      resp = solr_resp_doc_ids_only({'q'=>'cooking'})
      resp.should include("4779910").as_first_result
      pending "need regex match in rspec-solr"
#      And I should get result titles that contain "cooking" as the first 18 results
    end
    
    it "modeling" do
      resp = solr_resp_doc_ids_only({'q'=>'modeling'})
      pending "need regex match in rspec-solr"
#      And I should get result titles that contain "modeling" as the first 20 results
    end
    
    it "modeling" do
      resp = solr_resp_doc_ids_only({'q'=>'photographing'})
      # example of a two word title, starting with query term
      resp.should include("685794").in_first(10).results
      pending "need regex match in rspec-solr"
#      And I should get result titles that contain "photographing" as the first 20 results
    end
    
    it "arabic" do
      resp = solr_resp_doc_ids_only({'q'=>'arabic'})
      pending "need regex match in rspec-solr"
#      And I should get result titles that contain "arabic" as the first 20 results
    end
    
    it "'searching'" do
      resp = solr_resp_doc_ids_only({'q'=>'searching'})
      resp.should_not include("4216963")
      resp.should_not include("4216961")
      pending "need regex match in rspec-solr"
#      And I should get result titles that contain "searching" as the first 20 results
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

  end # context exact before stemmed

end