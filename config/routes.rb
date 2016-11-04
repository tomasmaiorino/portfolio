Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #client
  match 'api/v1/client' => 'client#create', via: [:post]
  match 'api/v1/client' => 'client#update', via: [:put]
  match 'api/v1/client/:id' => 'client#get', via: [:get]

  #skill
  match 'api/v1/skill' => 'skill#create', via: [:post]
  match 'api/v1/skill' => 'skill#update', via: [:put]
  match 'api/v1/skill' => 'skill#get', via: [:get]
  match 'api/v1/skill/:id' => 'skill#get', constraints: { id: /\d+/ }, via: [:get]
  match 'api/v1/skill/:name' => 'skill#get_name', via: [:get]

  #tech_tag
  match 'api/v1/tech_tag' => 'tech_tag#create', via: [:post]
  match 'api/v1/tech_tag' => 'tech_tag#update', via: [:put]
  match 'api/v1/tech_tag' => 'tech_tag#get', via: [:get]
  match 'api/v1/tech_tag/:id' => 'tech_tag#get', constraints: { id: /\d+/ }, via: [:get]
  match 'api/v1/tech_tag/:name' => 'tech_tag#get_name', via: [:get]

end
