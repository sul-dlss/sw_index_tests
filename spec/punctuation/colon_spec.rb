# encoding: UTF-8
require 'spec_helper'

describe "colons in queries should be ignored ('a : b', 'a: b', and 'a b' are all the same)" do
  #  note that a space before, but not after a colon is highly unlikely
  
  it "surrounded by spaces inside phrase should be ignored" do
    resp = solr_resp_ids_from_query '"Alice in Wonderland : a serie[s]"'
    resp.should have_at_least(2).documents
    resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('"Alice in Wonderland a serie[s]"'))
  end
  
  # TODO:  used shared example groups as in ampersand and hyphen specs
  
  context "jazz : photographs (2 terms)" do
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
  end # two terms
    
  context "Love : short stories (3 terms)" do
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
  end # 3 terms 

  context "jazz : an introduction (3 terms, with a former stopword)" do
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
      # these now get the same number:  3
#      it "should get fewer results than 'jazz introdution'" do
#        resp.should have_fewer_results_than(solr_resp_doc_ids_only(title_search_args('"Jazz introduction"')))
#      end
    end
  end # 3 terms, one former stop
  
  
  context "4 terms" do
    shared_examples_for "great results for Dance dance revolution : poems" do
      it "should have best matches for Dance dance revolution : poems" do
        resp.should include('6860510').in_first(3)
      end
    end
    context "Dance dance revolution : poems" do
      let! (:resp) { solr_resp_ids_from_query 'Dance dance revolution : poems' }
      it_behaves_like "great results for Dance dance revolution : poems"
      it 'should not care about colon placement' do
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('Dance dance revolution poems'))
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('Dance dance revolution: poems'))
      end
    end
    context "Dance dance revolution : poems   (phrase)" do
      let (:resp) { solr_resp_ids_from_query('"Dance dance revolution : poems"') }
      it_behaves_like "great results for Dance dance revolution : poems"
      it 'should not care about colon placement' do
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('"Dance dance revolution poems"'))
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('"Dance dance revolution: poems"'))
      end
    end
    
    shared_examples_for "great results for Jazz : America's classical music" do
      it "should have best matches for Jazz : America's classical music" do
        resp.should include('3080095').in_first(3)
      end
    end
    context "title search  Jazz : America's classical music" do
      let (:resp) { solr_resp_doc_ids_only(title_search_args('Jazz : America\'s classical music')) }
      it_behaves_like "great results for Jazz : America's classical music"
      it 'should not care about colon placement' do
        resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(title_search_args('Jazz America\'s classical music')))
        resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(title_search_args('Jazz: America\'s classical music')))
        resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(title_search_args('Jazz: America classical music')))
      end
    end
    context "title phrase search   Jazz : America's classical music" do
      let (:resp) { solr_resp_doc_ids_only(title_search_args('"Jazz : America\'s classical music"')) }
      it_behaves_like "great results for Jazz : America\'s classical music"
      it 'should not care about colon placement' do
        resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(title_search_args('"Jazz America\'s classical music"')))
        resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(title_search_args('"Jazz: America\'s classical music"')))
        resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(title_search_args('"Jazz America classical music"')))
      end
    end
    
    shared_examples_for "great results for Tuna : a love story" do
      it "should have best matches for Tuna : a love story" do
        resp.should include('7698810').in_first(3)
      end
    end
    context "Tuna : a love story" do
      let! (:resp) { solr_resp_ids_from_query 'Tuna : a love story' }
      it_behaves_like "great results for Tuna : a love story"
      it 'should not care about colon placement' do
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('Tuna a love story'))
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('Tuna: a love story'))
      end
    end
    context "Tuna : a love story  (phrase)" do
      let (:resp) { solr_resp_ids_from_query('"Tuna : a love story"') }
      it_behaves_like "great results for Tuna : a love story"
      it 'should not care about colon placement' do
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('"Tuna a love story"'))
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('"Tuna: a love story"'))
      end
    end
  end # 4 terms
  
  context "5 terms" do
    shared_examples_for "great results for Fishes : an introduction to ichthyology" do
      it "should have best matches for Fishes : an introduction to ichthyology" do
        resp.should include(['5503532', '4150267', '3089293', '1307571', '1484390']).in_first(5)
      end
    end
    context "title search  Fishes : an introduction to ichthyology", :jira => 'VUF-1058' do
      let (:resp) { solr_resp_doc_ids_only(title_search_args('Fishes : an introduction to ichthyology')) }
      it_behaves_like "great results for Fishes : an introduction to ichthyology"
      it 'should not care about colon placement' do
        resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(title_search_args('Fishes an introduction to ichthyology')))
        resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(title_search_args('Fishes: an introduction to ichthyology')))
      end
    end
    context "title phrase search  Fishes : an introduction to ichthyology", :jira => 'VUF-1058' do
      let (:resp) { solr_resp_doc_ids_only(title_search_args('"Fishes : an introduction to ichthyology"')) }
      it_behaves_like "great results for Fishes : an introduction to ichthyology"
      it 'should not care about colon placement' do
        resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(title_search_args('"Fishes an introduction to ichthyology"')))
        resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(title_search_args('"Fishes: an introduction to ichthyology"')))
      end
    end
    
    shared_examples_for "great results for Jazz. [videorecording] : anyone can improvise" do
      it "should have best matches for Jazz. [videorecording] : anyone can improvise" do
        resp.should include('3995912').in_first(3)
      end
    end
    context "Jazz. [videorecording] : anyone can improvise" do
      let! (:resp) { solr_resp_ids_from_query 'Jazz. [videorecording] : anyone can improvise' }
      it_behaves_like "great results for Jazz. [videorecording] : anyone can improvise"
      it 'should not care about colon placement' do
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('Jazz. [videorecording] anyone can improvise'))
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('Jazz. [videorecording]: anyone can improvise'))
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('Jazz videorecording anyone can improvise'))
      end
    end
    context "Jazz. [videorecording] : anyone can improvise  (as phrase)" do
      let (:resp) { solr_resp_ids_from_query('"Jazz. [videorecording] : anyone can improvise"') }
      it_behaves_like "great results for Jazz. [videorecording] : anyone can improvise"
      it 'should not care about colon placement' do
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('"Jazz. [videorecording] anyone can improvise"'))
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('"Jazz. [videorecording]: anyone can improvise"'))
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('"Jazz videorecording anyone can improvise"'))
      end
    end    
  end # 5 terms
  
  context "6 terms" do
    shared_examples_for "great results for Qua-We-Na [microform]. : Native people" do
      it "should have best matches for Qua-We-Na [microform]. : Native people" do
        resp.should include('485199').in_first(3)
      end
    end
    context "Qua-We-Na [microform]. : Native people" do
      let! (:resp) { solr_resp_ids_from_query 'Qua-We-Na [microform]. : Native people' }
      it_behaves_like "great results for Qua-We-Na [microform]. : Native people"
      it 'should not care about colon placement' do
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('Qua-We-Na [microform] Native people'))
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('Qua-We-Na [microform].: Native people'))
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('Qua-We-Na [microform]: Native people'))
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('Qua-We-Na microform : Native people'))
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('Qua-We-Na microform Native people'))
      end
    end
    context "Qua-We-Na [microform]. : Native people  (phrase)" do
      let (:resp) { solr_resp_ids_from_query('"Qua-We-Na [microform]. : Native people"') }
      it_behaves_like "great results for Qua-We-Na [microform]. : Native people"
      it 'should not care about colon placement' do
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('"Qua-We-Na [microform] Native people"'))
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('"Qua-We-Na [microform].: Native people"'))
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('"Qua-We-Na [microform]: Native people"'))
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('"Qua-We-Na microform : Native people"'))
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('"Qua-We-Na microform Native people"'))
      end
    end
    
    shared_examples_for "great results for César Chávez : a voice for farmworkers" do
      it "should have best matches for César Chávez : a voice for farmworkers" do
        resp.should include('6757167').in_first(3)
      end
    end
    context "César Chávez : a voice for farmworkers", :jira => 'VUF-1128' do
      let! (:resp) { solr_resp_ids_from_query 'César Chávez : a voice for farmworkers' }
      it_behaves_like "great results for César Chávez : a voice for farmworkers"
      it 'should not care about colon placement' do
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('César Chávez a voice for farmworkers'))
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('César Chávez: a voice for farmworkers'))
      end
    end
    context "César Chávez : a voice for farmworkers  (phrase)", :jira => 'VUF-1128' do
      let (:resp) { solr_resp_ids_from_query('"César Chávez : a voice for farmworkers"') }
      it_behaves_like "great results for César Chávez : a voice for farmworkers"
      it 'should not care about colon placement' do
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('"César Chávez a voice for farmworkers"'))
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('"César Chávez: a voice for farmworkers"'))
      end
    end
  end # 6 terms
   
  context "7 terms" do
    shared_examples_for "great results for Petroleum : the phenomenon of a modern panic" do
      it "should have best matches for Petroleum : the phenomenon of a modern panic" do
        resp.should include('3412285').in_first(3)
      end
    end
    context "Petroleum : the phenomenon of a modern panic" do
      let! (:resp) { solr_resp_ids_from_query 'Petroleum : the phenomenon of a modern panic' }
      it_behaves_like "great results for Petroleum : the phenomenon of a modern panic"
      it 'should not care about colon placement' do
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('Petroleum the phenomenon of a modern panic'))
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('Petroleum: the phenomenon of a modern panic'))
      end
    end
    context "Petroleum : the phenomenon of a modern panic  (phrase)" do
      let (:resp) { solr_resp_ids_from_query('"Petroleum : the phenomenon of a modern panic"') }
      it_behaves_like "great results for Petroleum : the phenomenon of a modern panic"
      it 'should not care about colon placement' do
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('"Petroleum the phenomenon of a modern panic"'))
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('"Petroleum: the phenomenon of a modern panic"'))
      end
    end
    
    shared_examples_for "great results for Petroleum : exploration and exploitation in Norway : proceedings" do
      it "should have best matches for Petroleum : exploration and exploitation in Norway : proceedings" do
        resp.should include('3114278').in_first(3)
      end
    end
    context "Petroleum : exploration and exploitation in Norway : proceedings" do
      let! (:resp) { solr_resp_ids_from_query 'Petroleum : exploration and exploitation in Norway : proceedings' }
      it_behaves_like "great results for Petroleum : exploration and exploitation in Norway : proceedings"
      it 'should not care about colon placement' do
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('Petroleum exploration and exploitation in Norway : proceedings'))
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('Petroleum: exploration and exploitation in Norway : proceedings'))
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('Petroleum : exploration and exploitation in Norway proceedings'))
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('Petroleum : exploration and exploitation in Norway: proceedings'))
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('Petroleum exploration and exploitation in Norway proceedings'))
      end
    end
    context "Petroleum : exploration and exploitation in Norway : proceedings  (phrase)" do
      let (:resp) { solr_resp_ids_from_query('"Petroleum : exploration and exploitation in Norway : proceedings"') }
      it_behaves_like "great results for Petroleum : exploration and exploitation in Norway : proceedings"
      it 'should not care about colon placement' do
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('"Petroleum exploration and exploitation in Norway : proceedings"'))
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('"Petroleum: exploration and exploitation in Norway : proceedings"'))
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('"Petroleum : exploration and exploitation in Norway proceedings"'))
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('"Petroleum : exploration and exploitation in Norway: proceedings"'))
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('"Petroleum exploration and exploitation in Norway proceedings"'))
      end
    end
  end # 7 terms
  
  context "8 terms" do
    shared_examples_for "great results for The Beatles as musicians : Revolver through the Anthology" do
      it "should have best matches for The Beatles as musicians : Revolver through the Anthology" do
        resp.should include('4103922').in_first(3)
      end
    end
    context "The Beatles as musicians : Revolver through the Anthology", :jira => 'VUF-522' do
      let! (:resp) { solr_resp_ids_from_query 'The Beatles as musicians : Revolver through the Anthology' }
      it_behaves_like "great results for The Beatles as musicians : Revolver through the Anthology"
      it 'should not care about colon placement' do
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('The Beatles as musicians Revolver through the Anthology'))
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('The Beatles as musicians: Revolver through the Anthology'))
      end
    end
    context "The Beatles as musicians : Revolver through the Anthology  (phrase)", :jira => 'VUF-522' do
      let (:resp) { solr_resp_ids_from_query('"The Beatles as musicians : Revolver through the Anthology"') }
      it_behaves_like "great results for The Beatles as musicians : Revolver through the Anthology"
      it 'should not care about colon placement' do
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('"The Beatles as musicians Revolver through the Anthology"'))
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('"The Beatles as musicians: Revolver through the Anthology"'))
      end
    end
  end # 8 terms

  context "10 terms" do
    shared_examples_for "great results for International encyclopedia of revolution and protest : 1500 to the present" do
      it "should have best matches for International encyclopedia of revolution and protest : 1500 to the present" do
        resp.should include('7930827').in_first(3)
      end
    end
    context "International encyclopedia of revolution and protest : 1500 to the present", :jira => 'SW-65' do
      let! (:resp) { solr_resp_ids_from_query 'International encyclopedia of revolution and protest : 1500 to the present' }
      it_behaves_like "great results for International encyclopedia of revolution and protest : 1500 to the present"
      it 'should not care about colon placement' do
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('International encyclopedia of revolution and protest 1500 to the present'))
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('International encyclopedia of revolution and protest: 1500 to the present'))
      end
    end
    context "International encyclopedia of revolution and protest : 1500 to the present  (phrase)", :jira => 'SW-65' do
      let (:resp) { solr_resp_ids_from_query('"International encyclopedia of revolution and protest : 1500 to the present"') }
      it_behaves_like "great results for International encyclopedia of revolution and protest : 1500 to the present"
      it 'should not care about colon placement' do
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('"International encyclopedia of revolution and protest 1500 to the present"'))
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('"International encyclopedia of revolution and protest: 1500 to the present"'))
      end
    end
  end # 10 terms
  
  context "Alice in Wonderland : a serie[s] of pantomime pictures for grand orchestra" do
    it "Alice in Wonderland : a serie[s] of pantomime pictures for grand orchestra (not phrase)" do
      resp = solr_resp_ids_from_query 'Alice in Wonderland : a serie[s] of pantomime pictures for grand orchestra'
      resp.should include(["6813984", "6813999"])
      resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('Alice in Wonderland a serie[s] of pantomime pictures for grand orchestra'))
      resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('Alice in Wonderland: a serie[s] of pantomime pictures for grand orchestra'))
    end
    it "Alice in Wonderland : a serie[s] of pantomime pictures for grand orchestra (phrase)" do
      resp = solr_resp_ids_from_query '"Alice in Wonderland : a serie[s] of pantomime pictures for grand orchestra"'
      resp.should include(["6813984", "6813999"])
      resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('"Alice in Wonderland a serie[s] of pantomime pictures for grand orchestra"'))
      resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('"Alice in Wonderland: a serie[s] of pantomime pictures for grand orchestra"'))
    end
  end
  
end # colon