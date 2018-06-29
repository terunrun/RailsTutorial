Rails.application.routes.draw do

  get 'password_resets/new'

  get 'password_resets/edit'

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

  # 11.1.1 AccountActivationsの名前付きルート
  # GET /account_activation/<token>/edit edit edit_account_activation_url(token)
  resources :account_activations, only: [:edit]

  # 12.1.1 PasswordResetsの名前付きルート
  # GET	  /password_resets/new	        new	   new_password_reset_path
  # POST	/password_resets	            create password_resets_path
  # GET	  /password_resets/<token>/edit	edit	 edit_password_reset_url(token)
  # PATCH /password_resets/<token>	    update password_reset_url(token)
  resources :password_resets, only: [:new, :create, :edit, :update]
end
