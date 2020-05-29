class Wow::SearchPolicy < Struct.new(:user, :search)
  def index?
    true if user
  end
end
