require "test_helper"

class Api::V1::ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @product = products(:one)
  end

  test "상품 목록을 조회한다" do
    get api_v1_products_url, as: :json
    assert_response :success
  end

  test "특정 상품 하나를 조회한다" do
    get api_v1_product_url(@product), as: :json
    assert_response :success

    json_response = JSON.parse(self.response.body)
    assert_equal @product.title, json_response["title"]
  end

  test "상품을 생성할 수 있다" do
    assert_difference("Product.count") do
      post api_v1_products_url,
           headers: { Authorization: JsonWebToken.encode(user_id: @product.user_id) },
           params: {
             product: { title: @product.title, price: @product.price, published: @product.published }
           }, as: :json
    end

    assert_response :created
  end

  test "토큰없이 상품을 생성하려 하는 경우 403을 반환한다" do
    assert_no_difference("Product.count") do
      post api_v1_products_url,
           params: {
             product: { title: @product.title, price: @product.price, published: @product.published }
           }, as: :json
    end

    assert_response :forbidden
  end

  test "사용자는 본인의 상품 정보를 업데이트 할 수 있다" do
    patch api_v1_product_url(@product),
          headers: { Authorization: JsonWebToken.encode(user_id: @product.user_id) },
          params: { product: { title: @product.title } },
          as: :json

    assert_response :success
  end

  test "사용자 본인의 상품이 아닌 상품을 수정하려는 경우 403을 반환한다" do
    patch api_v1_product_url(@product),
          headers: { Authorization: JsonWebToken.encode(user_id: users(:two).id) },
          params: { product: { title: @product.title } },
          as: :json

    assert_response :forbidden
  end

  test "사용자는 본인의 상품을 삭제할 수 있다" do
    assert_difference("Product.count", -1) do
      delete api_v1_product_url(@product),
             headers: { Authorization: JsonWebToken.encode(user_id: users(:one).id) },
             as: :json
    end

    assert_response :no_content
  end

  test "사용자 본인의 상품이 아닌 상품을 삭제하려는 경우 403을 반환한다" do
    assert_no_difference("Product.count") do
      delete api_v1_product_url(@product),
             headers: { Authorization: JsonWebToken.encode(user_id: users(:two).id) },
             as: :json
    end

    assert_response :forbidden
  end
end
