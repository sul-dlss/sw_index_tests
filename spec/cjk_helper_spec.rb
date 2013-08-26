# encoding: utf-8
require 'spec_helper'

describe "CJK Helper", :chinese => true, :fixme => true do
  
  context "diff CJK scripts" do
    it "should return false when there are no CJK chars" do
      cjk_bigram_tokens('no cjk').should == nil
    end
    it "should detect Han - Traditional" do
      cjk_bigram_tokens('舊小說').should > 0
    end
    it "should detect Han - Simplified" do
      cjk_bigram_tokens('旧小说').should > 0
    end
    it "should detect Modern Kanji" do
      cjk_bigram_tokens('漫画').should > 0
    end
    it "should detect Traditional Kanji" do
      cjk_bigram_tokens('漫畫').should > 0
    end
    it "should detect Hiragana" do
      cjk_bigram_tokens("まんが").should > 0
    end
    it "should detect Katakana" do
      cjk_bigram_tokens("マンガ").should > 0
    end
    it "should detect Hancha traditional" do
      cjk_bigram_tokens("廣州").should > 0
    end
    it "should detect Hancha simplified" do
      cjk_bigram_tokens("光州").should > 0
    end
    it "should detect Hangul" do
      cjk_bigram_tokens("한국경제").should > 0
    end
    it "should detect mixed scripts" do
      cjk_bigram_tokens("近世仮名遣い").should > 0
    end
    
    context "mixed with non-CJK scripts" do
      it "should detect first character CJK" do
        cjk_bigram_tokens("舊小說abc").should > 0
        cjk_bigram_tokens("旧小说 abc").should > 0
        cjk_bigram_tokens(" 漫画 abc").should > 0
      end
      it "should detect last character CJK" do
        cjk_bigram_tokens("abc漫畫").should > 0
        cjk_bigram_tokens("abc まんが").should > 0
        cjk_bigram_tokens("abc マンガ ").should > 0
      end
      it "should detect (latin)(CJK)(latin)" do
        cjk_bigram_tokens("abc廣州abc").should > 0
        cjk_bigram_tokens("abc 한국경제abc").should > 0
        cjk_bigram_tokens("abc近世仮名遣い abc").should > 0
        cjk_bigram_tokens("abc 近世仮名遣い abc").should > 0
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
      it "2 chars, no whitespace" do
        cjk_bigram_tokens('董桥').should == 3
      end
      it "3 chars, no whitespace" do
        cjk_bigram_tokens('红楼梦').should == 5
        cjk_bigram_tokens('舊小說').should == 5
        cjk_bigram_tokens('マンガ').should == 5
      end
      it "4 chars, no whitespace" do
        cjk_bigram_tokens('历史研究').should == 7
      end
      it "5 chars, no whitespace" do
        cjk_bigram_tokens('けいちゅう').should == 9
        cjk_bigram_tokens('妇女与婚姻').should == 9
      end
      it "6 chars, no whitespace" do
        cjk_bigram_tokens('한국주택은행').should == 11
        cjk_bigram_tokens('近世仮名遣い').should == 11
      end
      it "7 chars, no whitespace" do
        cjk_bigram_tokens('中国地方志集成').should == 13
      end
      context "assorted grams and whitespace" do
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
        cjk_bigram_tokens("abc 光 ").should == 2
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
          cjk_bigram_tokens("abc 董桥 ").should == 4
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
    context "should not send in a Solr mm param if only 1 or 2 CJK chars" do
      it "1 CJK char" do
        cjk_mm_ps_params("飘").should == {}
      end
      it "2 CJK (adj) char" do
        cjk_mm_ps_params("三國").should == {}
      end
      context "mixed with non-CJK scripts" do
#FIXME:  what about ps???
        context "bigram" do
          it "first CJK" do
            cjk_mm_ps_params("董桥abc").should == {}
            cjk_mm_ps_params("董桥 abc").should == {}
            cjk_mm_ps_params(" 董桥 abc").should == {}
          end
          it "last CJK" do
            cjk_mm_ps_params("abc董桥").should == {}
            cjk_mm_ps_params("abc 董桥").should == {}
            cjk_mm_ps_params("abc 董桥 ").should == {}
          end
          it "(latin)(CJK)(latin)" do
            cjk_mm_ps_params("abc董桥abc").should == {}
            cjk_mm_ps_params("abc 董桥abc").should == {}
            cjk_mm_ps_params("abc董桥 abc").should == {}
            cjk_mm_ps_params("abc 董桥 abc").should == {}
          end
        end
      end # mixed      
    end

    context "only CJK chars in query" do
      it "3 CJK (adj) char: mm=cjk_mm_val, ps=cjk_ps_val" do
        cjk_mm_ps_params("マンガ").should == {'mm'=>cjk_mm_val, 'ps'=>cjk_ps_val}
      end
      it "4 CJK (adj) char: mm=cjk_mm_val, ps=cjk_ps_val" do
        cjk_mm_ps_params("历史研究").should == {'mm'=>cjk_mm_val, 'ps'=>cjk_ps_val}
      end
      it "5 CJK (adj) char: mm=cjk_mm_val, ps=cjk_ps_val" do
        cjk_mm_ps_params("妇女与婚姻").should == {'mm'=>cjk_mm_val, 'ps'=>cjk_ps_val}
      end
      it "6 CJK (adj) char: mm=cjk_mm_val, ps=cjk_ps_val" do
        cjk_mm_ps_params("한국주택은행").should == {'mm'=>cjk_mm_val, 'ps'=>cjk_ps_val}
      end
      it "7 CJK (adj) char: mm=cjk_mm_val, ps=cjk_ps_val" do
        cjk_mm_ps_params("中国地方志集成").should == {'mm'=>cjk_mm_val, 'ps'=>cjk_ps_val}
      end
    end
    
    context "mixed with non-CJK scripts" do
      context "bigram" do
        it "first CJK" do
          pending
          cjk_mm_ps_params("マンガabc").should == {'mm'=>cjk_mm_val, 'ps'=>cjk_ps_val}
          cjk_mm_ps_params("マンガ abc").should == {'mm'=>cjk_mm_val, 'ps'=>cjk_ps_val}
          cjk_mm_ps_params(" マンガ abc").should == {'mm'=>cjk_mm_val, 'ps'=>cjk_ps_val}
        end
        it "last CJK" do
          pending
          cjk_mm_ps_params("abcマンガ").should == {'mm'=>cjk_mm_val, 'ps'=>cjk_ps_val}
          cjk_mm_ps_params("abc マンガ").should == {'mm'=>cjk_mm_val, 'ps'=>cjk_ps_val}
          cjk_mm_ps_params("abc マンガ ").should == {'mm'=>cjk_mm_val, 'ps'=>cjk_ps_val}
        end
        it "(latin)(CJK)(latin)" do
          pending
          cjk_mm_ps_params("abcマンガabc").should == {'mm'=>cjk_mm_val, 'ps'=>cjk_ps_val}
          cjk_mm_ps_params("abc マンガabc").should == {'mm'=>cjk_mm_val, 'ps'=>cjk_ps_val}
          cjk_mm_ps_params("abcマンガ abc").should == {'mm'=>cjk_mm_val, 'ps'=>cjk_ps_val}
          cjk_mm_ps_params("abc マンガ abc").should == {'mm'=>cjk_mm_val, 'ps'=>cjk_ps_val}
        end
      end
    end # mixed      
  end # mm and ps params

end
