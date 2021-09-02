Rails.application.routes.draw do
  root 'pages#landing'

  devise_for :users, 
    controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations',
      passwords: 'users/passwords'
    },
    skip: [:registrations],
    path: 'account'

  devise_scope :user do
    post 'account/sign_up' => 'users/registrations#create', as: 'user_registration'
    get 'account/sign_up' => 'users/registrations#new', as: 'new_user_registration'
  end


  resources :categories, except: [:create, :update] do
    resources :tasks, except: [:index, :create, :update]
  end

  #for form action url, with method post
  get '/home' => 'pages#index', as: 'home'
  post '/categories/new' => 'categories#create', as: 'create_category'
  patch '/categories/:id/edit' => 'categories#update', as: 'update_category'
  get '/tasks' => 'tasks#index', as: 'tasks'
  post '/categories/:category_id/tasks/new' => 'tasks#create', as: 'create_task'
  patch '/categories/:category_id/tasks/:id/edit' => 'tasks#update', as: 'update_task'
  get '/tasks/new' => 'tasks#new_task', as: 'new_task'
end
