# encoding : utf-8 
require 'spec_helper'

# TODO: phrase searching, links?

describe "Tests for synonyms.txt used by Solr SynonymFilterFactory" do
  context "RDA changes for authority headings", :jira => 'SW-845' do
    context '"Dept." will change to "Department"' do
      # department => dept
      it "author search for United States Dept. of State" do
        resp = solr_resp_doc_ids_only(author_search_args('United States Dept. of State'))    
        resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(author_search_args('United States Dept of State')))
        resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(author_search_args('United States Department of State')))
        resp.should have_at_least(55000).documents
        # contain this heading in an author field in the spelled out form (i.e. United States Department. of State):
        # 10095720, 10096139
      end
    end
    context '"Koran" will change to "Qurʼan"' do
      # qurʼan, qur'an, quran, qorʼan, qor'an, qoran => koran
      it "everything search" do
        resp = solr_resp_ids_from_query('koran')
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query("qurʼan")) # alif
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query("Qur'an")) # apostrophe
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query("quran"))
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query("Qorʼan")) # alif
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query("qor'an")) # apostrophe
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query("Qoran"))
        resp.should have_at_least(3000).documents
      end
      it "title search" do
        resp = solr_resp_doc_ids_only(title_search_args('Koran')) 
        resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(title_search_args("Qurʼan"))) # alif
        resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(title_search_args("qur'an"))) # apostrophe
        resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(title_search_args("Quran")))
        resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(title_search_args("qorʼan"))) # alif
        resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(title_search_args("Qor'an"))) # apostrophe
        resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(title_search_args("qoran")))
      end
    end
    context '"O.T." and "N.T." will change to "Old Testament" and "New Testament"' do
      # old testament => o.t.
      # new testament => n.t.      
    end
    context '"violoncello" will change to "cello" ' do
      # violincello => cello
      it "subject search" do
        resp = solr_resp_doc_ids_only(subject_search_args('violincello'))    
        resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(subject_search_args('cello')))
        resp.should have_at_least(3000).documents
      end
    end
  end # RDA changes for authority headings
  
  context "programming languages" do
    context "C++" do
      it "everything search" do
        resp = solr_response({'q'=>"C++", 'fl'=>'id,title_245a_display', 'facet'=>false})
        resp.should include("title_245a_display" => /C\+\+/).in_each_of_first(20).documents
        resp.should have_at_most(1000).documents
        resp.should_not have_the_same_number_of_results_as(solr_resp_ids_from_query("C"))
      end
      it "professional C++" do
        resp = solr_resp_ids_from_query('professional C++')
        resp.should include(['9612289', '9240287', '7534583', '7819695', '9801531']).in_first(10).results
        resp.should have_at_most(150).documents
        resp.should_not have_the_same_number_of_results_as(solr_resp_ids_from_query("professional C"))
      end
      it "C++ active learning" do
        resp = solr_resp_ids_from_query('C++ active learning')
        resp.should include('8937747').as_first.result
        resp.should have_at_most(50).documents
        resp.should_not have_the_same_number_of_results_as(solr_resp_ids_from_query("C active learning"))
      end
      it "C++ computer program" do
        resp = solr_response({'q'=>"C++ computer program", 'fl'=>'id,title_245a_display', 'facet'=>false})
        resp.should include("title_245a_display" => /C\+\+/).in_each_of_first(20).documents
        resp.should have_at_most(800).documents
        resp.should_not have_the_same_number_of_results_as(solr_resp_ids_from_query("C computer program"))
      end
    end
    context "j#, j♯ => jsssharp" do
      it "everything search" do
        resp = solr_resp_ids_from_query('J#')
        resp.should have_at_most(20).documents
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query("J♯"))
        resp.should have_fewer_results_than(solr_resp_ids_from_query("J"))
      end
    end
    context "C#" do
      it "professional C#" do
        resp = solr_resp_ids_from_query('professional C#')
        resp.should have_at_most(250).documents
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query("professional C♯"))
        resp.should_not have_the_same_number_of_results_as(solr_resp_ids_from_query("professional C"))
      end
    end    
  end # programming languages
  
  context "musical keys" do
    context "sharp keys" do
      # a#, a♯, a-sharp => a sharp
      # number sign, musical sharp sign, hyphen, space
=begin
a# minor
a♯ minor
a-sharp minor
a sharp minor 
a very sharp knife
a sharp knife
a sharp -->   will get MORE musical results than previously (better recall); could be perceived as reducing precision for non-musical searches.
=end
      it "should not reduce precision for non-musical instances of 'a sharp'" do
        pending "to be implemented"
      end
    end
    context "flat keys" do
      # ab, a♭, a-flat => a flat
      # lowercase b, flat sign, hyphen, space
      context "non-musical instances of xb" do
        it "should not reduce precision for non-musical instances of EB" do
          pending "to be implemented"
        end
        it "should not reduce precision for non-musical instances of Gb" do
          pending "to be implemented"
        end
        it "should not reduce precision for non-musical instances of bb" do
          pending "to be implemented"
        end
      end
    end
  end

end