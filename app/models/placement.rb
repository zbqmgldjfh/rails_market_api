class Placement < ApplicationRecord
  after_create :decrement_product_quantity!

  belongs_to :order
  # inverse_of가 선언되면 업데이트 문을 명시적으로 작성하지 않고도 관련 모델을 업데이트할 수 있습니다.
  belongs_to :product, inverse_of: :placements

  def decrement_product_quantity!
    product.decrement(:quantity, quantity)
  end
end
