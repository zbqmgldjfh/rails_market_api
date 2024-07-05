require "test_helper"

class Api::V1::TokensControllerTest < ActionDispatch::IntegrationTest

  setup do
    @user = users(:one)
  end

  test "사용자 로그인시 JWT 토큰을 반환한다" do
    post api_v1_tokens_url, params: {
      user: { email: @user.email, password: "g00d_pa$$" }
    }, as: :json

    assert_response :success
    json_response = JSON.parse(response.body)
    assert_not_nil json_response['token']
  end

  test "잘못된 비밀번호로 접근시 401을 반환한다" do
    post api_v1_tokens_url, params: {
      user: { email: @user.email, password: 'b@d_pa$$' }
    }, as: :json

    assert_response :unauthorized
  end

end
