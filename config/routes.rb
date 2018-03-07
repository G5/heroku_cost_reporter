Rails.application.routes.draw do
  root to: "invoices#index"
  resources :invoices, only: %w(show index)

  resources :organizations, only: %w(show index)
end
