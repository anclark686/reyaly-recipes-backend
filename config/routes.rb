Rails.application.routes.draw do
    get "welcome/index"
    root to: "welcome#index"
    
    resources :recipes do
        resources :ingredients
        resources :instructions
    end
end
