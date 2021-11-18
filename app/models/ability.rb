# frozen_string_literal: true

class Ability
  include CanCan::Ability

  # @param user [User]
  def initialize(user)
    clear_aliased_actions

    return unless user.present?

    can :read, User, id: user.id
    can :update, User, id: user.id

    can :index, UploadedFile, user_id: user.id
    can :create, UploadedFile
    can :read, UploadedFile, user_id: user.id
    can :update, UploadedFile, user_id: user.id
    can :download, UploadedFile, user_id: user.id
    can :delete, UploadedFile, user_id: user.id

    can :index, Printer
    can :read, Printer
    can :read, Material
    can :read, MaterialColor

    can :index, Print, uploaded_file: { user_id: user.id }
    can :read, Print, uploaded_file: { user_id: user.id }
    can :create, Print
    can :cancel, Print, uploaded_file: { user_id: user.id }

    can :create, WebSocketTicket
    can :read, WebSocketTicket

    return unless user.staff?

    can :index, User
    can :read, User

    can :read, UploadedFile

    can :index, Print
    can :read, Print
    can :cancel, Print

    can :read, PrinterDefinition

    return unless user.admin?

    can :read, Device

    can :create, Printer
    can :update, Printer

    can :index, Client
    can :read, Client
    can :update, Client

    can :index, PrinterDefinition
    can :read, PrinterDefinition
    can :create, PrinterDefinition
    can :update, PrinterDefinition
    can :delete, PrinterDefinition

    can :index, Material
    can :create, Material
    can :update, Material
    can :delete, Material

    can :create, MaterialColor
    can :update, MaterialColor

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
        # GraphQL converts integer IDs to strings so we have to do this
        # this indiscriminately converts all integers to strings (i.e. also non-ID integers)... too bad!
        conditions: rule.conditions
                        .deep_transform_keys! { |k| k.to_s.camelize(:lower) }
                        .deep_transform_values! { |v| v.is_a?(Integer) ? v.to_s : v },
        inverted: rule.base_behavior.nil?,
      }
    end
  end
end