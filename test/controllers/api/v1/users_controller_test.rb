require "test_helper"

class Api::V1::UsersControllerTest < ActionDispatch::IntegrationTest

  setup do
    @user = users(:one)
  end

  test "특정 사용자 정보를 확인할 수 있다" do
    get api_v1_user_url(@user), as: :json

    assert_response :success

    json_response = JSON.parse(self.response.body)
    print json_response
    assert_instance_of Integer, json_response["id"]
    assert_equal @user.email, json_response["email"]
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

  test "사용자 정보 업데이트" do
    patch api_v1_user_url(@user),
          params: {
            user: { email: @user.email, password: '123456' }
          }, as: :json

    assert_response :success
  end

  test "적합하지 않은 이메일로는 사용자 정보를 수정할 수 없다" do
    patch api_v1_user_url(@user),
          params: {
            user: { email: "invalid email", password: "123456" }
          }, as: :json

    assert_response :unprocessable_entity
  end

end
