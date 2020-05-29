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
    admin_and_owner?
  end

  def edit?
    admin_and_owner?
  end

  def destroy?
    admin_and_owner?
  end

  class Scope < Scope
    def resolve
      scope.all.order(created_at: :desc)
    end
  end

  private

    def admin_and_owner?
      return true if user.admin? && user.events.include?(record)
    end
end
