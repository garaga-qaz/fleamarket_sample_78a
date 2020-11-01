class Product < ApplicationRecord
  belongs_to :user, foreign_key: 'user_id'

  belongs_to :category, foreign_key: 'category_id'

  has_many :images, dependent: :destroy
  accepts_nested_attributes_for :images, allow_destroy: true

  validates :images, presence: true
  validates :name, presence: true, length: { maximum: 40 } 
  validates :details, presence: true, length: { maximum: 1000 } 
  validates :fee_side, presence: true
  validates :price, presence: true
  validates :price, numericality: {greater_than_or_equal_to: 300,less_than: 9999999}
  validates_associated :images
  validates :prefecture_id, presence: true
  validates :condition_id, presence: true
  validates :days_id, presence: true
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :prefecture
  belongs_to_active_hash :condition
  belongs_to_active_hash :day
  has_many :orders, dependent: :destroy

  def self.search(search)
    if search != ""
      Product.where('name LIKE(?) or details LIKE(?)', "%#{search}", "%#{search}%")
    else
      Product.all
    end
  end
  
end
