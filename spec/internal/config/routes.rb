Rails.application.routes.draw do
  mount BrokenWindow::Engine => "/status"
end
