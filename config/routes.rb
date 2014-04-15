Reviser::Application.routes.draw do
  root to: 'proofreading_agency#show'

  resources :orders
end
