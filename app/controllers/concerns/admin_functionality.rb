# frozen_string_literal: true

# This is where we store all the common administration authorization stuff
module AdminFunctionality
  extend ActiveSupport::Concern

  included do
    before_action :authorize_admin!
  end

  private

  def authorize_admin!
    return true if current_user && current_user.admin?

    flash[:alert] = 'You are not permitted to access that.'
    redirect_to root_url
  end
end
