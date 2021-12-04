Rails.application.routes.draw do
    devise_for :users
    scope "(:locale)", :locale => /en|cn|de|fr|hu|jp|ko|pl|pt/ do
        root 'static_pages#home'
        match 'home',         to: 'static_pages#home',        via: 'get'
        get 'favicon', to: "static_pages#favicon"

        get    '/login',        to: 'static_pages#login'
        post   '/login',        to: 'sessions#create'
        delete '/logout',       to: 'sessions#destroy'
        get    '/logout',       to: 'sessions#destroy'
        get    '/change_pwd',   to: 'static_pages#change_pwd'
        post   '/change_pwd',   to: 'sessions#change'
  
        match '/news',          to: 'news#index',                via: 'get'
        match '/weekly/:id',    to: 'news#weekly',               via: 'get', as: "weekly"
        match '/current',       to: 'news#current',              via: 'get'
        match '/current/channels',  to: 'news#current_channels',  via: 'get'
        match '/current/internals', to: 'news#current_internals', via: 'get'

        match '/plain',         to: 'news#plain',                via: 'get'
        match '/plain_html',    to: 'news#plain_html',           via: 'get'
        match '/users',         to: 'users#index',               via: 'get'
        match '/user/:id',      to: 'users#show',                via: 'get'
        match '/tags',          to: 'tags#index',                via: 'get'
        match '/tag/:id',       to: 'tags#show',                 via: 'get', as: "tag"
        match '/apps',          to: 'apps#index',                via: 'get'
        match '/app/:id',       to: 'apps#show',                 via: 'get'
        match '/tools',         to: 'apps#index',                via: 'get'
        match '/tool/:id',      to: 'apps#show',                 via: 'get'
        match '/new_app',       to: 'apps#new',                  via: 'get'
        match '/edit_app',      to: 'apps#edit',                 via: 'get'
        match '/app_submit',    to: 'apps#update',               via: 'post'
        match '/sources',       to: 'sources#index',             via: 'get'
        match '/source/:id',    to: 'sources#show',              via: 'get'
        match '/contributor',   to: 'static_pages#contributor',  via: 'get'
        match '/edit_mdi',      to: 'news#mdi_edit',             via: 'get'
        match '/new_mdi',       to: 'news#mdi_edit',             via: 'get'
        match '/mdi_submit',    to: 'news#update_mdi',           via: 'post'
        match '/new_wd',        to: 'news#new_wd',               via: 'get'
        match '/edit_wd',       to: 'news#edit_wd',              via: 'get'
        match '/publish_wd',    to: 'news#publish_wd',           via: 'get'
        match '/wd_submit',     to: 'news#update_wd',            via: 'post'
        match '/add_post',      to: 'news#add_post',             via: 'get'
        match '/add_app_post',  to: 'news#add_app',              via: 'get'
        match '/edit_app_post', to: 'news#edit_app',             via: 'get'
        match '/appost_submit', to: 'news#update_app',           via: 'post'
        match '/add_lang_post', to: 'news#add_lang_post',        via: 'get'
        match '/edit_post',     to: 'news#edit_post',            via: 'get'
        match '/post_submit',   to: 'news#update_post',          via: 'post'
        match '/add_tag',       to: 'news#add_tag',              via: 'post'
        match '/delete_tag',    to: 'news#delete_tag',           via: 'get'
        match '/destroy_tag',   to: 'tags#destroy',              via: 'get'
        match '/destroy_user',  to: 'users#destroy',             via: 'get'

        match '/subscribe',     to: 'subscriptions#create',       via: 'post'
        match '/subscribe',     to: 'subscriptions#subscription', via: 'get'
        match '/unsubscribe',   to: 'subscriptions#unsubscribe',  via: 'get'
    end  
  
    match '/stats',        to: 'stats#index', via: 'get'
    match '/stats',        to: 'stats#data',  via: 'post'
    
    resources :posts
    match ':not_found' => 'static_pages#home', :constraints => { :not_found => /.*/ }, via: [:get, :post]

end
