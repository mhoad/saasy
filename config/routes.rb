# frozen_string_literal: true

# == Route Map
#
#               Prefix Verb   URI Pattern                         Controller#Action
#     new_user_session GET    /users/sign_in(.:format)            devise/sessions#new
#         user_session POST   /users/sign_in(.:format)            devise/sessions#create
# destroy_user_session DELETE /users/sign_out(.:format)           devise/sessions#destroy
#    new_user_password GET    /users/password/new(.:format)       devise/passwords#new
#   edit_user_password GET    /users/password/edit(.:format)      devise/passwords#edit
#        user_password PATCH  /users/password(.:format)           devise/passwords#update
#                      PUT    /users/password(.:format)           devise/passwords#update
#                      POST   /users/password(.:format)           devise/passwords#create
#         account_root GET    /                                   accounts/projects#index
#          choose_plan GET    /account/choose_plan(.:format)      accounts/plans#choose
#  account_choose_plan PATCH  /account/choose_plan(.:format)      accounts/plans#chosen
#  cancel_subscription DELETE /account/cancel(.:format)           accounts/plans#cancel
#          switch_plan PUT    /account/switch_plan(.:format)      accounts/plans#switch
#    accept_invitation GET    /invitations/:id/accept(.:format)   accounts/invitations#accept
#  accepted_invitation PATCH  /invitations/:id/accepted(.:format) accounts/invitations#accepted
#          invitations POST   /invitations(.:format)              accounts/invitations#create
#       new_invitation GET    /invitations/new(.:format)          accounts/invitations#new
#                users GET    /users(.:format)                    accounts/users#index
#                 user DELETE /users/:id(.:format)                accounts/users#destroy
#             projects GET    /projects(.:format)                 accounts/projects#index
#                      POST   /projects(.:format)                 accounts/projects#create
#          new_project GET    /projects/new(.:format)             accounts/projects#new
#         edit_project GET    /projects/:id/edit(.:format)        accounts/projects#edit
#              project GET    /projects/:id(.:format)             accounts/projects#show
#                      PATCH  /projects/:id(.:format)             accounts/projects#update
#                      PUT    /projects/:id(.:format)             accounts/projects#update
#                      DELETE /projects/:id(.:format)             accounts/projects#destroy
#                 root GET    /                                   home#index
#          new_account GET    /accounts/new(.:format)             accounts#new
#             accounts POST   /accounts(.:format)                 accounts#create
#

require 'constraints/subdomain_required'

Rails.application.routes.draw do
  # Users shouldn't be able to just sign up like you might normally do.
  # It should only ever be in the context of an account. So we have
  # removed some of the paths provided by the registrations module.
  devise_for :users, skip: [:registrations] do
    get 'users/edit', to: 'devise/registrations#edit', as: :edit_user_registration
    get 'users/cancel', to: 'devise/registrations#cancel', as: :cancel_user_registration
    patch 'users', to: 'devise/registrations#update', as: :user_registration
    put 'users', to: 'devise/registrations#update', as: :user_registration
    get 'users/cancel', to: 'devise/registrations#cancel', as: :cancel_user_registration
  end

  # Show a different root path if the user is viewing the application from an
  # account subdomain using a routing constraint.
  constraints(SubdomainRequired) do
    scope module: 'accounts' do
      root to: 'projects#index', as: :account_root
      get '/account/choose_plan', to: 'plans#choose', as: :choose_plan
      patch '/account/choose_plan', to: 'plans#chosen'
      delete '/account/cancel', to: 'plans#cancel', as: :cancel_subscription
      put 'account/switch_plan', to: 'plans#switch', as: :switch_plan
      resources :invitations, only: %i[new create] do
        member do
          get :accept
          patch :accepted
        end
      end
      resources :users, only: %i[index destroy]
      resources :projects
    end
  end

  root to: 'home#index'

  get '/accounts/new', to: 'accounts#new', as: :new_account
  post '/accounts', to: 'accounts#create', as: :accounts
end
