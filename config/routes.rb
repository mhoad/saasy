# frozen_string_literal: true

# == Route Map
#
#               Prefix Verb   URI Pattern                    Controller#Action
#     new_user_session GET    /users/sign_in(.:format)       devise/sessions#new
#         user_session POST   /users/sign_in(.:format)       devise/sessions#create
# destroy_user_session DELETE /users/sign_out(.:format)      devise/sessions#destroy
#    new_user_password GET    /users/password/new(.:format)  devise/passwords#new
#   edit_user_password GET    /users/password/edit(.:format) devise/passwords#edit
#        user_password PATCH  /users/password(.:format)      devise/passwords#update
#                      PUT    /users/password(.:format)      devise/passwords#update
#                      POST   /users/password(.:format)      devise/passwords#create
#                 root GET    /                              home#index
#          new_account GET    /accounts/new(.:format)        accounts#new
#             accounts POST   /accounts(.:format)            accounts#create
#

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
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'home#index'

  get '/accounts/new', to: 'accounts#new', as: :new_account
  post '/accounts', to: 'accounts#create', as: :accounts
end
