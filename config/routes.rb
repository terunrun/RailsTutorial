Rails.application.routes.draw do
  root 'static_pages#home'
  get '/help', to:'static_pages#help'
  get '/about', to:'static_pages#about'
  get '/contact', to:'static_pages#contact'

  #resourcesを使用することで、usersに関して名前付きrootが利用可能になる
  resources :users
  get '/signup', to:'users#new'
  post '/signup', to:'users#create'

end
