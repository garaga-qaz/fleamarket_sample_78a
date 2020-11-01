class PurchasesController < ApplicationController
  require "payjp"
  before_action :set_purchase, only: [:buy, :pay]

  def buy
    # 購入する商品を引っ張ってきます。
    # 商品ごとに複数枚写真を登録できるので、一応全部持ってきておきます。
    @images = @product.images.all

    # まずはログインしているか確認
    if user_signed_in?
      # クレジットカードが登録されているか確認
      if current_user.card.present?
        # 前前前回credentials.yml.encに記載したAPI秘密鍵を呼び出します。
        Payjp.api_key = Rails.application.credentials.dig(:payjp, :secret_key)
        # ログインユーザーのクレジットカード情報を引っ張ってきます。
        # (以下は以前のcredit_cardsコントローラーのshowアクションとほぼ一緒です)
        # ログインユーザーのクレジットカード情報からPay.jpに登録されているカスタマー情報を引き出す
        customer = Payjp::Customer.retrieve(@card.customer_id)
        # カスタマー情報からカードの情報を引き出す
        @customer_card = customer.cards.retrieve(@card.card_id)
        ## 有効期限'月'を定義
        @exp_month = @customer_card.exp_month.to_s
        ## 有効期限'年'を定義
        @exp_year = @customer_card.exp_year.to_s.slice(2,3)
      end
    else
      # ログインしていなければ、商品の購入ができずに、ログイン画面に移動します。
      redirect_to root_path, alert: "ログインしてください"
    end
  end

  def pay
    #ちなみに見やすさ考慮し、before_actionなどのリファクタリングなどはあえてしてません。
    @images = @product.images.all
    # 購入テーブル登録ずみ商品は２重で購入されないようにする
    # (２重で決済されることを防ぐ)
    if @product.orders.present?
      redirect_to product_path(@product.id), alert:  "売り切れています。"

    else
      # 同時に2人が同時に購入し、二重で購入処理がされることを防ぐための記述
      @product.with_lock do
        if current_user.card.present?
          # ログインユーザーがクレジットカード登録済みの場合の処理
          # ログインユーザーのクレジットカード情報を引っ張ってきます。
          # 前前前回credentials.yml.encに記載したAPI秘密鍵を呼び出します。
          Payjp.api_key = Rails.application.credentials.dig(:payjp, :secret_key)
          #登録したカードでの、クレジットカード決済処理
          Payjp::Charge.create(
          # 商品(product)の値段を引っ張ってきて決済金額(amount)に入れる
          amount: @product.price,
          customer: Payjp::Customer.retrieve(@card.customer_id),
          currency: 'jpy'
          )
        else
          # ログインユーザーがクレジットカード登録されていない場合(Checkout機能による処理を行います)
          # APIの「Checkout」ライブラリによる決済処理の記述
          Payjp::Charge.create(
          amount: @product.price,
          card: params['payjp-token'], # フォームを送信すると作成・送信されてくるトークン
          currency: 'jpy'
          )
        end
      #購入テーブルに登録処理(今回の実装では言及しませんが一応、、、)
      @purchase = Order.create(user_id: current_user.id, product_id: params[:product_id])
      end
    end
  end
  private
  def set_purchase
    @card = Card.find_by(user_id: current_user.id)
    @product = Product.find(params[:product_id])
  end
end
