BrokenWindow::Engine.routes.draw do
  resources :metrics, path: '/' do
    post :snooze, on: :member
    post :unsnooze, on: :member
  end
  root to: "metrics#index"
end
