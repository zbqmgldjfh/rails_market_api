require "test_helper"

class PlacementTest < ActiveSupport::TestCase
  setup do
    @placement = placements(:one)
  end

  test "placement의 수량만큼 product의 수량을 감소시킵니다" do
    product = @placement.product

    assert_difference('product.quantity', -@placement.quantity) do
      @placement.decrement_product_quantity!
    end

  end
end
