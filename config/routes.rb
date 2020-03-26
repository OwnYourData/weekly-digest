Rails.application.routes.draw do
    scope "(:locale)", :locale => /en|de|hu|jp|ko|tw/ do
        root 'static_pages#home'
        get 'favicon', to: "static_pages#favicon"

        match '/news',       to: 'news#index',    via: 'get'
        match '/weekly/:id', to: 'news#weekly',   via: 'get', as: "weekly"
        match '/current',    to: 'news#current',  via: 'get'
        match '/users',      to: 'users#index',   via: 'get'
        match '/user/:id',   to: 'users#show',    via: 'get'
        match '/tags',       to: 'tags#index',    via: 'get'
        match '/tag/:id',    to: 'tags#show',     via: 'get'
        match '/apps',       to: 'apps#index',    via: 'get'
        match '/app/:id',    to: 'apps#show',     via: 'get'
        match '/tools',      to: 'apps#index',    via: 'get'
        match '/tool/:id',   to: 'apps#show',     via: 'get'
        match '/sources',    to: 'sources#index', via: 'get'
        match '/source/:id', to: 'sources#show',  via: 'get'
    end

    match '/stats',        to: 'stats#index', via: 'get'
    match '/stats',        to: 'stats#data',  via: 'post'
    
    resources :posts
    match ':not_found' => 'static_pages#home', :constraints => { :not_found => /.*/ }, via: [:get, :post]

end
