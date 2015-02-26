require 'spec_helper'

describe "Default Request Handler" do
  
  it "q of 'Buddhism' should get 8,500-10,700 results", :jira => 'VUF-160' do
    resp = solr_resp_ids_from_query 'Buddhism'
    resp.should have_at_least(10000).documents
    resp.should have_at_most(11100).documents
  end
  
  it "q of 'String quartets Parts' and variants should be plausible", :jira => 'VUF-390' do
    resp = solr_resp_ids_from_query 'String quartets Parts'
    resp.should have_at_least(2000).documents
    resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('(String quartets Parts)'))
    resp.should have_more_results_than(solr_resp_ids_from_query('"String quartets Parts"'))
  end
  
  it "q of 'french beans food scares' should get specific match and non-match" do
    resp = solr_resp_ids_from_query 'french beans food scares'
    resp.should include("7716344").as_first_result
    resp.should_not include("69555562")
  end
  
  it "matches in title should sort first - waffle" do
    resp = solr_resp_ids_from_query 'waffle'
    resp.should include("6720427").as_first_result
    resp.should include("6720427").before("7763651")
    resp.should include("4535360").before("7763651")
    resp.should include("2716658").before("6546657")
    resp.should include("5087572").before("6546657")
  end
  
  it "matches in title should sort first - memoirs of a physician", :jira => 'VUF-325' do
    resp = solr_resp_ids_titles_from_query 'memoirs of a physician'
    resp.should include("title_245a_display" => /memoirs of a physician/i).in_each_of_first(2).documents
  end

  it "like titles should appear together in result", :jira => 'VUF-93' do
    resp = solr_resp_ids_from_query 'wanderlust'
    resp.should include(['6974167', '5757985', '1630776', '4364566', '4406971']).in_first(10)
#    FIXME: need include().within().of() in rspec-solr
#    resp.should include('6974167').within(2).of('5757985')
#    resp.should include('5757985').within(2).of('1630776')
#    resp.should include('4364566').within(1).of('4406971')
  end

  it "single result expected: 'jill kerr conway' " do
    resp = solr_resp_ids_from_query 'jill kerr conway'
    resp.should have_at_most(3).results
    resp.should include("4735430").as_first_result
    resp2 = solr_resp_doc_ids_only({'q'=>'jill k. conway'})
    resp.should have_fewer_results_than(resp2)
  end
  
  it "single character as term: 'jill k conway' " do
    resp = solr_resp_ids_from_query 'jill k. conway'
    resp.should include("4735430")
    resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('jill k conway'))
    resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('k conway jill'))
  end
  
  it "history of the jews by paul johnson", :jira => 'VUF-510' do
    resp = solr_resp_ids_from_query 'history of the jews by paul johnson'
    resp.should include(["1665541", "3141358"]).in_first(3).results
  end

  it "'call of the wild'", :jira => 'VUF-171' do
    resp = solr_resp_ids_titles({'q'=>'call of the wild', 'rows'=>'30'})
    resp.should include('title_245a_display' => /call of the wild/i).in_each_of_first(15).documents
    # below have it in 245a
    resp.should include(['6635999', '2472361', '3240949', '3431568', '4410827',
                        '6763852', '3066683', '3440375', '2228310', '7823673', 
                        '5684390', '573747', '573745', '573746', '675590', 
                        '711112', '1363337', '2184693', '1004499']).in_first(30).documents
  end

  it "searches should not be case sensitive" do
    resp = solr_resp_ids_from_query 'harry potter'
    resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('Harry Potter'))
    resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('Harry potter'))
    resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('harry Potter'))
    resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('hArRy pOTTEr'))
  end

  context "world atlas of sea grasses", :jira => 'VUF-2451' do
    it "world atlas of sea grasses", :fixme => true do
      # because it's 'seagrasses' not 'sea grasses'
      resp = solr_resp_ids_from_query 'world atlas of sea grasses'
      resp.should include('5454691').as_first
      resp.should include('4815882')
    end
    it "world atlas of seagrasses" do
      resp = solr_resp_ids_from_query 'world atlas of seagrasses'
      resp.should include('5454691').as_first
      resp.should include('4815882')
    end    
  end
  
  it "exact match in 245a should be first results: 'search'", :jira => ['VUF-212', 'SW-64'] do
    #  There are two records:  4216963, 4216961  that have the word "search" in the 245, 
    # and also have the word "search" in the 880 vernacular 245 field. 
    # Because the term appears twice:  in the 245a and the corresponding 880a, 
    #   these records have been appearing first.
    resp = solr_resp_ids_from_query 'search'
    match_245a = ['8833422', '394764', '6785774', '2641095', '3335969', '9666416', '457493', '7547799', '1656104', '9218024']
    resp.should include(match_245a).before("4216963") # has 880 245a with search
    resp.should include(match_245a).before("4216961") # has 880 245a with search
  end

  it "Lectures on the Calculus of Variations and Optimal Control Theory", :jira => 'VUF-1995' do
    resp = solr_resp_ids_titles_from_query 'Lectures on the Calculus of Variations and Optimal Control Theory'
    resp.should include('560042').as_first
    resp.should_not include("title_245a_display" => /Shape optimization and optimal design/i)
    resp.should have_at_most(250).results
  end

  it "death and taxes", :jira => 'SW-721' do
    resp = solr_resp_ids_titles_from_query 'death and taxes'
    resp.should include('title_245a_display' => /^death and taxes$/i).in_each_of_first(5)
  end
  
  it "way we never were", :jira => 'VUF-311' do
    resp = solr_resp_ids_titles_from_query 'way we never were'
    resp.should include('title_245a_display' => /way we never were/i).as_first
  end
  
  it "united states code", :jira => 'VUF-2060' do
    resp = solr_resp_ids_titles_from_query 'united states code'
    resp.should include('5599841').as_first
    resp.should include("title_245a_display" => /^united states code$/i).in_each_of_first(4)
    resp.should include('2852709').in_first(4)
  end
  
  it "zeitschrift", :jira => 'VUF-511' do
    resp = solr_resp_ids_titles_from_query 'Zeitschrift'
    resp.should include(['4443145', '486819']).in_first(10) # has 245a of Zeitschrift
    resp.should include('title_245a_display' => /^zeitschrift$/i).in_each_of_first(15)
    resp.should have_at_least(4000).results
  end
  
  context "first chalk talk, July 21, 2011", :jira => 'VUF-1787' do
    # really from https://consul.stanford.edu/display/NGDE/SearchWorks+201+Backnoise+chatter
    it "vitamin A" do
      # 64
      resp = solr_resp_ids_titles_from_query 'Vitamin A'
      resp.should have_at_least(800).results
      resp.should include('title_245a_display' => /^vitamin a\.?$/i).in_each_of_first(3)
      resp.should include('title_245a_display' => /vitamin a/i).in_each_of_first(20)
    end
    it "humanities 21st century america english" do
      # 70
      resp = solr_resp_ids_from_query('humanities 21st century america english')
      resp.should have_at_most(30).results
    end
  end
  
  it "happiness, a history", :jira => 'VUF-1065' do
    resp = solr_resp_ids_from_query 'happiness a history'
    resp.should include(['6549586', '8446470']).in_first(3)
  end
  
  it "should allow barcode searches", :jira => 'SW-682' do
    resp = solr_resp_ids_from_query '36105041286266'
    resp.should include('2029735').as_first
    resp.should have_at_most(3).results
  end
  
  it "the atomic" do
    resp = solr_resp_ids_titles_from_query 'the atomic'
    resp.should have_at_least(12000).results
    resp.should include('title_245a_display' => /the atomic/i).in_each_of_first(20).documents
#    resp.should include('title_245a_display' => /^the atomic/i).in_each_of_first(20).documents  # works with Solr 3.6 dismax
  end

  it "atomic bomb" do
    resp = solr_resp_ids_titles_from_query 'atomic bomb'
    resp.should have_at_least(2000).results
    resp.should include('title_245a_display' => /atomic bomb/i).in_each_of_first(20).documents
    resp.should include('title_245a_display' => /^atomic bomb$/i).in_each_of_first(2).documents
  end

  it "the atomic bomb" do
    resp = solr_resp_ids_titles_from_query 'the atomic bomb'
    resp.should have_at_least(1325).results
    resp.should include('title_245a_display' => /the atomic bomb/i).in_each_of_first(20).documents
    resp.should include('title_245a_display' => /^the atomic bomb$/i).in_each_of_first(3).documents
    resp.should include('title_245a_display' => /^the atomic bomb/i).in_each_of_first(10).documents
  end
  
  it "price of sex" do
    resp = solr_resp_ids_from_query 'price of sex'
    resp.should include('9381468').as_first
    resp.should have_at_least(450).results
  end
  
  it "on the road" do
    resp = solr_resp_ids_titles_from_query 'on the road'
    resp.should have_at_least(16500).results
    resp.should include('title_245a_display' => /^on the road\W*$/i).in_each_of_first(20).documents
  end
  
  it "war and peace" do
    resp = solr_resp_ids_titles_from_query 'war and peace'
    resp.should have_at_least(14250).results
    # FIXME:  this is a lame fix
    # See INDEX-150;  true solution may be to demote 880 version of 245 a bit, and/or boost title_exact higher
    #resp.should include('title_245a_display' => /^war and peace$/i).in_each_of_first(20).documents
    resp.should include('title_245a_display' => /^(in )?war and peace$/i).in_each_of_first(20).documents
  end
  
  it "history of cartography" do
    resp = solr_resp_ids_titles_from_query 'history of cartography'
    resp.should have_at_least(1600).results
    resp.should include('title_245a_display' => /^history of cartography$/i).in_each_of_first(4).documents
    resp.should include('title_245a_display' => /^(the )?history of cartography$/i).in_each_of_first(5).documents
  end

end