require "test_helper"

class OrderTest < ActiveSupport::TestCase

  setup do
    @order = orders(:one)
    @product1 = products(:one)
    @product2 = products(:two)
  end

  test "총액을 성공적으로 저장한다" do
    order = Order.new(user_id: @order.user_id)
    order.add_product(products(:one))
    order.add_product(products(:two))
    order.save

    assert_equal (@product1.price + @product2.price), order.total
  end

  test "주문을 위한 placements 2개를 생성한다" do
    @order.build_placements_with_product_ids_and_quantities(
    [
      { product_id: @product1.id, quantity: 2 },
      { product_id: @product2.id, quantity: 3 },
    ])

    assert_difference('Placement.count', 2) do
      @order.save
    end
  end

end
