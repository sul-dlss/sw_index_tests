# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'rspec-solr'

describe "Diacritics" do
    
  it "Acute Accent é" do
    resp = solr_resp_doc_ids_only({'q'=>'étude'})
    resp.should include(["466512", "5747443"])
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'etude'}))
  end
  
  it "Umlaut ä" do
    resp = solr_resp_doc_ids_only({'q'=>'Ränsch-Trill'})
    resp.should include("2911735")
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'Ransch-Trill'}))
  end

  it "macron ō" do
    resp = solr_resp_doc_ids_only({'q'=>'Kuginuki, Tōru'}) 
    resp.should include("7926218")
    resp2 = solr_resp_doc_ids_only({'q'=>'Kuginuki, Toru'})
    resp2.should have_the_same_number_of_results_as(resp2)
    resp2.should include("7926218")
  end
  
  it "macron ū" do
    resp = solr_resp_doc_ids_only({'q'=>'Rekishi yūgaku'})
    resp.should include("5338009")
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'Rekishi yugaku'}))
  end
  
  it "Polish S char Ṡ" do
    resp = solr_resp_doc_ids_only({'q'=>'Ṡpiewy polskie'})
    resp.should include(["2209396", "307686"])
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'Spiewy polskie'}))
  end
  
  it "Polish chars Ż ł ó " do
    resp = solr_resp_doc_ids_only({'q'=>'Żułkoós'})
    resp.should include("1885035")
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'Zulkoos'}))
  end
  
  it "Hebrew transliteration Ḥ" do
    resp = solr_resp_doc_ids_only({'q'=>'le-Ḥayim', 'rows'=>'20'})
    resp.should include(["6312584", "3503974"])
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'le-Hayim'}))
  end

  it "Hebrew script vowels (e.g. in  סֶגוֹל)" do
    resp = solr_resp_doc_ids_only({'q'=>'סֶגוֹל'})
    resp.should include("5666705")
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'סגול'}))
  end
  
  it "Arabic script دَ" do
    resp = solr_resp_doc_ids_only({'q'=>  "دَ" })
    # sent email to John Eilts 2010-08-22  for better test search examples
    # resp.should include("4776517")
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=> "د" }))
  end
  
  it "Arabic script alif with diacritics" do
    resp = solr_resp_doc_ids_only({'q'=> "أ" })
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>  "أ" }))
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=> "ـأ" }))
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>  "أ" }))
  end
  
  it "Greek ῆ" do
    resp = solr_resp_doc_ids_only({'q'=>'τῆς'})
    resp.should include("7719950")
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'της'}))
  end
  
  it "Ae ligature Æ" do
    resp = solr_resp_doc_ids_only({'q'=>'Æon'})
    resp.should include(["6197318", "6628532"])
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'aeon'}))
  end  
  
end