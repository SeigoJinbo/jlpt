Rails.application.routes.draw do
  root 'pages#index'
  resources :words
  namespace :api do
    namespace :v1 do
      resources :words, param: :slug
      resources :kanji, param: :slug
    end
  end

  get '*path', to: 'pages#index', via: :all
end
