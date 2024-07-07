require "test_helper"

class OrderTest < ActiveSupport::TestCase

  test "총합은 양수 여야만 합니다" do
    order = orders(:one)
    order.total = -1
    assert_not order.valid?
  end
end
