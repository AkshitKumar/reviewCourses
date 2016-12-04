Rails.application.routes.draw do

  resources :notifications
  resources :courses do
    resources :reviews , except: [:show, :index]
    get 'reviews/:id/upvote' => 'reviews#upvote', as: :review_upvote
    get 'reviews/:id/downvote' => 'reviews#downvote', as: :review_downvote
  end
  resources :search_suggestions, only: [:index]
  post 'users' => 'users#following'

  get 'pages/about'

  get 'pages/contact'

  root 'courses#index'
  get 'users/showreview' => 'users#showreview' , as: :userreviews
  resources :oauth
#  get 'login'=> 'oauth#index'
  delete 'logout'=>'oauth#signout'
end
