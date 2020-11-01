require 'rails_helper'

describe Product do
  describe '#create' do
  #1
    it "is valid with a all culmn" do
      product = build(:product)
      expect(product).to be_valid
    end

  # 2
    it "商品名が空では登録できないこと" do
      product = build(:product, name: "")
      product.valid?
      expect(product.errors[:name]).to include("を入力してください")
    end
  
  #3
    it "詳細が空では登録できないこと" do
      product = build(:product, details: "")
      product.valid?
      expect(product.errors[:details]).to include("を入力してください")
    end

  #4
    it "負担者が空では登録できないこと" do
      product = build(:product, fee_side: "")
      product.valid?
      expect(product.errors[:fee_side]).to include("を入力してください")
    end

  #5
    it "価格が空では登録できないこと" do
      product = build(:product, price: "")
      product.valid?
      expect(product.errors[:price]).to include("を入力してください")
    end
  
  #6
    it "県が空では登録できないこと" do
      product = build(:product, prefecture_id: "")
      product.valid?
      expect(product.errors[:prefecture_id]).to include("を入力してください")
    end

  #7
    it "状態が空では登録できないこと" do
      product = build(:product, condition_id: "")
      product.valid?
      expect(product.errors[:condition_id]).to include("を入力してください")
    end
  
  #8
    it "配送日時が空では登録できないこと" do
      product = build(:product, days_id: "")
      product.valid?
      expect(product.errors[:days_id]).to include("を入力してください")
    end

  #9
    it "名前が41文字以上であれば登録できない" do
      product = build(:product, name: 'a' * 41)
      product.valid?
      expect(product.errors[:name]).to include("は40文字以内で入力してください")
    end
  
  #10
    it "名前が40文字以内であれば登録できる" do
      product = build(:product, name: 'a' * 40)
      product.valid?
      expect(product).to be_valid
    end
  
  #11
    it "詳細が1001文字以上であれば登録できない" do
      product = build(:product, details: 'a' * 1001)
      product.valid?
      expect(product.errors[:details]).to include("は1000文字以内で入力してください")
    end

  #12
    it "詳細が1000文字以内であれば登録できる" do
      product = build(:product, details: 'a' * 999)
      product.valid?
      expect(product).to be_valid
    end

  #13
    it "価格が300円未満では登録できないこと" do
      product = build(:product, price: "299")
      product.valid?
      expect(product.errors[:price]).to include("は300以上の値にしてください")
    end

  #14
    it "価格が10000000円以上では登録できないこと" do
      product = build(:product, price: "100000000")
      product.valid?
      expect(product.errors[:price]).to include("は9999999より小さい値にしてください")
    end
  end
end