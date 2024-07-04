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
    assert_instance_of Integer, json_response[ "id"]
    assert_equal @user.email, json_response["email"]
  end

end
