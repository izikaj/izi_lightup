Rails.application.routes.draw do
  root to: redirect('/rails/jasmine?random=false')
  get '/rails/jasmine', to: 'pages#jasmine'
end
