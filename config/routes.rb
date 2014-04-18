Reviser::Application.routes.draw do
  root to: 'proofreading_agency#show'

  resources :orders
  get 'purchase_processor/execute', to: 'purchase_processor#execute'
end
