# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Diacritics" do
    
  it "Acute Accent é" do
    resp = solr_resp_doc_ids_only({'q'=>'étude'})
    resp.should include(["466512", "5747443"])
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'etude'}))
  end
  
  it "Grave à" do
    resp = solr_resp_doc_ids_only({'q'=>'verità'})
    resp.should include("822363")
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'verita'}))
  end
  
  context "Umlaut" do
    it "ä (German)" do
      resp = solr_resp_doc_ids_only({'q'=>'Ränsch-Trill'})
      resp.should include("2911735")
      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'Ransch-Trill'}))
    end
    it "ü (Turkish)", :jira => 'SW-497' do
      resp = solr_response({'q'=>"Türkiye'de üniversite", 'fl'=>'id,title_245a_display', 'facet'=>false})
      resp.should have_at_least(8).documents
      resp.should include("title_245a_display" => /T[üu]rkiye'de [üu]niversite/i).in_each_of_first(2).documents
      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>"Turkiye'de universite"}))
    end
  end
  
  it "Circumflex ê" do
    resp = solr_resp_doc_ids_only({'q'=>'ancêtres'})
    resp.should include("7519785")
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'ancetres'}))
  end
  
  it "Tilde ñ" do
    resp = solr_resp_doc_ids_only({'q'=>'Muñoz'})
    resp.should include(["4701577", "1024967", "4498372"])
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'munoz'}))
  end
  
  it "Cedilla ç" do
    resp = solr_resp_doc_ids_only({'q'=>'exaltação'})
    resp.should have_documents
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'exaltacao'}))
  end
  
  context "Russian ligature ͡ " do
    it "tysi͡acha" do
      resp = solr_resp_doc_ids_only({'q'=>'tysi͡acha'})
      resp.should have_documents
      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'tysiacha'}))
    end
    it "Fevralʹskogo", :jira => 'SW-621' do
      resp = solr_resp_doc_ids_only({'q'=>'Fevralʹskogo'})
      resp.should have_at_least(7).documents
      resp.should include("8797373")
      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'Fevralskogo'}))
      # not designed to work with apostrophe substitution, esp. as apostrophe is Solr operator
#      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>"Fevral'skogo"}))
    end   
  end
  
  it "Soft Znak ś" do
    # cyrillic: Восемьсoт
    resp = solr_resp_doc_ids_only({'q'=>'vosemśot'})
    resp.should have_documents
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'vosemʹsot'}))
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>"vosemsot"}))
  end
  
  it "Hard Znak ̋" do
    resp = solr_resp_doc_ids_only({'q'=>'Obe̋dinenie'})
    resp.should have_documents
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'Obʺedinenie'}))
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'Obedinenie'}))
  end
  
  it "Caron ť" do
    resp = solr_resp_doc_ids_only({'q'=>'povesť'})
    resp.should have_documents
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>"povest'"}))
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'povest'}))
  end
  
  it "Caron ǔ (Latvian)" do
    resp = solr_resp_doc_ids_only({'q'=>'Latviesǔ'})
    resp.should have_documents
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>"Latviesu'"}))
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'Latviesu'}))
  end
  
  it "Ogonek ą" do
    resp = solr_resp_doc_ids_only({'q'=>'gąszczu'})
    resp.should have_documents
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>"gaszczu'"}))
  end
  
  it "Overdot Ż" do
    resp = solr_resp_doc_ids_only({'q'=>'Żydów'})
    resp.should have_documents
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>"zydow'"}))
  end

  context "macron" do
    it "ī (russian)" do
      resp = solr_resp_doc_ids_only({'q'=>'istorīi'})
      resp.should have_documents
      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>"istorii'"}))
    end
    it "ō" do
      resp = solr_resp_doc_ids_only({'q'=>'Kuginuki, Tōru'}) 
      resp.should include("7926218")
      resp2 = solr_resp_doc_ids_only({'q'=>'Kuginuki, Toru'})
      resp2.should have_the_same_number_of_results_as(resp2)
      resp2.should include("7926218")
    end
    it "ū" do
      resp = solr_resp_doc_ids_only({'q'=>'Rekishi yūgaku'})
      resp.should include("5338009")
      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'Rekishi yugaku'}))
    end
    it "ē Greek" do
      resp = solr_resp_doc_ids_only({'q'=>'Tsiknakēs'})
      resp.should include(["7822463", "8216759"])
      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'Tsiknakes'}))
    end
    it "ō Greek" do
      resp = solr_resp_doc_ids_only({'q'=>'Kōstas'})
      resp.should have_at_least(700).documents
      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'Kostas'}))
    end
  end
  
  it "Kreska Ṡ" do
    resp = solr_resp_doc_ids_only({'q'=>'Ṡpiewy polskie'})
    resp.should include(["2209396", "307686"])
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'Spiewy polskie'}))
  end
  
  it "d with crossbar lower case" do
    resp = solr_resp_doc_ids_only({'q'=>'Tuđina'})
    resp.should include(["150102", "2408677"]).in_first(3).documents
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'Tudina'}))
  end

  context "Polish chars Ż ł ó" do
    it "ł in Białe usta" do
      resp = solr_resp_doc_ids_only({'q'=>'Białe usta'})
      resp.should include("3160696").in_first(3).results
      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'Biale usta'}))
    end
    
    it "Żułkoós" do
      resp = solr_resp_doc_ids_only({'q'=>'Żułkoós'})
      resp.should include("1885035")
      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'Zulkoos'}))
    end
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
    resp.should have_documents
    # sent email to John Eilts 2010-08-22  for better test search examples
    # resp.should include("4776517")
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=> "د" }))
  end
  
  it "Arabic script alif with diacritics" do
    resp = solr_resp_doc_ids_only({'q'=> "أ" })
    resp.should have_documents
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>  "أ" }))
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=> "ـأ" }))
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>  "أ" }))
  end
  it "Arabic alif variantإ", :jira => 'SW-719' do
    resp = solr_resp_doc_ids_only({'q'=> "إمام السفينة" })
    resp.should include("7829122")
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>  "امام السفينة" }))
  end
  
  it "Greek ῆ" do
    resp = solr_resp_doc_ids_only({'q'=>'τῆς'})
    resp.should include("7719950")
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'της'}))
  end
  
  context "Turkish ı (undotted i) (Unicode U+0131)", :jira => 'SW-497' do
    it "Batı" do
      resp = solr_resp_doc_ids_only({'q'=>'Batı'})
      resp.should have_at_least(350).documents
      resp.should include("6330638")
      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'Bati'}))
    end
    it "Vakıflar dergisi" do
      resp = solr_resp_doc_ids_only({'q'=>'Vakıflar dergisi'})
      resp.should have_at_least(2).documents
      resp.should include(["6666891", "6733701"]).as_first(2).documents
      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'Vakiflar dergisi'}))
    end
    it "anlayısının", :jira => ['SW-718', 'SW-497'] do
      resp = solr_response({'q'=>"anlayısının", 'fl'=>'id,title_245a_display', 'facet'=>false})
      resp.should have_at_least(4).documents
      resp.should include("title_245a_display" => /anlay[ıi][sş][ıi]n[ıi]n/i).in_each_of_first(2).documents
      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>"anlayisinin"}))
    end    
  end
  
  it "Turkish ğ", :jira => 'SW-497' do
    resp = solr_resp_doc_ids_only({'q'=>'Doğu'})
    resp.should have_at_least(350).documents
    resp.should include("6330638").in_first(10).documents
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'Dogu'}))
  end
  
  it "Turkish ş", :jira => 'SW-497' do
    resp = solr_response({'q'=>"gelişimi", 'fl'=>'id,title_245a_display', 'facet'=>false})
    resp.should have_at_least(40).documents
    resp.should include("title_245a_display" => /geli[şs]imi/i).in_each_of_first(20).documents
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>"gelisimi"}))
  end
  
  context "Icelandic  ðýþ" do
    it "Đ, ð (d with crossbar)" do
      resp = solr_resp_doc_ids_only({'q'=>'Điðriks'})
      resp.should have_at_least(20).documents
      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'Diðriks'}))
      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'ðiðriks'}))
    end
    it "Þ, þ (thorn)" do
      resp = solr_resp_doc_ids_only({'q'=>'Þiðriks'})
      resp.should have_at_least(8).documents
      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'þiðriks'}))
    end
    it "Ý, ý " do
      resp = solr_resp_doc_ids_only({'q'=>'Þiðriks'})
      resp.should have_at_least(8).documents
      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'þiðriks'}))
    end
  end
  
  it "@o", :jira => 'SW-648', :fixme => true do
    resp = solr_resp_doc_ids_only({'q'=>'@oEtudes @oeconomiques'})
    resp.should include("386893").as_first
#    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'Etudes economiques'}))
  end
    
  it "Ae ligature uppercase Æ" do
    resp = solr_resp_doc_ids_only({'q'=>'Æon'})
    resp.should include(["6197318", "6628532"])
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'AEon'}))
  end 
  
  it "ae ligature lowercase æ" do
    resp = solr_resp_doc_ids_only({'q'=>'Encyclopædia'})
    resp.should have_documents
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'Encyclopaedia'}))
  end
  
  it "oe ligature lowercase œ" do
    resp = solr_resp_doc_ids_only({'q'=>'Cœurdevey'})
    resp.should have_documents
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'Coeurdevey'}))
  end
  
  it "Vietnamese (Lập Bản đò̂ phân Việt )" do
    resp = solr_resp_doc_ids_only({'q'=>'Lập Bản đò̂ phân Việt '})
    resp.should include("3053956")
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'Lap Ban do phan Viet'}))
  end 
  
  it "ʻ (Korean)", :jira => ['SW-754', 'SW-648'], :fixme => true do
    resp = solr_resp_doc_ids_only({'q'=>"yi t'ae-jun"})
    resp.should have_at_least(15).documents
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>"yi tʻae-jun"}))
#    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>"yi tae-jun"}))
  end
  
  context "music  ♯ and  ♭" do
    it "♭ vs. b", :jira => ['SW-648'], :fixme => true do
      resp = solr_resp_doc_ids_only({'q'=>"Concertos, horn, orchestra, K. 417, E♭ major"})
      resp.should have_at_least(70).documents
      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>"Concertos, horn, orchestra, K. 417, Eb major"}))
    end
    it "♯ vs #"do
      resp = solr_resp_doc_ids_only({'q'=>"Symphonies, no. 5, C♯ minor"})
      resp.should have_at_least(45).documents
      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>"Symphonies, no. 5, C# minor"}))
    end
  end
  
end