Rails.application.routes.draw do

  get  '/plugin/request_list',       to: 'request_list#index'
  post '/plugin/request_list/email', to: 'request_list#email'

end
