Rails.application.routes.draw do
  root 'races#index'

  resources :races, only: [:index]

  namespace :nankan do
    resources :races, only: [:index, :show]
  end

  namespace :jra do
    resources :races, only: [:index, :show]
  end

  namespace :api, format: :json do
    namespace :v1 do
      namespace :nankan do
        resources :races, only: [:index, :show] do
          member do
            get :horses

            scope :odds do
              get '/win', to: 'races#odds_win'
              get '/place', to: 'races#odds_place'
              get '/quinella/:horse_number', to: 'races#odds_quinella'
              get '/wide/:horse_number', to: 'races#odds_wide'
            end
          end
        end

        resources :horses, only: [:show]
      end

      namespace :jra do
        resources :races, only: [:index, :show] do
          member do
            get :horses

            scope :odds do
              get '/win', to: 'races#odds_win'
              get '/place', to: 'races#odds_place'
              get '/quinella/:horse_number', to: 'races#odds_quinella'
              get '/wide/:horse_number', to: 'races#odds_wide'
            end
          end
        end

        resources :horses, only: [:show]
      end
    end

    get '*path', controller: :application, action: :not_found
  end
end
