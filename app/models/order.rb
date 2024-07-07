class Order < ApplicationRecord
  include ActiveModel::Validations

  before_validation :calculate_total!
  validates :total, numericality: { greater_than_or_equal_to: 0 }
  validates :total, presence: true
  validates_with EnoughProductsValidator

  belongs_to :user
  has_many :placements, dependent: :destroy
  has_many :products, through: :placements

  def calculate_total!
    self.total = self.placements
                     .map{
                       |placement| placement.product.price * placement.quantity
                     }.sum
  end

  def add_product(product)
    self.products << product
  end

  def build_placements_with_product_ids_and_quantities(product_ids_and_quantities)
    product_ids_and_quantities.each do |product_id_and_quantity|
      placements.build(
        product_id: product_id_and_quantity[:product_id],
        quantity: product_id_and_quantity[:quantity]
      )
      yield placement if block_given?
    end
  end

end
