Reviser::Application.routes.draw do
  root to: 'proofreading_agency#show'

  resource :orders
end
