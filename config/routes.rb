Reviser::Application.routes.draw do
  get "orders/create"
  root to: 'proofreading_agency#show'
end
