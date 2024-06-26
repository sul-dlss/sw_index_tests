describe "facet values and queries" do

  context "facet queries" do
    it "facet queries with diacritics should work - é" do
      resp = solr_resp_doc_ids_only({'fq'=>['author_person_facet:"Franck, César, 1822-1890"', 'format_main_ssim:"Music score"', 'topic_facet:"Organ music"']})
      expect(resp.size).to be >= 15
    end

    it "facet queries with diacritics should work - ĭ" do
      resp = solr_resp_doc_ids_only({'fq'=>'author_person_facet:"Chukovskiĭ, Korneĭ, 1882-1969"', 'q'=>"\"russian children's literature collection\""})
      expect(resp.size).to be >= 40
    end

    it "call number" do
      resp = solr_resp_doc_ids_only({'q'=>'caterpillar', 'fq'=>'callnum_facet_hsim:"LC Classification|M - Music"'})
      expect(resp).to include(["294924", "5637322"])
    end

    it "format Books" do
      resp = solr_resp_doc_ids_only({'q'=>'French miniatures', 'fq'=>'format_main_ssim:Book', 'rows'=>30})
      expect(resp.size).to be >= 200
      expect(resp).to include(["728793", "2043360"]).in_first(3)
      expect(resp).to include("1067894") # French Revolution in Miniature
      expect(resp).to include("20084") # Cassells French Miniature Dictionary
    end

    it "lesbian gay vidoes", :jira => 'VUF-311' do
      # implemented in boolean_spec
    end

    it "ethiopia maps", :jira => 'VUF-2535' do
      resp = solr_resp_doc_ids_only({'q'=>'ethiopia', 'fq'=>'format_main_ssim:Map'})
      expect(resp.size).to be >= 80
      expect(resp).not_to include('9689856') # a San Francisco atlas
    end
  end

  context "facet values" do
    it "trailing period stripped from facet values" do
      resp = solr_response({'q'=>'pyramids', 'fl' => 'id', 'facet.field'=>'topic_facet'})
      expect(resp).to have_facet_field('topic_facet').with_value("Pyramids")
      expect(resp).not_to have_facet_field('topic_facet').with_value("Pyramids.")
    end

    it "bogus Lane topics, like 'nomesh' and stuff from 655a, should not be topic facet values", :jira => 'VUF-238' do
      resp = solr_response({'fq'=>'building_facet:"Lane Medical"', 'fl' => 'id', 'facet.field'=>'topic_facet'})
      expect(resp).to have_facet_field('topic_facet').with_value("Medicine")
      expect(resp).not_to have_facet_field('topic_facet').with_value("nomesh")
      expect(resp).not_to have_facet_field('topic_facet').with_value("Internet Resource")
      expect(resp).not_to have_facet_field('topic_facet').with_value("Fulltext")
    end

    it "author_person_facet should include 700 fields" do
      resp = solr_response({'q'=>'"decentralization and school improvement"', 'fl' => 'id', 'facet.field' => 'author_person_facet'})
      expect(resp).to have_facet_field('author_person_facet').with_value("Carnoy, Martin")
      expect(resp).to have_facet_field('author_person_facet').with_value("Hannaway, Jane")
    end

    it "language facet should not include value 'Unknown'" do
      resp = solr_response({'fl' => 'id', 'facet.field' => 'language', 'facet.limit' => '-1', 'rows' => '0'})
      expect(resp).not_to have_facet_field('language').with_value('Unknown')
    end
  end

  context "expected values in the author person facet", :jira => 'VUF-138' do
    it "war and peace should have tolstoy" do
      resp = solr_response({'q' => 'war and peace', 'fl'=>'id', 'facet.field'=>'author_person_facet'})
      expect(resp).to have_facet_field('author_person_facet').with_value('Tolstoy, Leo, graf, 1828-1910')
    end
    it "evolution should have darwin" do
      resp = solr_response({'q' => 'evolution', 'fl'=>'id', 'facet.field'=>'author_person_facet'})
      expect(resp).to have_facet_field('author_person_facet').with_value('Darwin, Charles, 1809-1882')
    end
    it "civil disobedience should have thoreau" do
      resp = solr_response({'q' => 'civil disobedience', 'fl'=>'id', 'facet.field'=>'author_person_facet'})
      expect(resp).to have_facet_field('author_person_facet').with_value('Thoreau, Henry David, 1817-1862')
    end
  end

  context "expected values in the author person facet", :jira => 'VUF-138' do
    it "war and peace should have tolstoy" do
      resp = solr_response({'q' => 'war and peace', 'fl'=>'id', 'facet.field'=>'author_person_facet'})
      expect(resp).to have_facet_field('author_person_facet').with_value('Tolstoy, Leo, graf, 1828-1910')
    end
    it "evolution should have darwin" do
      resp = solr_response({'q' => 'evolution', 'fl'=>'id', 'facet.field'=>'author_person_facet'})
      expect(resp).to have_facet_field('author_person_facet').with_value('Darwin, Charles, 1809-1882')
    end
    it "civil disobedience should have thoreau" do
      resp = solr_response({'q' => 'civil disobedience', 'fl'=>'id', 'facet.field'=>'author_person_facet'})
      expect(resp).to have_facet_field('author_person_facet').with_value('Thoreau, Henry David, 1817-1862')
    end
  end

  context 'expected results in the Stanford student work facet' do
    it 'Thesis/Dissertation results' do
      resp = solr_resp_doc_ids_only({'fq'=>['stanford_work_facet_hsim:"Thesis/Dissertation"']})
      expect(resp.size).to be >= 56_400
      expect(resp.size).to be <= 60_400
    end
    it 'Thesis/Dissertation|Bachelor\'s results' do
      resp = solr_resp_doc_ids_only({'fq'=>['stanford_work_facet_hsim:"Thesis/Dissertation|Bachelor\'s"']})
      expect(resp.size).to be >= 1600
      expect(resp.size).to be <= 1900
    end
    it 'Thesis/Dissertation|Master\'s results' do
      resp = solr_resp_doc_ids_only({'fq'=>['stanford_work_facet_hsim:"Thesis/Dissertation|Master\'s"']})
      expect(resp.size).to be >= 13_200
      expect(resp.size).to be <= 14_200
    end
    it 'Thesis/Dissertation|Doctoral results' do
      resp = solr_resp_doc_ids_only({'fq'=>['stanford_work_facet_hsim:"Thesis/Dissertation|Doctoral"']})
      expect(resp.size).to be >= 42_000
      expect(resp.size).to be <= 44_000
    end
    it 'Other student work results' do
      resp = solr_resp_doc_ids_only({'fq'=>['stanford_work_facet_hsim:"Other student work"']})
      expect(resp.size).to be >= 670
      expect(resp.size).to be <= 875
    end
  end

end
