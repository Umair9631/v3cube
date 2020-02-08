Rails.application.routes.draw do
  root to: 'visitors#index'
  devise_for :users
  resources :users

  namespace :api do
    namespace :v1 do

      resources :users, only: [:show, :update] do
        collection do
          post :signup
          post :signin
          post :verify
          post :resetpassword
          post :forgotpassword
          post :update_password
          post :signout
        end
      end
    end
  end

end
