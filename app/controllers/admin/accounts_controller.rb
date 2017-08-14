# frozen_string_literal: true

module Admin
  class AccountsController < ApplicationController
    include AdminFunctionality

    def index; end

    def search
      account = Account.find_by(subdomain: params[:subdomain])
      redirect_to [:admin, account]
    end

    def show
      @account = Account.find(params[:id])
    end
  end
end
