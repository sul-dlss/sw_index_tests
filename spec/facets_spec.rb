# encoding: utf-8

require 'spec_helper'

describe "facet values and queries" do

  context "facet queries" do
    it "facet queries with diacritics should work - é" do
      resp = solr_resp_doc_ids_only({'fq'=>['author_person_facet:"Franck, César, 1822-1890"', 'format:"Music - Score"', 'topic_facet:"Organ music"']})
      resp.should have_at_least(15).documents
    end

    it "facet queries with diacritics should work - ĭ" do
      resp = solr_resp_doc_ids_only({'fq'=>'author_person_facet:"Chukovskiĭ, Korneĭ, 1882-1969"', 'q'=>"\"russian children's literature collection\""})
      resp.should have_at_least(40).documents
    end

    it "top level call number - LC" do
      resp = solr_resp_doc_ids_only({'q'=>'caterpillar', 'fq'=>'callnum_top_facet:"M - Music"'})
      resp.should include(["294924", "5637322"])
    end

    it "format Books" do
      resp = solr_resp_doc_ids_only({'q'=>'French miniatures', 'fq'=>'format:Book', 'rows'=>30})
      resp.should have_at_least(200).documents
      resp.should include(["728793", "2043360"]).in_first(3)
      resp.should include("1067894") # French Revolution in Miniature
      resp.should include("20084") # Cassells French Miniature Dictionary
    end

    it "lesbian gay vidoes", :jira => 'VUF-311' do
      # implemented in boolean_spec
    end

    it "ethiopia maps", :jira => 'VUF-2535' do
      resp = solr_resp_doc_ids_only({'q'=>'ethiopia', 'fq'=>'format:Map/Globe'})
      resp.should have_at_least(80).results
      resp.should_not include('9689856') # a San Francisco atlas
      resp = solr_resp_doc_ids_only({'q'=>'ethiopia', 'fq'=>'format:Map/Globe', 'sort' => 'pub_date_sort desc, title_sort asc'})
      resp.should have_at_least(80).results
      resp.should include('9689856')
    end

  end

  context "facet values" do
    it "trailing period stripped from facet values" do
      resp = solr_response({'q'=>'pyramids', 'fl' => 'id', 'facet.field'=>'topic_facet'})
      resp.should have_facet_field('topic_facet').with_value("Pyramids")
      resp.should_not have_facet_field('topic_facet').with_value("Pyramids.")
    end

    it "bogus Lane topics, like 'nomesh' and stuff from 655a, should not be topic facet values", :jira => 'VUF-238' do
      resp = solr_response({'fq'=>'building_facet:"Medical (Lane)"', 'fl' => 'id', 'facet.field'=>'topic_facet'})
      resp.should have_facet_field('topic_facet').with_value("Medicine")
      resp.should_not have_facet_field('topic_facet').with_value("nomesh")
      resp.should_not have_facet_field('topic_facet').with_value("Internet Resource")
      resp.should_not have_facet_field('topic_facet').with_value("Fulltext")
    end

    it "facets for Jane Austen Everything Search with author facet should have Videos", :jira => 'VUF-255' do
      resp = solr_response({'q'=>'jane austen', 'fq'=>'author_person_facet:"Austen, Jane, 1775-1817"', 'fl' => 'id', 'facet.field'=>'format'})
      resp.should have_facet_field('format').with_value("Video")
    end

    it "author_person_facet should include 700 fields" do
      resp = solr_response({'q'=>'"decentralization and school improvement"', 'fl' => 'id', 'facet.field' => 'author_person_facet'})
      resp.should have_facet_field('author_person_facet').with_value("Carnoy, Martin")
      resp.should have_facet_field('author_person_facet').with_value("Hannaway, Jane")
    end
    
    it "language facet should not include value 'Unknown'" do
      resp = solr_response({'fl' => 'id', 'facet.field' => 'language', 'facet.limit' => '-1', 'rows' => '0'})
      resp.should_not have_facet_field('language').with_value('Unknown')
    end
  end
  
  context "expected values in the author person facet", :jira => 'VUF-138' do
    it "war and peace should have tolstoy" do
      resp = solr_response({'q' => 'war and peace', 'fl'=>'id', 'facet.field'=>'author_person_facet'})
      resp.should have_facet_field('author_person_facet').with_value('Tolstoy, Leo, graf, 1828-1910')
    end
    it "evolution should have darwin" do
      resp = solr_response({'q' => 'evolution', 'fl'=>'id', 'facet.field'=>'author_person_facet'})
      resp.should have_facet_field('author_person_facet').with_value('Darwin, Charles, 1809-1882')
    end
    it "civil disobedience should have thoreau" do
      resp = solr_response({'q' => 'civil disobedience', 'fl'=>'id', 'facet.field'=>'author_person_facet'})
      resp.should have_facet_field('author_person_facet').with_value('Thoreau, Henry David, 1817-1862')
    end
  end
  
  context "expected values in the author person facet", :jira => 'VUF-138' do
    it "war and peace should have tolstoy" do
      resp = solr_response({'q' => 'war and peace', 'fl'=>'id', 'facet.field'=>'author_person_facet'})
      resp.should have_facet_field('author_person_facet').with_value('Tolstoy, Leo, graf, 1828-1910')
    end
    it "evolution should have darwin" do
      resp = solr_response({'q' => 'evolution', 'fl'=>'id', 'facet.field'=>'author_person_facet'})
      resp.should have_facet_field('author_person_facet').with_value('Darwin, Charles, 1809-1882')
    end
    it "civil disobedience should have thoreau" do
      resp = solr_response({'q' => 'civil disobedience', 'fl'=>'id', 'facet.field'=>'author_person_facet'})
      resp.should have_facet_field('author_person_facet').with_value('Thoreau, Henry David, 1817-1862')
    end
  end

end