Rails.application.routes.draw do
  root 'races#index'

  resources :races, only: [:index, :show]

  namespace :api do
    namespace :v1 do
      resources :races, only: [:index, :show] do
        member do
          get :horses

          scope :odds do
            get :win, to: 'races#odds_win'
            get :place, to: 'races#odds_place'
          end
        end
      end

      resources :horses, only: [:show]
    end

    get '*path', controller: :application, action: :not_found
  end
end
