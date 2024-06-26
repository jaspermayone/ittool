Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :admin do
    if Rails.env.development?
      mount LetterOpenerWeb::Engine, at: "/letter_opener"
    end

    mount MissionControl::Jobs::Engine, at: "/jobs"
    mount Audits1984::Engine => "/console"

  end


  # Defines the root path route ("/")
  root "main#index"

  get 'loans', to: 'loans#router'
  post 'loans', to: 'loans#create'
  get 'loans/borrow', to: 'loans#new'
  get 'loans/list'
  get 'loans/pending'
  get 'loans/out'

  get 'loaners' => 'loaners#list'
  get 'loaners/list', to: redirect('loaners')

  # Defines the checkout path route ("/checkout")
  get "scanner" => "main#scanner"

  resources :loaners do
    member do
      patch 'loan'
      patch 'return'
      patch 'enable'
      # Add other member routes as needed
    end
  end

end
