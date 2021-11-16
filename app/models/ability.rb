# frozen_string_literal: true

class Ability
  include CanCan::Ability

  # @param user [User]
  def initialize(user)
    return unless user.present?

    can :read, User, id: user.id
    can :update, User, id: user.id

    can :create, UploadedFile
    can :read, UploadedFile, user_id: user.id
    can :update, UploadedFile, user_id: user.id
    can :download, UploadedFile, user_id: user.id

    can :read, Printer
    can :read, Material
    can :read, MaterialColor

    can :read, Print, uploaded_file: { user_id: user.id }
    can :create, Print
    can :cancel, Print, uploaded_file: { user_id: user.id }

    return unless user.staff?

    can :read, User
    can :read, UploadedFile
    can :read, Print
    can :cancel, Print
    can :read, PrinterDefinition

    return unless user.admin?

    can :read, Device

    can :create, Printer
    can :update, Printer

    can :read, Client
    can :update, Client

    can :read, PrinterDefinition
    can :create, PrinterDefinition
    can :update, PrinterDefinition

    can :create, Material
    can :update, Material

    can :create, GCodeSettings
    can :read, GCodeSettings
    can :update, GCodeSettings

    can :create, UltiGCodeSettings
    can :read, UltiGCodeSettings
    can :update, UltiGCodeSettings
  end

  def to_list
    rules.map do |rule|
      {
        action: rule.actions,
        subject: rule.subjects.map { |s| s.is_a?(Symbol) ? s : s.name },
        conditions: rule.conditions,
        inverted: rule.base_behavior.nil?
      }
    end
  end
end
