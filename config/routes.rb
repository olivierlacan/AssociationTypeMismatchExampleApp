Rails.application.routes.draw do
  resources :courses

  root to: redirect("/courses/1/edit")
end
