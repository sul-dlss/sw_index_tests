require 'spec_helper'

describe "colons in queries should be ignored ('a : b', 'a: b', and 'a b' are all the same)" do
  #  note that a space before, but not after a colon is highly unlikely
  
  it "surrounded by spaces inside phrase should be ignored" do
    resp = solr_resp_doc_ids_only({'q'=>'"Alice in Wonderland : a serie[s]"'})
    resp.should have_at_least(2).documents
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'"Alice in Wonderland a serie[s]"'}))
  end
  
  context "2 terms with colon  jazz : photographs" do
    shared_examples_for "great results for jazz photographs" do
      it "should have best matches for 'jazz photographs' at top" do
        resp.should include('2955977').as_first
        resp.should include('3471540').in_first(3)
      end
    end
    context "anywhere" do
      let! (:resp) { solr_resp_ids_from_query 'Jazz : photographs' }
      it_behaves_like "great results for jazz photographs"
      it 'should not care about colon placement' do
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('Jazz photographs'))
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('Jazz: photographs'))
      end
    end
    context "phrase search anywhere" do
      let (:resp) { solr_resp_ids_from_query('"Jazz : photographs"') }
      it_behaves_like "great results for jazz photographs"
      it 'should not care about colon placement' do
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('"Jazz photographs"'))
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('"Jazz: photographs"'))
      end
    end
    context "title search" do
      let (:resp) { solr_resp_doc_ids_only(title_search_args('Jazz : photographs')) }
      it_behaves_like "great results for jazz photographs"
      it 'should not care about colon placement' do
        resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(title_search_args('Jazz photographs')))
        resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(title_search_args('Jazz: photographs')))
      end
    end
    context "title phrase search" do
      let (:resp) { solr_resp_doc_ids_only(title_search_args('"Jazz : photographs"')) }
      it_behaves_like "great results for jazz photographs"
      it 'should not care about colon placement' do
        resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(title_search_args('"Jazz photographs"')))
        resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(title_search_args('"Jazz: photographs"')))
      end
    end
  end
    
  context "3 terms with colon  Love : short stories" do
    shared_examples_for "great results for love short stories" do
      it "should have best matches for 'love short stories' at top" do
        resp.should include('4313015').in_first(8)
      end
    end
    context "anywhere" do
      let! (:resp) { solr_resp_ids_from_query 'Love : short stories' }
      it_behaves_like "great results for love short stories"
      it 'should not care about colon placement' do
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('Love short stories'))
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('Love: short stories'))
      end
    end
    context "phrase search anywhere" do
      let (:resp) { solr_resp_ids_from_query('"Love : short stories"') }
      it_behaves_like "great results for love short stories"
      it 'should not care about colon placement' do
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('"Love short stories"'))
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('"Love: short stories"'))
      end
    end
    context "title search" do
      let (:resp) { solr_resp_doc_ids_only(title_search_args('Love : short stories')) }
      it_behaves_like "great results for love short stories"
      it 'should not care about colon placement' do
        resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(title_search_args('Love short stories')))
        resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(title_search_args('Love: short stories')))
      end
    end
    context "title phrase search" do
      let (:resp) { solr_resp_doc_ids_only(title_search_args('"Love : short stories"')) }
      it_behaves_like "great results for love short stories"
      it 'should not care about colon placement' do
        resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(title_search_args('"Love short stories"')))
        resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(title_search_args('"Love: short stories"')))
      end
    end
  end

  context "3 terms with colon, one term formerly a stopword  jazz : an introduction" do
    shared_examples_for "great results for jazz an introduction" do
      it "should have best matches for 'jazz an introduction' at top" do
        resp.should include('2130314').in_first(4)
        resp.should include(['3315875', '6794170']).in_first(3)
      end
    end
    context "anywhere" do
      let! (:resp) { solr_resp_ids_from_query 'Jazz : an introduction' }
      it_behaves_like "great results for jazz an introduction"
      it 'should not care about colon placement' do
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('Jazz an introduction'))
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('Jazz: an introduction'))
      end
      it "should get fewer results than jazz introdution" do
        resp.should have_fewer_results_than(solr_resp_ids_from_query('Jazz introduction'))
      end
    end
    context "phrase search anywhere" do
      let (:resp) { solr_resp_ids_from_query('"Jazz : an introduction"') }
      it_behaves_like "great results for jazz an introduction"
      it 'should not care about colon placement' do
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('"Jazz an introduction"'))
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('"Jazz: an introduction"'))
      end
      it "should get fewer results than jazz introdution" do
        resp.should have_fewer_results_than(solr_resp_ids_from_query('"Jazz introduction"'))
      end
    end
    context "title search" do
      let (:resp) { solr_resp_doc_ids_only(title_search_args('Jazz : an introduction')) }
      it_behaves_like "great results for jazz an introduction"
      it 'should not care about colon placement' do
        resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(title_search_args('Jazz an introduction')))
        resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(title_search_args('Jazz: an introduction')))
      end
      it "should get fewer results than jazz introdution" do
        resp.should have_fewer_results_than(solr_resp_doc_ids_only(title_search_args('Jazz introduction')))
      end
    end
    context "title phrase search" do
      let (:resp) { solr_resp_doc_ids_only(title_search_args('"Jazz : an introduction"')) }
      it_behaves_like "great results for jazz an introduction"
      it 'should not care about colon placement' do
        resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(title_search_args('"Jazz an introduction"')))
        resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(title_search_args('"Jazz: an introduction"')))
      end
      it "should get fewer results than jazz introdution" do
        resp.should have_fewer_results_than(solr_resp_doc_ids_only(title_search_args('"Jazz introduction"')))
      end
    end
  end
end