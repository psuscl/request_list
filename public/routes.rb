Rails.application.routes.draw do

  get '/plugin/request_list', to: 'request_list#index'

end
