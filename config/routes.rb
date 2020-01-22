Rails.application.routes.draw do
  get 'feedback_question/index'

  get 'feedback/index'

  get 'suggestion/index'

  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'reports#index'
  resources :reports do
    collection do
      get :search_by_dates
      get :generate_sheet
      get :employees_list
      get :change_employee_position
      get :download_sheet
    end
  end
  resources :suggestion do

  end
  resources :feedback do

  end
  resources :feedback_question do

  end
end
