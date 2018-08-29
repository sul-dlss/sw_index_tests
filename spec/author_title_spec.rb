describe "Author-Title Search" do

  it "Steinbeck Pearl", :jira => 'SW-778' do
    q = '"Steinbeck, John, 1902-1968. Pearl"'
    resp = solr_response(author_title_search_args(q).merge!({'fl'=>'id,author_person_display', 'facet'=>false}))
    expect(resp.size).to be >= 90
    expect(resp.size).to be <= 120
    expect(resp).to include("author_person_display" => /Steinbeck/i).in_each_of_first(20).documents
    expect(resp).not_to include("author_person_display" => /Yong/i).in_each_of_first(20).documents
  end

  it "Beethoven violin concerto", :jira => 'SW-778' do
    q = '"Beethoven, Ludwig van, 1770-1827. Concertos, violin, orchestra, op. 61, D major"'
    resp = solr_response(author_title_search_args(q).merge!({'fl'=>'id,author_person_display', 'facet'=>false}))
    expect(resp.size).to be >= 295
    expect(resp.size).to be <= 325
    expect(resp).to include("author_person_display" => /Beethoven/i).in_each_of_first(5).documents
    expect(resp).not_to include("author_person_display" => /Stowell/i).in_each_of_first(20).documents
  end

  it "Schiller, Friedrich, 1759-1805. An die Freude", :jira => ['SW-138', 'SW-387'] do
    q = '"Schiller, Friedrich, 1759-1805. An die Freude"'
    resp = solr_response(author_title_search_args(q).merge!({'fl'=>'id,author_person_display', 'facet'=>false}))
    expect(resp.size).to be >= 10
    expect(resp).to include('7630767','10360578')
    expect(resp.size).to be <= 20
  end

  it "Schiller, Friedrich, 1759-1805. An die Freude English & German", :jira => ['SW-138', 'SW-387'] do
    q = '"Schiller, Friedrich, 1759-1805. An die Freude" English & German'
    resp = solr_response(author_title_search_args(q).merge!({'fl'=>'id,author_person_display', 'facet'=>false}))
    expect(resp).to include('7630767')
    expect(resp.size).to be <= 3
    expect(resp).to include("author_person_display" => /Beethoven/i).in_each_of_first(5).documents
  end

  it "Beethoven Ludwig van, 1770-1827. an die ferne geliebte", :jira => ['VUF-937', 'VUF-939', 'VUF-941'] do
    q = "Beethoven Ludwig van, 1770-1827. an die ferne geliebte"
    resp = solr_response(author_title_search_args(q).merge!({'fl'=>'id,author_person_display,title_245a_display', 'facet'=>false}))
    expect(resp.size).to be >= 10
    expect(resp).to include(['285031', '6956285'])
    expect(resp.size).to be <= 50
    expect(resp).to include("author_person_display" => /Beethoven/i).in_each_of_first(5).documents
    expect(resp).to include("title_245a_display" => /an die ferne geliebte/i).in_each_of_first(5).documents
  end

  it "Beethoven symphony number 3", :jira => ['VUF-571', 'SW-387'] do
    q = '"Beethoven, Ludwig van, 1770-1827. Symphonies, no. 3, op. 55, E♭ major"; arranged'
    resp = solr_response(author_title_search_args(q).merge!({'fl'=>'id,author_person_display', 'facet'=>false}))
    expect(resp.size).to be >= 8
    expect(resp).to include('282546')
    expect(resp.size).to be <= 30
    expect(resp).to include("author_person_display" => /Beethoven/i).in_each_of_first(3).documents
  end

  it "Beethoven fidelio", :jira => ['SW-387', 'SW-138'] do
    q = '"Beethoven, Ludwig van, 1770-1827. Fidelio"'
    resp = solr_response(author_title_search_args(q).merge!({'fl'=>'id,author_person_display,title_245a_display', 'facet'=>false}))
    expect(resp.size).to be >= 450
    expect(resp.size).to be <= 500
    expect(resp).to include("author_person_display" => /Beethoven/i).in_each_of_first(20).documents
    expect(resp).to include("title_245a_display" => /fidelio/i).in_each_of_first(5).documents
  end

  it "Beethoven fidelio 1814", :jira => 'VUF-938' do
    q = '"Beethoven, Ludwig van, 1770-1827. Fidelio (1814)"'
    resp = solr_response(author_title_search_args(q).merge!({'fl'=>'id,author_person_display,title_245a_display', 'facet'=>false}))
    expect(resp.size).to be >= 275
    expect(resp.size).to be <= 325
    expect(resp).to include("author_person_display" => /Beethoven/i).in_each_of_first(20).documents
    expect(resp).to include("title_245a_display" => /fidelio/i).in_each_of_first(2).documents
  end

  it "Beethoven fidelio overture", :jira => 'SW-387' do
    q = '"Beethoven, Ludwig van, 1770-1827. Fidelio. overture"'
    resp = solr_response(author_title_search_args(q).merge!({'fl'=>'id,author_person_display,title_245a_display', 'facet'=>false}))
    expect(resp).to include(['9092360', '307203'])
    expect(resp.size).to be <= 10
    expect(resp).to include("author_person_display" => /Beethoven/i).in_each_of_first(2).documents
    expect(resp).to include("title_245a_display" => /fidelio overture/i).in_each_of_first(2).documents
  end

  it "Beethoven piano sonata no 14", :jira => 'VUF-155' do
    q = '"beethoven ludwig van 1770-1827 sonatas piano no. 14"' # op. 27, no. 2, C♯ minor;
    resp = solr_response(author_title_search_args(q).merge!({'fl'=>'id,author_person_display,title_245a_display', 'facet'=>false}))
    expect(resp.size).to be <= 400
    expect(resp).to include('11516420') # replaced 10791173 with more relevant record
#    resp.should include("author_person_display" => /Beethoven/i).in_each_of_first(6).documents
  end

  context "Shakespeare, William, 1564-1616. All's well that ends well.", :jira => ['SW-138', 'SW-476'] do
    it "Shakespeare, William, 1564-1616. All's well that ends well." do
      q = '"Shakespeare, William, 1564-1616. All\'s well that ends well."'
      resp = solr_response(author_title_search_args(q).merge!({'fl'=>'id,author_person_display,title_245a_display', 'rows'=>50, 'facet'=>false}))
      expect(resp.size).to be >= 30
      expect(resp.size).to be <= 50
      expect(resp).to include(['7899090', '5593990', '4537269'])
      expect(resp).to include('2179941')
      expect(resp).to include("author_person_display" => /Shakespeare/i).in_each_of_first(5).documents
      expect(resp).to include("title_245a_display" => /All's well,? that ends well/i).in_each_of_first(5).documents
    end
    it "Shakespeare, William, 1564-1616. All's well that ends well. English" do
      q = '"Shakespeare, William, 1564-1616. All\'s well that ends well." English'
      resp = solr_response(author_title_search_args(q).merge!({'fl'=>'id,author_person_display,title_245a_display', 'facet'=>false}))
      expect(resp).to include('2179941')
      expect(resp.size).to be <= 5
      expect(resp).to include("author_person_display" => /Shakespeare/i).in_each_of_first(5).documents
      expect(resp).to include("title_245a_display" => /All's well,? that ends well/i).in_each_of_first(5).documents
    end
    it "Shakespeare, William, 1564-1616. All's well that ends well. English 1963" do
      q = '"Shakespeare, William, 1564-1616. All\'s well that ends well." English 1963'
      resp = solr_response(author_title_search_args(q).merge!({'fl'=>'id,author_person_display,title_245a_display', 'facet'=>false}))
      expect(resp).to include('2179941')
      expect(resp.size).to be <= 5
      expect(resp).to include("author_person_display" => /Shakespeare/i).in_each_of_first(5).documents
      expect(resp).to include("title_245a_display" => /All's well,? that ends well/i).in_each_of_first(5).documents
    end
  end

end
