Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :user
  get 'mentors',  to: 'user#mentors'
  get 'students', to: 'user#students'
  get 'users', to: 'user#users'
end
