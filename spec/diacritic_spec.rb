# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Diacritics" do

  it "Acute Accent é", :jira => 'VUF-106' do
    resp = solr_resp_doc_ids_only({'q'=>'étude'})
    expect(resp).to include(["466512", "5747443"])
    expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'etude'}))
  end

  it "Grave à" do
    resp = solr_resp_doc_ids_only({'q'=>'verità'})
    expect(resp).to include("822363")
    expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'verita'}))
  end

  context "Umlaut" do
    it "ä (German)", :jira => 'VUF-106' do
      resp = solr_resp_doc_ids_only({'q'=>'Ränsch-Trill'})
      expect(resp).to include("2911735")
      expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'Ransch-Trill'}))
    end
    it "ü (Turkish)", :jira => 'SW-497' do
      resp = solr_response({'q'=>"Türkiye'de üniversite", 'fl'=>'id,title_245a_display', 'facet'=>false})
      expect(resp.size).to be >= 7
      expect(resp).to include("title_245a_display" => /T[üu]rkiye'de [üu]niversite/i).in_each_of_first(2).documents
      expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>"Turkiye'de universite"}))
    end
  end

  it "Circumflex ê" do
    resp = solr_resp_doc_ids_only({'q'=>'ancêtres'})
    expect(resp).to include("7519785")
    expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'ancetres'}))
  end

  it "Tilde ñ" do
    resp = solr_resp_doc_ids_only({'q'=>'Muñoz'})
    expect(resp).to include(["4701577", "1024967", "4498372"])
    expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'munoz'}))
  end

  it "Cedilla ç" do
    resp = solr_resp_doc_ids_only({'q'=>'exaltação'})
    expect(resp).to have_documents
    expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'exaltacao'}))
  end

  context "Russian ligature ͡ " do
    it "tysi͡acha" do
      resp = solr_resp_doc_ids_only({'q'=>'tysi͡acha'})
      expect(resp).to have_documents
      expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'tysiacha'}))
    end
    it "Fevralʹskogo", :jira => 'SW-621' do
      resp = solr_resp_doc_ids_only({'q'=>'Fevralʹskogo'})
      expect(resp.size).to be >= 7
      expect(resp).to include("8797373")
      expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'Fevralskogo'}))
      # not designed to work with apostrophe substitution, esp. as apostrophe is Solr operator
#      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>"Fevral'skogo"}))
    end
  end

  it "Soft Znak ś" do
    # cyrillic: Восемьсoт
    resp = solr_resp_doc_ids_only({'q'=>'vosemśot'})
    expect(resp).to have_documents
    expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'vosemʹsot'}))
    expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>"vosemsot"}))
  end

  it "Hard Znak ̋" do
    resp = solr_resp_doc_ids_only({'q'=>'Obe̋dinenie'})
    expect(resp).to have_documents
    expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'Obʺedinenie'}))
    expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'Obedinenie'}))
  end

  it "Caron ť" do
    resp = solr_resp_doc_ids_only({'q'=>'povesť'})
    expect(resp).to have_documents
    expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>"povest'"}))
    expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'povest'}))
  end

  it "Caron ǔ (Latvian)" do
    resp = solr_resp_doc_ids_only({'q'=>'Latviesǔ'})
    expect(resp).to have_documents
    expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>"Latviesu'"}))
    expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'Latviesu'}))
  end

  it "Ogonek ą" do
    resp = solr_resp_doc_ids_only({'q'=>'gąszczu'})
    expect(resp).to have_documents
    expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>"gaszczu'"}))
  end

  it "Overdot Ż" do
    resp = solr_resp_doc_ids_only({'q'=>'Żydów'})
    expect(resp).to have_documents
    expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>"zydow'"}))
  end

  context "macron" do
    it "ī (russian)" do
      resp = solr_resp_doc_ids_only({'q'=>'istorīi'})
      expect(resp).to have_documents
      expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>"istorii'"}))
    end
    it "ō" do
      resp = solr_resp_doc_ids_only({'q'=>'Kuginuki, Tōru'})
      expect(resp).to include("7926218")
      resp2 = solr_resp_doc_ids_only({'q'=>'Kuginuki, Toru'})
      expect(resp2).to have_the_same_number_of_results_as(resp2)
      expect(resp2).to include("7926218")
    end
    it "ū", :jira => ['VUF-106', 'VUF-166'] do
      resp = solr_resp_doc_ids_only({'q'=>'Rekishi yūgaku'})
      expect(resp).to include("5338009")
      expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'Rekishi yugaku'}))
    end
    it "ē Greek" do
      resp = solr_resp_doc_ids_only({'q'=>'Tsiknakēs'})
      expect(resp).to include(["7822463", "8216759"])
      expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'Tsiknakes'}))
    end
    it "ō Greek" do
      resp = solr_resp_doc_ids_only({'q'=>'Kōstas'})
      expect(resp.size).to be >= 700
      expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'Kostas'}))
    end
  end

  it "Kreska Ṡ" do
    resp = solr_resp_doc_ids_only({'q'=>'Ṡpiewy polskie'})
    expect(resp).to include(["299636", "307686"]) # replaced 2209396 with more relevant record
    expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'Spiewy polskie'}))
  end

  it "d with crossbar lower case" do
    resp = solr_resp_doc_ids_only({'q'=>'Tuđina'})
    expect(resp).to include(["150102", "2408677"]).in_first(3).documents
    expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'Tudina'}))
  end

  context "Polish chars Ż ł ó" do
    it "ł in Białe usta" do
      resp = solr_resp_doc_ids_only({'q'=>'Białe usta'})
      expect(resp).to include("3160696").in_first(3).results
      expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'Biale usta'}))
    end

    it "Żułkoós" do
      resp = solr_resp_doc_ids_only({'q'=>'Żułkoós'})
      expect(resp).to include("1885035")
      expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'Zulkoos'}))
    end
  end

  it "Hebrew transliteration Ḥ" do
    resp = solr_resp_doc_ids_only({'q'=>'le-Ḥayim', 'rows'=>'20'})
    expect(resp).to include(["6312584", "3503974"])
    expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'le-Hayim'}))
  end

  it "Hebrew script vowels (e.g. in  סֶגוֹל)" do
    resp = solr_resp_doc_ids_only({'q'=>'סֶגוֹל'})
    expect(resp).to include("5666705")
    expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'סגול'}))
  end

  it "Arabic script دَ" do
    resp = solr_resp_doc_ids_only({'q'=>  "دَ" })
    expect(resp).to have_documents
    # sent email to John Eilts 2010-08-22  for better test search examples
    # resp.should include("4776517")
    expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=> "د" }))
  end

  it "Arabic script alif with diacritics", :jira => ['VUF-1807', 'SW-718'] do
    resp = solr_resp_doc_ids_only({'q'=> "أ" })
    expect(resp).to have_documents
    expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>  "أ" }))
    expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=> "ـأ" }))
    expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>  "أ" }))
  end
  it "Arabic alif variantإ", :jira => 'SW-719' do
    resp = solr_resp_doc_ids_only({'q'=> "إمام السفينة" })
    expect(resp).to include("7829122")
    expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>  "امام السفينة" }))
  end

  it "Greek ῆ" do
    resp = solr_resp_doc_ids_only({'q'=>'τῆς', 'rows'=>'23'})
    expect(resp).to include("7881486")
    expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'της'}))
  end

  context "Turkish ı (undotted i) (Unicode U+0131)", :jira => 'SW-497' do
    it "Batı" do
      resp = solr_resp_doc_ids_only({'q'=>'Batı'})
      expect(resp.size).to be >= 200
      expect(resp).to include("6330638") # "title_245a_display":"Doğu Batı",
      expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'Bati'}))
    end
    it "Vakıflar dergisi" do
      resp = solr_resp_doc_ids_only({'q'=>'Vakıflar dergisi'})
      expect(resp.size).to be >= 2
      expect(resp).to include(["6666891", "6733701"]).as_first(2).documents
      expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'Vakiflar dergisi'}))
    end
    it "anlayısının", :jira => ['SW-718', 'SW-497', 'VUF-1807'] do
      resp = solr_response({'q'=>"anlayısının", 'fl'=>'id,title_245a_display', 'facet'=>false})
      expect(resp.size).to be >= 4
      expect(resp).to include("title_245a_display" => /anlay[ıi][sş][ıi]n[ıi]n/i).in_each_of_first(2).documents
      expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>"anlayisinin"}))
    end
  end

  it "Turkish ğ", :jira => 'SW-497' do
    resp = solr_resp_doc_ids_only({'q'=>'Doğu'})
    expect(resp.size).to be >= 350
    expect(resp).to include("6330638").in_first(10).documents # "title_245a_display":"Doğu Batı",
    expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'Dogu'}))
  end

  it "Turkish ş", :jira => 'SW-497' do
    resp = solr_response({'q'=>"gelişimi", 'fl'=>'id,title_245a_display', 'facet'=>false})
    expect(resp.size).to be >= 40
    expect(resp).to include("title_245a_display" => /geli[şs]imi/i).in_each_of_first(20).documents
    expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>"gelisimi"}))
  end

  context "Icelandic  ðýþ" do
    it "Đ, ð (d with crossbar)" do
      resp = solr_resp_doc_ids_only({'q'=>'Điðriks'})
      expect(resp.size).to be >= 20
      expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'Diðriks'}))
      expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'ðiðriks'}))
    end
    it "Þ, þ (thorn)" do
      resp = solr_resp_doc_ids_only({'q'=>'Þiðriks'})
      expect(resp.size).to be >= 8
      expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'þiðriks'}))
    end
    it "Ý, ý " do
      resp = solr_resp_doc_ids_only({'q'=>'Þiðriks'})
      expect(resp.size).to be >= 8
      expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'þiðriks'}))
    end
  end

  it "@o", :jira => 'SW-648' do
    resp = solr_resp_doc_ids_only({'q'=>'@oEtudes @oeconomiques'})
    expect(resp).to include("386893").as_first
#    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'Etudes economiques'}))
  end

  it "Ae ligature uppercase Æ" do
    resp = solr_resp_doc_ids_only({'q'=>'Æon'})
    expect(resp).to include(["6197318", "6628532"])
    expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'AEon'}))
  end

  it "ae ligature lowercase æ" do
    resp = solr_resp_doc_ids_only({'q'=>'Encyclopædia'})
    expect(resp).to have_documents
    expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'Encyclopaedia'}))
  end

  it "oe ligature lowercase œ" do
    resp = solr_resp_doc_ids_only({'q'=>'Cœurdevey'})
    expect(resp).to have_documents
    expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'Coeurdevey'}))
  end

  it "Vietnamese (Lập Bản đò̂ phân Việt )" do
    resp = solr_resp_doc_ids_only({'q'=>'Lập Bản đò̂ phân Việt '})
    expect(resp).to include("3053956")
    expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'Lap Ban do phan Viet'}))
  end

  it "ʻ (Korean)", :jira => ['SW-754', 'SW-648'], :fixme => true do
    resp = solr_resp_doc_ids_only({'q'=>"yi t'ae-jun"})
    expect(resp.size).to be >= 15
    expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>"yi tʻae-jun"}))
#    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>"yi tae-jun"}))
  end

  context "music  ♯ and  ♭" do
    # see also synonyms_spec
    it "♭ vs. b", :jira => ['SW-648'] do
      resp = solr_resp_doc_ids_only({'q'=>"Concertos, horn, orchestra, K. 417, E♭ major"})
      expect(resp.size).to be >= 70
      expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>"Concertos, horn, orchestra, K. 417, Eb major"}))
    end
    it "♯ vs #"do
      resp = solr_resp_doc_ids_only({'q'=>"Symphonies, no. 5, C♯ minor"})
      expect(resp.size).to be >= 45
      expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>"Symphonies, no. 5, C# minor"}))
    end
  end

end
