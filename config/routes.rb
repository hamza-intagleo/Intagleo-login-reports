Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'reports#index'
  resources :reports do
    collection do
      get :search_by_dates
    end
  end
end
