BrokenWindow::Engine.routes.draw do
  resources :metrics, path: '/' do
    member do
      post :snooze
      post :unsnooze
    end
  end

  root to: "metrics#index"
end
