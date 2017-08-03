# frozen_string_literal: true

module Accounts
  # This class handles the functionality for when an account owner
  # wants to invite another person to their account. It is setup
  # so that both new users and those with existing accounts
  # will be able to join without any problems.
  class InvitationsController < ApplicationController
    include AccountAuthentication
    before_action :authorize_owner!, except: %i[accept accepted]
    skip_before_action :authenticate_user!, only: %i[accept accepted]
    skip_before_action :authorize_user!, only: %i[accept accepted]

    def new
      @invitation = Invitation.new
    end

    def create
      @invitation = current_account.invitations.new(invitation_params)
      @invitation.save
      InvitationEmailJob.perform_later(@invitation.id)
      flash[:notice] = "#{@invitation.email} has been invited."
      redirect_to root_url
    end

    def accept
      store_location_for(:user, request.fullpath)
      @invitation = Invitation.find_by!(token: params[:id])
    end

    def accepted
      @invitation = Invitation.find_by!(token: params[:id])

      signup_new_user unless user_signed_in?
      current_account.users << current_user

      flash[:notice] = "You have joined the #{current_account.name} account."
      redirect_to root_url(subdomain: current_account.subdomain)
    end

    private

    def invitation_params
      params.require(:invitation).permit(:email)
    end

    def signup_new_user
      user_params = params[:user].permit(
        :email,
        :password,
        :password_confirmation
      )

      user = User.create(user_params)
      sign_in(user)
    end
  end
end
