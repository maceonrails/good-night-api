Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :clock_ins, only: :create
    end
  end
end
