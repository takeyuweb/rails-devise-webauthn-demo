Rails.application.routes.draw do
  get 'passkeys/index'
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  authenticate :user do
    root "my_pages#show"
    resources :passkeys, only: [:index, :create, :destroy] do
      collection do
        resources :creation_options, only: [:create], module: :passkeys
      end
    end
  end
end
