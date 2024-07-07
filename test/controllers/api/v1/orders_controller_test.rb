require "test_helper"

class Api::V1::OrdersControllerTest < ActionDispatch::IntegrationTest

  setup do
    @order = orders(:one)

    @order_params = {
      order: {
        product_ids_and_quantities: [
          { product_id: products(:one).id, quantity: 2 },
          { product_id: products(:two).id, quantity: 3 },
        ]
      }
    }
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

  test "단건 주문을 확인할 수 있다" do
    get api_v1_order_url(@order),
        headers: { Authorization: JsonWebToken.encode(user_id: @order.user_id) },
        as: :json

    assert_response :success

    json_response = JSON.parse(response.body)
    include_product_attr = json_response['included'][0]['attributes']
    assert_equal @order.products.first.title, include_product_attr['title']
  end

  test "토큰이 없는 사용자의 주문 생성 요청은 거부한다" do
    assert_no_difference('Order.count') do
      post api_v1_orders_url, params: @order_params, as: :json
    end

    assert_response :forbidden
  end

  test "상품 n개에 대한 주문을 성공적으로 생성할 수 있다" do
    assert_difference('Order.count', 1) do
      post api_v1_orders_url,
           headers: { Authorization: JsonWebToken.encode(user_id: @order.user_id) },
           params: @order_params,
           as: :json
    end

    assert_response :created
  end

  test "n개의 상품과 placement로 주문을 생성할 수 있다" do
    assert_difference("Order.count", 1) do
      assert_difference("Placement.count", 2) do
        post api_v1_orders_url,
             headers: { Authorization: JsonWebToken.encode(user_id: @order.user_id) },
             params: @order_params,
             as: :json
      end
    end

    assert_response :created
  end
end
