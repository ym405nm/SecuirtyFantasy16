Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get 'profile', to: 'users#show', as: 'user'
  post 'add_balance', to: 'users#add_balance'

end
