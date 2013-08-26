# encoding: utf-8
require 'spec_helper'

describe "CJK Helper", :chinese => true, :fixme => true do
  
  context "diff CJK scripts" do
    it "should return false when there are no CJK chars" do
      cjk_bigram_tokens('no cjk').should == nil
    end
    it "should detect Han - Traditional" do
      cjk_bigram_tokens('舊小說').should == 5
    end
    it "should detect Han - Simplified" do
      cjk_bigram_tokens('旧小说').should == 5
    end
    it "should detect Modern Kanji" do
      cjk_bigram_tokens('漫画').should == 3
    end
    it "should detect Traditional Kanji" do
      cjk_bigram_tokens('漫畫').should == 3
    end
    it "should detect Hiragana" do
      cjk_bigram_tokens("まんが").should == 5
    end
    it "should detect Katakana" do
      cjk_bigram_tokens("マンガ").should == 5
    end
    it "should detect Hancha traditional" do
      cjk_bigram_tokens("廣州").should == 3
    end
    it "should detect Hancha simplified" do
      cjk_bigram_tokens("光州").should == 3
    end
    it "should detect Hangul" do
      cjk_bigram_tokens("한국경제").should == 7
    end
    
    context "mixed with non-CJK scripts" do
      it "should detect first character CJK" do
        cjk_bigram_tokens("光abc").should == 2
        cjk_bigram_tokens("光 abc").should == 2
        cjk_bigram_tokens(" 光 abc").should == 2
      end
      it "should detect last character CJK" do
        cjk_bigram_tokens("abc光").should == 2
        cjk_bigram_tokens("abc 光").should == 2
        cjk_bigram_tokens("abc 光").should == 2
      end
      it "should detect (latin)(CJK)(latin)" do
        cjk_bigram_tokens("abc光abc").should == 3
      end
    end # mixed
  end # detecting CJK chars
  
  context "counting CJK chars" do
    context "CJK only" do
      it "single unigram" do
        cjk_bigram_tokens('飘').should == 1
      end
      it "multiple space separated unigrams" do
        cjk_bigram_tokens('金  瓶 梅').should == 3
      end
      it "repeated unigram should be counted twice" do
        cjk_bigram_tokens('金 瓶 梅  金').should == 4
      end
      it "single bigram" do
        cjk_bigram_tokens('三國').should == 3
      end
=begin      
      it "two bigrams" do
        cjk_bigram_tokens('妇女  婚姻').should == 6
      end
      it "bigram + unigram" do
        cjk_bigram_tokens('三國  誌').should == 4
        cjk_bigram_tokens('三 國誌').should == 4
      end
      it "trigram" do
        cjk_bigram_tokens('三國誌').should == 5
      end
      it "two trigrams" do
        cjk_bigram_tokens('三國誌 マンガ').should == 10
      end
=end
      it "2 chars, no whitespace" do
        cjk_bigram_tokens('董桥').should == 3
      end
      it "3 chars, no whitespace" do
        cjk_bigram_tokens('红楼梦').should == 5
      end
      it "4 chars, no whitespace" do
        cjk_bigram_tokens('历史研究').should == 7
      end
      it "5 chars, no whitespace" do
        cjk_bigram_tokens('けいちゅう').should == 9
      end
      it "6 chars, no whitespace" do
        cjk_bigram_tokens('한국주택은행').should == 11
      end
      it "7 chars, no whitespace" do
        cjk_bigram_tokens('中国地方志集成').should == 13
      end
      it "assorted grams and whitespace" do
#        cjk_bigram_tokens('').should == 
#        cjk_bigram_tokens('').should == 
#        cjk_bigram_tokens('').should == 
        pending
      end
      it "should get the correct count for single token of consecutive characters" do
        cjk_bigram_tokens('舊小說').should == 3
        cjk_bigram_tokens('妇女与婚姻').should == 5
        cjk_bigram_tokens('マンガ').should == 3
        cjk_bigram_tokens('近世仮名遣い').should == 6
      end
    end # CJK only

    context "mixed with non-CJK scripts" do
      it "first character CJK" do
        cjk_bigram_tokens("光abc").should == 2
        cjk_bigram_tokens("光 abc").should == 2
        cjk_bigram_tokens(" 光 abc").should == 2
      end
      it "last character CJK" do
        cjk_bigram_tokens("abc光").should == 2
        cjk_bigram_tokens("abc 光").should == 2
        cjk_bigram_tokens("abc 光").should == 2
      end
      it "(latin)(CJK)(latin)" do
        cjk_bigram_tokens("abc光abc").should == 3
      end
      context "bigram" do
        it "first CJK" do
          cjk_bigram_tokens("董桥abc").should == 4
          cjk_bigram_tokens("董桥 abc").should == 4
          cjk_bigram_tokens(" 董桥 abc").should == 4
        end
        it "last CJK" do
          cjk_bigram_tokens("abc董桥").should == 4
          cjk_bigram_tokens("abc 董桥").should == 4
          cjk_bigram_tokens("abc 董桥").should == 4
        end
        it "(latin)(CJK)(latin)" do
          cjk_bigram_tokens("abc董桥abc").should == 5
          cjk_bigram_tokens("abc 董桥abc").should == 5
          cjk_bigram_tokens("abc董桥 abc").should == 5
          cjk_bigram_tokens("abc 董桥 abc").should == 5
        end
      end
    end  # mixed    
  end # counting CJK chars
    
  
  context "Solr mm and ps parameters" do
    it "should not send in a Solr mm param if only 1 or 2 CJK chars" do
      pending "to be implemented"
    end
    context "only CJK chars in query" do
      it "1 CJK char:  mm=1, ps=0" do
        pending "to be implemented"
      end
      it "2 CJK (adj) char:  mm=3, ps=0" do
        pending "to be implemented"
      end
      it "3 CJK (adj) char:  mm=4, ps=fixme" do
        pending "to be implemented"
      end
      it "4 CJK (adj) char:  mm=6, ps=fixme" do
        pending "to be implemented"
      end
      it "5 CJK (adj) char: mm=7, ps=fixme" do
        pending "to be implemented"
      end
      it "6 CJK (adj) char: mm=9, ps=fixme" do
        pending "to be implemented"
      end
      it "7 CJK (adj) char: mm=10?, ps=fixme" do
        pending "to be implemented"
      end
    end
    context "mixed with non-CJK scripts" do
      context "bigram" do
        it "first CJK" do
          pending
          cjk_bigram_tokens("董桥abc").should == 4
          cjk_bigram_tokens("董桥 abc").should == 4
          cjk_bigram_tokens(" 董桥 abc").should == 4
        end
        it "last CJK" do
          pending
          cjk_bigram_tokens("abc董桥").should == 4
          cjk_bigram_tokens("abc 董桥").should == 4
          cjk_bigram_tokens("abc 董桥").should == 4
        end
        it "(latin)(CJK)(latin)" do
          pending
          cjk_bigram_tokens("abc董桥abc").should == 5
          cjk_bigram_tokens("abc 董桥abc").should == 5
          cjk_bigram_tokens("abc董桥 abc").should == 5
          cjk_bigram_tokens("abc 董桥 abc").should == 5
        end
      end
    end # mixed      
  end # mm and ps params

end
