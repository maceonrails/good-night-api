Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :clock_ins, only: :create
      resources :clock_outs, only: :create
      resources :users, only: [] do
        resources :friends, only: %i[create destroy]
      end
    end
  end
end
