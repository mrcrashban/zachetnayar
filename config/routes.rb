Rails.application.routes.draw do
  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    resource :session, only: [:new, :create, :destroy]
    resources :users, only: [:new, :create, :edit, :update, :index]
    resources :posts, only: [:index, :new, :edit, :create, :update, :destroy, :show]
    root 'posts#index'
    # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  end
end