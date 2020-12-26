# frozen_string_literal: true

class Wow::EventSignupPolicy < Struct.new(:user, :search)
  def create?
    true if user
  end
end
