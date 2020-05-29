class TreePolicy < ApplicationPolicy
  def index?
    return true
  end

  def show?
    return true
  end

  def create?
    return true
  end

  def new?
    return true
  end

  def update?
    return true
  end

  def edit?
    return true
  end

  def destroy?
    return true
  end

  # class Scope < Scope
  #   def resolve
  #     scope.all.order(created_at: :desc)
  #   end
  # end
end
