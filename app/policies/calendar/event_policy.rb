class Calendar::EventPolicy < ApplicationPolicy
  def index?
    return true if user
  end

  def show?
    return true if user
  end

  def create?
    return true if user.admin?
  end

  def new?
    return true if user.admin?
  end

  def update?
    return true if user.admin?
  end

  def edit?
    return true if user.admin?
  end

  def destroy?
    return true if user.admin?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
