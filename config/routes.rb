Rails.application.routes.draw do
  root to: 'home#home'
  get 'weight_events/graph' => 'weight_events#graph'
  resources :weight_events do
  end
  resources :image_files, only: [:show]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
