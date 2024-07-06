require "test_helper"

class ProductTest < ActiveSupport::TestCase

  test "상품의 가격은 양수여야 합니다" do
    product = products(:one)
    product.price = -1

    assert_not product.valid?
  end
end
