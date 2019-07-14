Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'static_pages#home'
  get 'favicon', to: "static_pages#favicon"

  match '/news',       to: 'news#index',  via: 'get'
  match '/weekly/:id', to: 'news#weekly', via: 'get'
  match '/users',      to: 'users#index', via: 'get'
  match '/user/:id',   to: 'users#show',  via: 'get'
  match '/tags',       to: 'tags#index',  via: 'get'
  match '/tag/:id',    to: 'tags#show',   via: 'get'
  match '/apps',       to: 'apps#index',  via: 'get'
  match '/app/:id',    to: 'apps#show',   via: 'get'
  resources :posts
  match ':not_found' => 'static_pages#home', :constraints => { :not_found => /.*/ }, via: [:get, :post]

end
