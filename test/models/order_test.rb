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
end
