# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'rspec-solr'

describe "Japanese Overview", :japanese => true, :fixme => true do
  
  shared_examples_for "expected result size" do | query, query_type, num_exp |
    it "should have #{num_exp} results" do
      case query_type
        when 'title'
          resp = solr_resp_doc_ids_only({'q' => cjk_title_q_arg(query)})
        when 'author'
          resp = solr_resp_doc_ids_only({'q' => cjk_author_q_arg(query)})
        else
          resp = solr_resp_doc_ids_only({'q' => cjk_everything_q_arg(query)})
      end
      resp.should have_exactly(num_exp).results
    end
  end

  shared_examples_for "queries get same result size" do | query1, query2, query_type |
    it "both #{query_type} queries should get same result size" do
      case query_type
        when 'title'
          resp1 = solr_resp_doc_ids_only({'q' => cjk_title_q_arg(query1)})
          resp2 = solr_resp_doc_ids_only({'q' => cjk_title_q_arg(query2)})
        when 'author'
          resp1 = solr_resp_doc_ids_only({'q' => cjk_author_q_arg(query1)})
          resp2 = solr_resp_doc_ids_only({'q' => cjk_author_q_arg(query2)})
        else
          resp1 = solr_resp_doc_ids_only({'q' => cjk_everything_q_arg(query1)})
          resp2 = solr_resp_doc_ids_only({'q' => cjk_everything_q_arg(query2)})
      end
      resp1.should have_the_same_number_of_results_as resp2
    end
  end
  
  shared_examples_for "both scripts get expected result size" do | script_name1, query1, script_name2, query2, query_type, num_exp |
    it_behaves_like "queries get same result size", query1, query2, query_type
    context "#{script_name1}: #{query1}" do
      it_behaves_like "expected result size", query1, query_type, num_exp
    end
    context "#{script_name2}: #{query2}" do
      it_behaves_like "expected result size", query2, query_type, num_exp
    end
  end

  #--- end shared examples

  context "title searches" do
    context "Buddhism" do
      it_behaves_like "both scripts get expected result size", 'modern', ' 仏教学', 'traditional', '佛教學', 'title', 19
    end
    context "comics/manga" do
      it_behaves_like "both scripts get expected result size", 'hiragana', 'まんが', 'katakana', 'マンガ', 'title', 140      
      it_behaves_like "both scripts get expected result size", 'modern', ' 漫画', 'traditional', '漫畫', 'title', 237
    end
    context "sports  スポーツ (katakana)" do
      it_behaves_like "expected result size", 'スポーツ', 'title', 34
    end
    context "mixed script (modern pseudonym usage: 近世仮名遣い)" do
      it_behaves_like "expected result size", '近世仮名遣い', 'title', 1
    end
  end

  context "author searches" do
    context "South Manchurian Railroad Company" do
      it_behaves_like "both scripts get expected result size", 'modern', ' 南満州鉄道株式会社', 'traditional', '南滿洲鐵道株式會社', 'author', 522
    end
    context "personal name  契沖" do
      it_behaves_like "both scripts get expected result size", 'kanji', '契沖', 'hiragana', 'けいちゅう', 'author', 5
    end
    context "kanji  釘貫 (surname of 釘貫亨)" do
      it_behaves_like "expected result size", '釘貫', 'author', 1
    end
  end
  

end