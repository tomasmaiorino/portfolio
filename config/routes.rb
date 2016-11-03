Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  match 'api/v1/client' => 'client#create', via: [:post]
  match 'api/v1/client' => 'client#update', via: [:put]
  match 'api/v1/client/:id' => 'client#get', via: [:get]
  match 'api/v1/skill' => 'skill#create', via: [:post]

end
