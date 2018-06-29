Rails.application.routes.draw do

  root 'static_pages#home'
  get '/help', to:'static_pages#help'
  get '/about', to:'static_pages#about'
  get '/contact', to:'static_pages#contact'

  # resourcesを使用することで、usersに関して名前付きrootが利用可能になる
  resources :users
  get '/signup', to:'users#new'
  post '/signup', to:'users#create'

  # sessionリソースに対するルーティング
  get '/login', to:'sessions#new'
  post '/login', to:'sessions#create'
  delete '/logout', to:'sessions#destroy'

  # 11.1.1 editアクションへの名前付きルート(edit_account_activation_url)
  resources :account_activations, only: [:edit]

end
