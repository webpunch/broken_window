BrokenWindow::Engine.routes.draw do
  resources :metrics, path: '/'
  root to: "metrics#index"
end
