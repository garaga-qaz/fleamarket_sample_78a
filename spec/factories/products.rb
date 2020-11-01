FactoryBot.define do
  factory :category do  
    name              {"aaa"}
    ancestry          {"Tシャツ"}
  end

  factory :product do
    name        {"あああ"}
    details      {"aaaaaaa"}
    fee_side     {"あああ"}
    price        {"500"}
    prefecture_id {"1"}
    condition_id  {"1"}
    days_id       {"1"}
    user
    category

    after(:build) do |product|
      product.images << FactoryBot.build(:image, product: product)
    end
  end

  factory :image do
    url { Rack::Test::UploadedFile.new(File.join(Rails.root, "/public/images/test_image.jpg"),'image/jpg') }
  end

end
