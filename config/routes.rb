Rails.application.routes.draw do
  root 'pages#index'

  resources :pages, only: [:index]

  resources :categories, except: [:create, :update] do
    resources :tasks, except: [:index, :create, :update]
  end

  #for form action url, with method post
  post '/categories/new' => 'categories#create', as: 'create_category'
  patch '/categories/:id/edit' => 'categories#update', as: 'update_category'
  get '/tasks' => 'tasks#index', as: 'tasks'
  post '/categories/:category_id/tasks/new' => 'tasks#create', as: 'create_task'
  patch '/categories/:category_id/tasks/:id/edit' => 'tasks#update', as: 'update_task'
  get '/tasks/new' => 'tasks#new_task', as: 'new_task'
end
