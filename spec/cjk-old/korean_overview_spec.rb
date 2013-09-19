# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Korean Overview", :korean => true, :fixme => true do
  
  lang_limit = {'fq'=>'language:Korean'}

  context "title searches" do
      context "phrase searching" do
        # see context phrases
      end
    end
  end # title searches


  context "author searches" do
  end # author searches
  
  context "everything searches" do
  end # everything searches
  
  context "phrases" do
    context "Korea's modern history", :jira => 'VUF-2722' do
      context '"“한국  근대사"' do
        it_behaves_like "expected result size", 'title', '"“한국  근대사"', 1, 1
        it_behaves_like "best matches first", 'title', '"“한국  근대사"', '8375648', 1
      end
    end
  end  # phrases
  
  context "mixed scripts" do
  end # mixed scripts

end