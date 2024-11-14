Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :applications, param: :token do
    resources :chats, :except => :update, param: :number do
      get 'search'
      resources :messages, param: :number
    end
  end
end
