# frozen_string_literal: true

class InvitationEmailJob < ApplicationJob
  queue_as :mailers

  def perform(invitation_id)
    invitation = Invitation.find(invitation_id)
    InvitationMailer.invite(invitation).deliver_now
  end
end
