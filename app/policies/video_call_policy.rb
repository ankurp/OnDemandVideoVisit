class VideoCallPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    user.admin? || user.provider?
  end

  def new?
    user.patient?
  end

  def create?
    user.patient?
  end

  def show?
    !user.patient? || record.users.exists?(user.id)
  end

  def destroy?
    !user.patient? || record.users.exists?(user.id)
  end
end
