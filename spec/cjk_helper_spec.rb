# encoding: utf-8
require 'spec_helper'

# This spec is for the methods in spec_helper and support/shared_examples_cjk -- it is not a relevancy spec.
describe "CJK Helper", :chinese => true, :fixme => true do
  
  context "diff CJK scripts" do
    it "should return false when there are no CJK chars" do
      expect(cjk_bigram_tokens('no cjk')).to eq(nil)
    end
    it "should detect Han - Traditional" do
      expect(cjk_bigram_tokens('舊小說')).to be > 0
    end
    it "should detect Han - Simplified" do
      expect(cjk_bigram_tokens('旧小说')).to be > 0
    end
    it "should detect Modern Kanji" do
      expect(cjk_bigram_tokens('漫画')).to be > 0
    end
    it "should detect Traditional Kanji" do
      expect(cjk_bigram_tokens('漫畫')).to be > 0
    end
    it "should detect Hiragana" do
      expect(cjk_bigram_tokens("まんが")).to be > 0
    end
    it "should detect Katakana" do
      expect(cjk_bigram_tokens("マンガ")).to be > 0
    end
    it "should detect Hancha traditional" do
      expect(cjk_bigram_tokens("廣州")).to be > 0
    end
    it "should detect Hancha simplified" do
      expect(cjk_bigram_tokens("光州")).to be > 0
    end
    it "should detect Hangul" do
      expect(cjk_bigram_tokens("한국경제")).to be > 0
    end
    it "should detect mixed scripts" do
      expect(cjk_bigram_tokens("近世仮名遣い")).to be > 0
    end
    
    context "mixed with non-CJK scripts" do
      it "should detect first character CJK" do
        expect(cjk_bigram_tokens("舊小說abc")).to be > 0
        expect(cjk_bigram_tokens("旧小说 abc")).to be > 0
        expect(cjk_bigram_tokens(" 漫画 abc")).to be > 0
      end
      it "should detect last character CJK" do
        expect(cjk_bigram_tokens("abc漫畫")).to be > 0
        expect(cjk_bigram_tokens("abc まんが")).to be > 0
        expect(cjk_bigram_tokens("abc マンガ ")).to be > 0
      end
      it "should detect (latin)(CJK)(latin)" do
        expect(cjk_bigram_tokens("abc廣州abc")).to be > 0
        expect(cjk_bigram_tokens("abc 한국경제abc")).to be > 0
        expect(cjk_bigram_tokens("abc近世仮名遣い abc")).to be > 0
        expect(cjk_bigram_tokens("abc 近世仮名遣い abc")).to be > 0
      end
    end # mixed
  end # detecting CJK chars
  
  context "counting CJK chars" do
    context "CJK only" do
      it "single unigram" do
        expect(cjk_bigram_tokens('飘')).to eq(1)
      end
      it "multiple space separated unigrams" do
        expect(cjk_bigram_tokens('金  瓶 梅')).to eq(3)
      end
      it "repeated unigram should be counted twice" do
        expect(cjk_bigram_tokens('金 瓶 梅  金')).to eq(4)
      end
      it "single bigram" do
        expect(cjk_bigram_tokens('三國')).to eq(3)
      end
      it "2 chars, no whitespace" do
        expect(cjk_bigram_tokens('董桥')).to eq(3)
      end
      it "3 chars, no whitespace" do
        expect(cjk_bigram_tokens('红楼梦')).to eq(5)
        expect(cjk_bigram_tokens('舊小說')).to eq(5)
        expect(cjk_bigram_tokens('マンガ')).to eq(5)
      end
      it "4 chars, no whitespace" do
        expect(cjk_bigram_tokens('历史研究')).to eq(7)
      end
      it "5 chars, no whitespace" do
        expect(cjk_bigram_tokens('けいちゅう')).to eq(9)
        expect(cjk_bigram_tokens('妇女与婚姻')).to eq(9)
      end
      it "6 chars, no whitespace" do
        expect(cjk_bigram_tokens('한국주택은행')).to eq(11)
        expect(cjk_bigram_tokens('近世仮名遣い')).to eq(11)
      end
      it "7 chars, no whitespace" do
        expect(cjk_bigram_tokens('中国地方志集成')).to eq(13)
      end
      context "assorted grams and whitespace" do
        it "two bigrams" do
          expect(cjk_bigram_tokens('妇女  婚姻')).to eq(6)
        end
        it "bigram + unigram" do
          expect(cjk_bigram_tokens('三國  誌')).to eq(4)
          expect(cjk_bigram_tokens('三 國誌')).to eq(4)
        end
        it "trigram" do
          expect(cjk_bigram_tokens('三國誌')).to eq(5)
        end
        it "two trigrams" do
          expect(cjk_bigram_tokens('三國誌 マンガ')).to eq(10)
        end
      end
    end # CJK only

    context "mixed with non-CJK scripts" do
      it "first character CJK" do
        expect(cjk_bigram_tokens("光abc")).to eq(2)
        expect(cjk_bigram_tokens("光 abc")).to eq(2)
        expect(cjk_bigram_tokens(" 光 abc")).to eq(2)
      end
      it "last character CJK" do
        expect(cjk_bigram_tokens("abc光")).to eq(2)
        expect(cjk_bigram_tokens("abc 光")).to eq(2)
        expect(cjk_bigram_tokens("abc 光 ")).to eq(2)
      end
      it "(latin)(CJK)(latin)" do
        expect(cjk_bigram_tokens("abc光abc")).to eq(3)
      end
      context "bigram" do
        it "first CJK" do
          expect(cjk_bigram_tokens("董桥abc")).to eq(4)
          expect(cjk_bigram_tokens("董桥 abc")).to eq(4)
          expect(cjk_bigram_tokens(" 董桥 abc")).to eq(4)
        end
        it "last CJK" do
          expect(cjk_bigram_tokens("abc董桥")).to eq(4)
          expect(cjk_bigram_tokens("abc 董桥")).to eq(4)
          expect(cjk_bigram_tokens("abc 董桥 ")).to eq(4)
        end
        it "(latin)(CJK)(latin)" do
          expect(cjk_bigram_tokens("abc董桥abc")).to eq(5)
          expect(cjk_bigram_tokens("abc 董桥abc")).to eq(5)
          expect(cjk_bigram_tokens("abc董桥 abc")).to eq(5)
          expect(cjk_bigram_tokens("abc 董桥 abc")).to eq(5)
        end
      end
    end  # mixed    
  end # counting CJK chars
    
  context "num_cjk_uni" do
    it "should detect hangul" do
      expect(num_cjk_uni('한국주택은행')).to eq(6)
    end
  end
  
  context "Solr mm and ps parameters" do
    context "should not send in a Solr mm param if only 1 or 2 CJK chars" do
      it "1 CJK char" do
        expect(cjk_mm_qs_params("飘")['mm']).to eq(nil)
      end
      it "2 CJK (adj) char" do
        expect(cjk_mm_qs_params("三國")['mm']).to eq(nil)
      end
      context "mixed with non-CJK scripts" do
        context "bigram" do
          it "first CJK" do
            expect(cjk_mm_qs_params("董桥abc")['mm']).to eq(nil)
            expect(cjk_mm_qs_params("董桥 abc")['mm']).to eq(nil)
            expect(cjk_mm_qs_params(" 董桥 abc")['mm']).to eq(nil)
          end
          it "last CJK" do
            expect(cjk_mm_qs_params("abc董桥")['mm']).to eq(nil)
            expect(cjk_mm_qs_params("abc 董桥")['mm']).to eq(nil)
            expect(cjk_mm_qs_params("abc 董桥 ")['mm']).to eq(nil)
          end
          it "(latin)(CJK)(latin)" do
            expect(cjk_mm_qs_params("abc董桥abc")['mm']).to eq(nil)
            expect(cjk_mm_qs_params("abc 董桥abc")['mm']).to eq(nil)
            expect(cjk_mm_qs_params("abc董桥 abc")['mm']).to eq(nil)
            expect(cjk_mm_qs_params("abc 董桥 abc")['mm']).to eq(nil)
          end
        end
      end # mixed      
    end

    context "only CJK chars in query" do
      it "3 CJK (adj) char: mm=cjk_mm_val, ps=cjk_ps_val" do
        expect(cjk_mm_qs_params("マンガ")).to eq({'mm'=>cjk_mm_val, 'ps'=>cjk_ps_val})
      end
      it "4 CJK (adj) char: mm=cjk_mm_val, ps=cjk_ps_val" do
        expect(cjk_mm_qs_params("历史研究")).to eq({'mm'=>cjk_mm_val, 'ps'=>cjk_ps_val})
      end
      it "5 CJK (adj) char: mm=cjk_mm_val, ps=cjk_ps_val" do
        expect(cjk_mm_qs_params("妇女与婚姻")).to eq({'mm'=>cjk_mm_val, 'ps'=>cjk_ps_val})
      end
      it "6 CJK (adj) char: mm=cjk_mm_val, ps=cjk_ps_val" do
        expect(cjk_mm_qs_params("한국주택은행")).to eq({'mm'=>cjk_mm_val, 'ps'=>cjk_ps_val})
      end
      it "7 CJK (adj) char: mm=cjk_mm_val, ps=cjk_ps_val" do
        expect(cjk_mm_qs_params("中国地方志集成")).to eq({'mm'=>cjk_mm_val, 'ps'=>cjk_ps_val})
      end
    end
    
    context "mixed with non-CJK scripts" do
      # for each non-cjk token, add 1 to the lower limit of mm
      it "first CJK" do
        expect(cjk_mm_qs_params("マンガabc")).to eq({'mm'=>mm_plus_1, 'ps'=>cjk_ps_val})
        expect(cjk_mm_qs_params("マンガ abc")).to eq({'mm'=>mm_plus_1, 'ps'=>cjk_ps_val})
        expect(cjk_mm_qs_params(" マンガ abc")).to eq({'mm'=>mm_plus_1, 'ps'=>cjk_ps_val})
      end
      it "last CJK" do
        expect(cjk_mm_qs_params("abcマンガ")).to eq({'mm'=>mm_plus_1, 'ps'=>cjk_ps_val})
        expect(cjk_mm_qs_params("abc マンガ")).to eq({'mm'=>mm_plus_1, 'ps'=>cjk_ps_val})
        expect(cjk_mm_qs_params("abc マンガ ")).to eq({'mm'=>mm_plus_1, 'ps'=>cjk_ps_val})
      end
      it "(latin)(CJK)(latin)" do
        expect(cjk_mm_qs_params("abcマンガabc")).to eq({'mm'=>mm_plus_2, 'ps'=>cjk_ps_val})
        expect(cjk_mm_qs_params("abc マンガabc")).to eq({'mm'=>mm_plus_2, 'ps'=>cjk_ps_val})
        expect(cjk_mm_qs_params("abcマンガ abc")).to eq({'mm'=>mm_plus_2, 'ps'=>cjk_ps_val})
        expect(cjk_mm_qs_params("abc マンガ abc")).to eq({'mm'=>mm_plus_2, 'ps'=>cjk_ps_val})
      end

      # add 1 to the lower limit of mm
      def mm_plus_1
        lower_limit = cjk_mm_val[0].to_i
        (lower_limit + 1).to_s + cjk_mm_val[1, cjk_mm_val.size]
      end
      # add 2 to the lower limit of mm
      def mm_plus_2
        lower_limit = cjk_mm_val[0].to_i
        (lower_limit + 2).to_s + cjk_mm_val[1, cjk_mm_val.size]
      end
    end # mixed      
  end # mm and qs params

end
