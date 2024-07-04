require "test_helper"

class UserTest < ActiveSupport::TestCase

  test '사용자의 이메일 검증 확인' do
    new_user = User.new(email: "shine@test.com", password_digest: "test")

    assert new_user.valid?
  end

  test '사용자의 부적합 한 이메일 검증 확인' do
    user = User.new(email: "shine", password_digest: "test")

    assert_not user.valid?
  end

  test '동일한 이메일의 사용자는 등록될 수 없다' do
    # given
    other_user = users(:one)

    # when
    user = User.new(email: other_user.email, password_digest: "test2")

    # then
    assert_not user.valid?
  end

end
