ArchivesSpacePublic::Application.routes.draw do
  match '/plugin/request_list/pennstate',  to: 'request_list#index', :via => [:get]
  match '/plugin/request_list/email',      to: 'request_list#email', :via => [:post]
  match '/plugin/request_list/pdf',        to: 'request_list#pdf', :via => [:get]
  match '/plugin/request_list/help',       to: 'request_list#help', :via => [:get]
end
