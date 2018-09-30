Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount ActionCable.server => '/cable'

  get 'mentors',  to: 'relationship#mentors'
  get 'students', to: 'relationship#students'
  get 'users', to: 'relationship#users'
  post 'user', to: 'relationship#create'
  put 'user/:current_user', to: 'relationship#update'
  get 'leaderboard', to: 'relationship#leaderboard'

  get 'chats', to: 'chat#index'
  get 'chats/:id', to: 'chat#show'
  
  post 'users/authenticate', to: 'user#authenticate'
  get 'users/auth/codechef', to: 'user#auth_provider'
  post 'users/auth/codechef', to: 'user#auth_provider'
  put 'users/auth/codechef', to: 'user#auth_provider'
  
  post 'users/upload_profile_pic', to: 'user#upload_profile_pic'
  get  'users/download_profile_pic', to: 'user#download_profile_pic'
  
  post 'rails/active_storage/direct_uploads', to: 'fileupload#create'
  put 'rails/active_storage/disk/:encoded_token', to: 'filedisk#update'
  get 'rails/active_storage/disk/:encoded_key/*filename', to: 'filedisk#show'

  root 'user#index'
end
