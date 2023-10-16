Cmor::Core::Settings::Engine.routes.draw do
  resources :settings
      
  root to: 'home#index'
end
