# frozen_string_literal: true

# Various plans will impose different limitations as to how many resouces each
# account can have. For example you may decide that one plan can only have
# a single project associated with it. This is where all of those checks occur.
module AccountLimitations
  extend ActiveSupport::Concern

  private

  def check_project_limit
    return unless current_account.plan.projects_allowed == current_account.projects.count
    message = "You have reached your plan's limit. You need to upgrade to add more projects."
    ask_to_upgrade(message)
  end

  def ask_to_upgrade(message)
    session[:return_to] = request.fullpath
    flash[:alert] = message
    redirect_to account_choose_plan_path
  end
end
