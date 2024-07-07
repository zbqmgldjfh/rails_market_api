require "test_helper"

class Api::V1::OrdersControllerTest < ActionDispatch::IntegrationTest

  setup do
    @order = orders(:one)
  end

  test "토큰이 없는 사용자의 주문 확인 요청은 거부한다" do
    get api_v1_orders_url, as: :json

    assert_response :forbidden
  end

  test "주문 목록을 볼 수 있다" do
    get api_v1_orders_url,
        headers: { Authorization: JsonWebToken.encode(user_id: @order.user_id) },
        as: :json

    assert_response :success
    json_response = JSON.parse(response.body)
    assert_equal @order.user.orders.count, json_response['data'].count
  end
end
