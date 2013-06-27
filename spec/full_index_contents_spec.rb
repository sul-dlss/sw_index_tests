require 'spec_helper'

describe "Index Contents" do

  shared_examples_for 'collection has all its items' do | coll_val, min_num_exp |
    it "collection filter query should return enough results" do
      resp = solr_resp_doc_ids_only({'fq'=>"collection:#{coll_val}", 'rows'=>'0'})
      resp.should have_at_least(min_num_exp).documents
    end
  end
  
  shared_examples_for 'DOR item objects' do | query_str, exp_ids, max_res_num, coll_id |
    before(:all) do
      @resp = solr_response({'q'=>query_str, 'fl'=>'id,url_fulltext,collection', 'facet'=>false})
    end
    it "item objects should be discoverable via everything search" do
      resp = solr_resp_ids_from_query query_str
      @resp.should include(exp_ids).in_first(max_res_num)
    end
    it "item objects should have gdor fields" do
      exp_ids.each { |druid|
        resp = solr_response({'qt'=>'document', 'id'=>druid, 'fl'=>'id,collection,modsxml,url_fulltext,format,druid', 'facet'=>false})
        resp.should include("url_fulltext" => "http://purl.stanford.edu/#{druid}")
        resp.should include("modsxml" => /http:\/\/www\.loc\.gov\/mods\/v3/ )
        resp.should include("collection" => coll_id )
        resp.should include("format" => /.+/)
        resp.should include("druid" => druid )
      }
    end
  end
  
  shared_examples_for 'DOR collection object' do | solr_doc_id, druid |
    before(:all) do
      @resp = solr_response({'qt'=>'document', 'id'=>solr_doc_id, 'fl'=>'id,url_fulltext,collection_type,modsxml,format,druid', 'facet'=>false})
    end
    it "collection object should have purl url in url_fulltext" do
      @resp.should include("url_fulltext" => "http://purl.stanford.edu/#{druid}")
    end
    it "collection object should have collection_type field" do
      @resp.should include("collection_type" => 'Digital Collection')
    end
    it "collection object should have modsxml field if no sirsi record" do
      @resp.should include("modsxml" => /http:\/\/www\.loc\.gov\/mods\/v3/ ) if solr_doc_id == druid
    end
    it "collection object should have a format field" do
      @resp.should include("format" => /.+/)
    end
    it "collection object should have a druid field if no sirsi record" do
      @resp.should include("druid" => druid ) if solr_doc_id == druid
    end
  end

  context "all MARC data from SIRSI (Symphony)" do
    it_behaves_like "collection has all its items", 'sirsi', 6950000
  end
  
  context "DOR Digital Collections" do
    
    context "Kolb" do
      it_behaves_like "collection has all its items", '4084372', 1150
      it_behaves_like "DOR collection object", '4084372', 'bs646cd8717'
      it_behaves_like "DOR item objects", "Addison Joseph", ['vb267mw8946'], 10, '4084372'
    end

    context "Reid Dennis" do
      it_behaves_like "collection has all its items", '6780453', 46
      it_behaves_like "DOR collection object", '6780453', 'sg213ph2100'
      it_behaves_like "DOR item objects", "bird's eye view san francisco", ['pz572zt9333', 'nz525ps5073', 'bw260mc4853', 'mz639xs9677'], 15, '6780453'
    end

    context "Walters Manuscripts" do
      it_behaves_like "collection has all its items", 'ww121ss5000', 265
      it_behaves_like "DOR collection object", 'ww121ss5000', 'ww121ss5000'
      it_behaves_like "DOR item objects", "walters brasses", ['cn006dx2288'], 3, 'ww121ss5000'
    end
    
    context "Hydrus collections" do
      shared_examples_for 'hydrus collection object' do | solr_doc_id |
        it "should have display_type of hydrus_collection" do
          resp = solr_response({'qt'=>'document', 'id'=>solr_doc_id, 'fl'=>'id,display_type', 'facet'=>false})
          resp.should include('display_type' => 'hydrus_collection')
        end
      end
      shared_examples_for 'hydrus item object' do | solr_doc_id |
        it "should have display_type of hydrus_object" do
          resp = solr_response({'qt'=>'document', 'id'=>solr_doc_id, 'fl'=>'id,display_type', 'facet'=>false})
          resp.should include('display_type' => 'hydrus_object')
        end
      end

      context "Folding@home" do
        it_behaves_like "collection has all its items", 'cj269gn0736', 3
        it_behaves_like "DOR collection object", 'cj269gn0736', 'cj269gn0736'
        it_behaves_like "hydrus collection object", 'cj269gn0736'
        it_behaves_like "DOR item objects", "hp35 trajectory data", ['bd829sf1034'], 3, 'cj269gn0736'
        it_behaves_like "hydrus item object", 'bd829sf1034'
      end
      context "Preserving Virtual Worlds" do
        it_behaves_like "collection has all its items", 'sn446tz2204', 8
        it_behaves_like "DOR collection object", 'sn446tz2204', 'sn446tz2204'
        it_behaves_like "hydrus collection object", 'sn446tz2204'
        it_behaves_like "DOR item objects", "star raiders", ['pp060nc9006'], 3, 'sn446tz2204'
        it_behaves_like "hydrus item object", 'pp060nc9006'
      end
      context "Stanford Research Data" do
        it_behaves_like "collection has all its items", 'md919gh6774', 6
        it_behaves_like "DOR collection object", 'md919gh6774', 'md919gh6774'
        it_behaves_like "hydrus collection object", 'md919gh6774'
        it_behaves_like "DOR item objects", "high angular resolution", ['yx282xq2090'], 3, 'md919gh6774'
        it_behaves_like "hydrus item object", 'yx282xq2090'
      end
      context "SUL staff publications" do
        it_behaves_like "collection has all its items", 'hn730ks3626', 2
        it_behaves_like "DOR collection object", 'hn730ks3626', 'hn730ks3626'
        it_behaves_like "hydrus collection object", 'hn730ks3626'
        it_behaves_like "DOR item objects", "academy unbound", ['bd701dh8028'], 3, 'hn730ks3626'
        it_behaves_like "hydrus item object", 'bd701dh8028'
      end
      context "Physic Undergrad Theses" do
        it_behaves_like "collection has all its items", 'ds247vz0452', 17
        it_behaves_like "DOR collection object", 'ds247vz0452', 'ds247vz0452'
        it_behaves_like "hydrus collection object", 'ds247vz0452'
        it_behaves_like "DOR item objects", "scanning squid", ['gh325bb5942'], 3, 'ds247vz0452'
        it_behaves_like "hydrus item object", 'gh325bb5942'
      end
    end # Hydrus collections
    
  end # DOR Digital Collections
  
end