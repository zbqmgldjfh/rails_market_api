# frozen_string_literal: true

module Authenticable

  def current_user
    return @current_user if defined?(@current_user)

    header = request.headers["Authorization"]
    return nil if header.nil?

    decode = JsonWebToken.decode(header)

    @current_user = User.find(decode[:user_id]) rescue ActiveRecord::RecordNotFound
  end
end
