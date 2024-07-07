require "test_helper"

class OrderTest < ActiveSupport::TestCase

  setup do
    @order = orders(:one)
    @product1 = products(:one)
    @product2 = products(:two)
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

  test "총액을 구할때 수량또한 반영한다" do
    @order.placements = [
      Placement.new(product_id: @product1.id, quantity: 2),
      Placement.new(product_id: @product2.id, quantity: 2)
    ]

    @order.calculate_total!
    expected_total = (@product1.price * 2) + (@product2.price * 2)
    assert_equal expected_total, @order.total
  end

  test "주문 수량이 남은 제고량보다는 작거나 같아야한다" do
    @order.placements << Placement.new(product_id: @product1.id, quantity: (1 + @product1.quantity))

    assert_not @order.valid?
  end

end
