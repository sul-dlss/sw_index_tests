shared_examples_for "expected result size" do | query_type, query, min, max, solr_params |
  it "#{query_type} search has #{(min == max ? min : "between #{min} and #{max}")} results" do
    resp = cjk_query_resp_ids(query_type, query, solr_params ||= {})
    if min == max
      expect(resp.size).to eq(min)
    else
      expect(resp.size).to be >= min
      expect(resp.size).to be <= max
    end
  end
end

shared_examples_for "search results are same size" do | query_type, query1, query2, solr_params |
  it "both #{query_type} searches have same result size" do
    resp1 = cjk_query_resp_ids(query_type, query1, solr_params ||= {})
    resp2 = cjk_query_resp_ids(query_type, query2, solr_params ||= {})
    # Japanese analysis
    # pending :fixme unless resp1['response']['numFound'] == resp2['response']['numFound']
    expect(resp1).to have_the_same_number_of_results_as resp2
  end
end

shared_examples_for "both scripts get expected result size" do | query_type, script_name1, query1, script_name2, query2, min, max, solr_params |
  include_examples "search results are same size", query_type, query1, query2, solr_params
  include_examples "expected result size", query_type, query1, min, max, solr_params
  include_examples "expected result size", query_type, query2, min, max, solr_params
end

shared_examples_for "best matches first" do | query_type, query, id_list, num, solr_params |
  it "finds #{id_list.inspect} in first #{num} results" do
    resp = cjk_query_resp_ids(query_type, query, solr_params ||= {})
    expect(resp).to include(id_list).in_first(num).results
  end
end

shared_examples_for "good results for query" do | query_type, query, min, max, id_list, num, solr_params |
  include_examples "expected result size", query_type, query, min, max, solr_params
  include_examples "best matches first", query_type, query, id_list, num, solr_params
end

shared_examples_for "does not find irrelevant results" do | query_type, query, id_list, solr_params |
  it "does not find #{id_list.inspect} in results" do
    resp = cjk_query_resp_ids(query_type, query, solr_params ||= {})
    expect(resp).not_to include(id_list)
  end
end


shared_examples_for "matches in vern short titles first" do | query_type, query, regex, num, solr_params |
  it "finds #{regex} in first #{num} vern short titles" do
    solr_params ||= {}
    solr_params.merge!('rows'=>num) if num > 20
    resp = solr_response(cjk_query_args(query_type, query).merge({'fl'=>'id,vern_title_245a_display', 'facet'=>false}.merge(solr_params)))
    expect(resp).to include({'vern_title_245a_display' => regex}).in_each_of_first(num)
  end
end
shared_examples_for "result size and vern short title matches first" do | query_type, query, min, max, regex, num, solr_params |
  include_examples "expected result size", query_type, query, min, max, solr_params
  include_examples "matches in vern short titles first", query_type, query, regex, num, solr_params
end

shared_examples_for "matches in vern titles first" do | query_type, query, regex, num, solr_params |
  it "finds #{regex} in first #{num} vern titles" do
    solr_params ||= {}
    solr_params.merge!('rows'=>num) if num > 20
    resp = solr_response(cjk_query_args(query_type, query).merge({'fl'=>'id,vern_title_full_display', 'facet'=>false}.merge(solr_params)))
    expect(resp).to include({'vern_title_full_display' => regex}).in_each_of_first(num)
  end
end
shared_examples_for "result size and vern title matches first" do | query_type, query, min, max, regex, num, solr_params |
  include_examples "expected result size", query_type, query, min, max, solr_params
  include_examples "matches in vern titles first", query_type, query, regex, num, solr_params
end

shared_examples_for "matches in vern titles" do | query_type, query, regex, num, solr_params |
  it "finds #{regex} in vern titles" do
    solr_params ||= {}
    solr_params.merge!('rows'=>num) if num > 20
    resp = solr_response(cjk_query_args(query_type, query).merge({'fl'=>'id,vern_title_full_display', 'facet'=>false}.merge(solr_params)))
    expect(resp).to include({'vern_title_full_display' => regex})
  end
end

shared_examples_for "matches in vern person authors first" do | query_type, query, regex, num, solr_params |
  it "finds #{regex} in first #{num} vern person authors" do
    solr_params ||= {}
    solr_params.merge!('rows'=>num) if num > 20
    resp = solr_response(cjk_query_args(query_type, query).merge({'fl'=>'id,vern_author_person_display', 'facet'=>false}.merge(solr_params)))
    expect(resp).to include({'vern_author_person_display' => regex}).in_each_of_first(num)
  end
end
shared_examples_for "result size and vern person author matches first" do | query_type, query, min, max, regex, num, solr_params |
  include_examples "expected result size", query_type, query, min, max, solr_params
  include_examples "matches in vern person authors first", query_type, query, regex, num, solr_params
end

shared_examples_for "matches in vern corp authors first" do | query_type, query, regex, num, solr_params |
  it "finds #{regex} in first #{num} vern corp authors" do
    solr_params ||= {}
    solr_params.merge!('rows'=>num) if num > 20
    resp = solr_response(cjk_query_args(query_type, query).merge({'fl'=>'id,vern_author_corp_display', 'facet'=>false}.merge(solr_params)))
    expect(resp).to include({'vern_author_corp_display' => regex}).in_each_of_first(num)
  end
end
shared_examples_for "result size and vern corp author matches first" do | query_type, query, min, max, regex, num, solr_params |
  include_examples "expected result size", query_type, query, min, max, solr_params
  include_examples "matches in vern corp authors first", query_type, query, regex, num, solr_params
end

shared_examples_for "great search results for old fiction (Han)" do
  # old (simp)  旧   (trad)  舊
  # fiction (simp)  小说   (trad)  小說
  trad_245a = ['9262744', '6797638', '6695967']
  trad_245a_diff_order = ['6695904']
  trad_245ab = ['6699444']
  simp_245a = ['8834455']
  simp_245a_diff_order = ['4192734']  #  小说旧
  it "traditional char matches" do
    expect(resp).to include(trad_245a).before(trad_245a_diff_order + trad_245ab)
  end
  it "simplified char matches" do
    expect(resp).to include(simp_245a).before(simp_245a_diff_order)
  end
  it "adjacent words in 245a" do
    expect(resp).to include(trad_245a + simp_245a).in_first(5).results
  end
  it "both words in 245a but not adjacent" do
    expect(resp).to include(trad_245a_diff_order + simp_245a_diff_order).in_first(8).results
  end
  it "one word in 245a and the other in 245b" do
    ab245 = ["6695904", # fiction 245a; old 245a
              "6699444", # old 245a; fiction 245b
              "6793760", # old (simplified) 245a; fiction 245b
            ]
    expect(resp).to include(ab245).in_first(12).results
  end
  it "other relevant results" do
    other = ["6288832"] # old 505t; fiction 505t x2
    expect(resp).to include(other)
  end
end # shared examples  great search results for old fiction (Han)

shared_examples_for "great search results for women and literature (Han)" do
  # 婦女與文學  traditional  婦女  與  文學
  #   女與   (BC chars)  has no meaning
  #   與文   (CD chars)  has no meaning on its own
  # 妇女与文学  simplified   妇女  与  文学
  trad_245a_exact = ['6343505', '8246653']
  trad_245a = ['8250645', '4724601', '6343719', '6343720'] # in 245a  (but other chars too)
  trad_addl_titles = ['8234101'] # found in the 505, but not together
  simp_245a_not_adjacent = ['7944106'] # women, and, lit in 245a, but char between women and and:  妇女观与文学
  simp_245a_diff_order = ['7833961', # lit then women in 245a, other chars between
                          '8802530', # lit then women in 245a, and in 245b'
                          ]
  simp_partial_245a = ['5930857'] # women in  245b, 246a, other 246a;  lit in 245b, 246a, other 246a; chars between
  it "traditional char matches" do
    expect(resp).to include(trad_245a_exact).before(trad_245a)
    expect(resp).to include(trad_245a).before(trad_addl_titles)
  end
  it "simplified char matches" do
    expect(resp).to include(simp_245a_not_adjacent + simp_245a_diff_order + simp_partial_245a)
  end
  it "exact match 245a" do
    expect(resp).to include(trad_245a_exact).in_first(trad_245a_exact.size).results
  end
  it "adjacent words in 245a" do
    expect(resp).to include(trad_245a).in_first(7).results
  end
  it "words in 245a but not adjacent" do
    expect(resp).to include(simp_245a_not_adjacent).in_first(15).results
  end
  it "words in 245a but diff order" do
    expect(resp).to include(simp_245a_diff_order).in_first(15).results
  end
  it "words in 245b or 246a" do
    expect(resp).to include(simp_partial_245a).in_first(15).results
  end
  it "addl title results" do
    expect(resp).to include(trad_addl_titles)
  end
  it "does not have irrelvant results", pending: 'fixme', skip: true do
    expect(resp).not_to include('6544163')
    expect(resp).not_to include('5539339')
  end
end # shared examples  great search results for women and literature (Han)
