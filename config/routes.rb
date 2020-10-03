Rails.application.routes.draw do
  resources :weight_events
  resources :image_files, only: [:show]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
