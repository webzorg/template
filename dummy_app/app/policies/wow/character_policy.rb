class Wow::CharacterPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true if owner?
  end

  def create?
    true
  end

  def new?
    true
  end

  def update?
    true if owner?
  end

  def edit?
    true if owner?
  end

  def destroy?
    true if owner?
  end

  class Scope < Scope
    def resolve
      user.characters
    end
  end

  private

    def owner?
      return true if user.characters.include?(record)
    end
end
