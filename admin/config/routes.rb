Rails.application.routes.draw do
  resources :clients do
    resources :subscriptions, shallow: true
  end
end
