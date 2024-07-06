require "test_helper"

class Api::V1::UsersControllerTest < ActionDispatch::IntegrationTest

  setup do
    @user = users(:one)
  end

  test "특정 사용자 정보를 확인할 수 있다" do
    get api_v1_user_url(@user), as: :json

    assert_response :success

    json_response = JSON.parse(self.response.body, symbolize_names: true)
    assert_equal @user.email, json_response.dig(:data, :attributes, :email)
    assert_equal @user.products.first.id.to_s, json_response. dig(:data, :relationships, :products, :data, 0, :id)
    assert_equal @user.products.first.title, json_response.dig(:included, 0, :attributes, :title)
  end

  test "사용자를 신규로 생성할 수 있다" do
    assert_difference('User.count') do
      post api_v1_users_url,
           params: {
             user: { email: 'shine@naver.org', password: '123456' }
           }, as: :json
    end

    assert_response :created
  end

  test "이미 등록된 이메일로는 사용자를 생성할 수 없다" do
    assert_no_difference('User.count') do
      post api_v1_users_url,
           params: {
             user: { email: @user.email, password: '123456' }
           }, as: :json
    end

    assert_response :unprocessable_entity
  end

  test "적합하지 않은 이메일로는 사용자 정보를 수정할 수 없다" do
    patch api_v1_user_url(@user),
          headers: { Authorization: JsonWebToken.encode(user_id: @user.id) },
          params: {
            user: { email: "invalid email", password: "123456" }
          }, as: :json

    assert_response :unprocessable_entity
  end

  test "사용자 정보를 업데이트 할 수 있다" do
    patch api_v1_user_url(@user),
          params: { user: { email: @user.email } },
          headers: { Authorization: JsonWebToken.encode(user_id: @user.id) },
          as: :json

    assert_response :success
  end

  test "존재하지 않는 사용자는 403을 반환한다" do
    patch api_v1_user_url(@user),
          params: { user: { email: @user.email } },
          as: :json

    assert_response :forbidden
  end

  test "존재하는 사용자를 삭제할 수 있다" do
    assert_difference('User.count', -1) do
      delete api_v1_user_url(@user),
             headers: { Authorization: JsonWebToken.encode(user_id: @user.id) },
             as: :json
    end

    assert_response :no_content
  end

  test "존재하지 않는 사용자는 삭제될 수 없다" do
    assert_no_difference('User.count') do
      delete api_v1_user_url(@user), as: :json
    end

    assert_response :forbidden
  end
end
