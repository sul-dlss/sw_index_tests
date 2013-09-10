# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Korean Overview", :korean => true, :fixme => true do
  
  shared_examples_for "expected result size" do | query_type, query, min, max, solr_params |
    it "#{query_type} search has #{(min == max ? min : "between #{min} and #{max}")} results" do
      resp = cjk_query_resp_ids(query_type, query, solr_params ||= {})
      if min == max
        resp.should have_exactly(min).results
      else
        resp.should have_at_least(min).results
        resp.should have_at_most(max).results
      end
    end
  end

  shared_examples_for "search results are same size" do | query_type, query1, query2, solr_params |
    it "both #{query_type} searches have same result size" do
      resp1 = cjk_query_resp_ids(query_type, query1, solr_params ||= {})
      resp2 = cjk_query_resp_ids(query_type, query2, solr_params ||= {})
      resp1.should have_the_same_number_of_results_as resp2
    end
  end
  
  shared_examples_for "both scripts get expected result size" do | query_type, script_name1, query1, script_name2, query2, min, max, solr_params |
    it_behaves_like "search results are same size", query_type, query1, query2, solr_params
    context "#{script_name1}: #{query1}" do
      it_behaves_like "expected result size", query_type, query1, min, max, solr_params
    end
    context "#{script_name2}: #{query2}" do
      it_behaves_like "expected result size", query_type, query2, min, max, solr_params
    end
  end
  
  shared_examples_for "best matches first" do | query_type, query, id_list, num, solr_params |
    it "finds #{id_list.inspect} in first #{num} results" do
      resp = cjk_query_resp_ids(query_type, query, solr_params ||= {})
      resp.should include(id_list).in_first(num).results
    end
  end
  shared_examples_for "matches in short titles first" do | query_type, query, regex, num, solr_params |
    it "finds #{regex} in first #{num} titles" do
      solr_params ||= {}
      solr_params.merge!('rows'=>num) if num > 20
      resp = solr_response({'q' => cjk_q_arg(query_type, query), 'fl'=>'id,vern_title_245a_display', 'facet'=>false}.merge(solr_params))
      resp.should include({'vern_title_245a_display' => regex}).in_each_of_first(num)
    end
  end
  shared_examples_for "matches in titles first" do | query_type, query, regex, num, solr_params |
    it "finds #{regex} in first #{num} titles" do
      solr_params ||= {}
      solr_params.merge!('rows'=>num) if num > 20
      resp = solr_response({'q' => cjk_q_arg(query_type, query), 'fl'=>'id,vern_title_full_display', 'facet'=>false}.merge(solr_params))
      resp.should include({'vern_title_full_display' => regex}).in_each_of_first(num)
    end
  end
  shared_examples_for "matches in titles" do | query_type, query, regex, num, solr_params |
    it "finds #{regex} in titles" do
      solr_params ||= {}
      solr_params.merge!('rows'=>num) if num > 20
      resp = solr_response({'q' => cjk_q_arg(query_type, query), 'fl'=>'id,vern_title_full_display', 'facet'=>false}.merge(solr_params))
      resp.should include({'vern_title_full_display' => regex})
    end
  end
  

  #--- end shared examples ---------------------------------------------------

  lang_limit = {'fq'=>'language:Korean'}
  context "title searches" do
    context "Korea-U.S. alliance relations in the 21st century", :jira => 'VUF-2747' do
      # 21세기의   한미동맹관계  most likely spacing by the koreans
      # 21세기의   한•미동맹관계  as written in the book
      # 21세기   의   한,   미   동맹   관계    what's in our record
# FIXME:  move these to phrase searching?
      context "phrase searching" do
        context '"21세기의한미동맹관계"' do
          it_behaves_like "expected result size", 'title', '"21세기의한미동맹관계"', 1, 1
          it_behaves_like "best matches first", 'title', '"21세기의한미동맹관계"', '8375648', 1
        end
        context '"21세기의  한미동맹관계"' do
          it_behaves_like "expected result size", 'title', '"21세기의  한미동맹관계"', 1, 1
          it_behaves_like "best matches first", 'title', '"21세기의  한미동맹관계"', '8375648', 1
        end
      end
    end
  end # title searches


  context "author searches" do
  end # author searches
  
  context "everything searches" do
  end # everything searches
  
  context "phrases" do
  end  # phrases
  
  context "mixed scripts" do
  end # mixed scripts

end