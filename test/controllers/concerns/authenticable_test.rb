require 'test_helper'

class MockController
  include Authenticable
  attr_accessor :request

  def initialize
    mock_request = Struct.new(:headers)
    self.request = mock_request.new({})
  end
end

class AuthenticableTest < ActionDispatch::IntegrationTest

  setup do
    @user = users(:one)
    @authentication = MockController.new
  end

  test "전달받은 인증 토큰으로 사용자를 찾을 수 있다" do
    @authentication.request.headers["Authorization"] = JsonWebToken.encode(user_id: @user.id)

    assert_not_nil @authentication.current_user
    assert_equal @user.id, @authentication.current_user.id
  end

  test "비어있는 토큰으로부터는 사용자를 찾을 수 없다" do
    @authentication.request.headers["Authorization"] = nil

    assert_nil @authentication.current_user
  end

end

