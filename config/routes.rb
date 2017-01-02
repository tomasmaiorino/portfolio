
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
  match 'api/v1/skill/all' => 'skill#get_all', via: [:get]
  match 'api/v1/skill/:id' => 'skill#get', constraints: { id: /\d+/ }, via: [:get]
  match 'api/v1/skill/:name' => 'skill#get_name', via: [:get]

  #tech_tag
  match 'api/v1/tech_tag' => 'tech_tag#create', via: [:post]
  match 'api/v1/tech_tag' => 'tech_tag#update', via: [:put]
  match 'api/v1/tech_tag' => 'tech_tag#get', via: [:get]
  match 'api/v1/tech_tag/all' => 'tech_tag#get_all', via: [:get]
  match 'api/v1/tech_tag/:id' => 'tech_tag#get', constraints: { id: /\d+/ }, via: [:get]
  match 'api/v1/tech_tag/:name' => 'tech_tag#get_name', via: [:get]

  #company
  match 'api/v1/company' => 'company#create', via: [:post]
  match 'api/v1/company' => 'company#update', via: [:put]
  match 'api/v1/company/:client_id' => 'company#get_company_client', constraints: { client_id: /\d+/ }, via: [:get]
  match 'api/v1/company/token/:token' => 'company#get', via: [:get]
  match 'api/v1/company/tech/:token' => 'company#get_projects_tech_tags_by_company', via: [:get]
  match 'api/v1/company/skill/:token' => 'company#get_company_skills', via: [:get]

  #project
  match 'api/v1/project' => 'project#create', via: [:post]
  match 'api/v1/project' => 'project#update', via: [:put]
  match 'api/v1/project' => 'project#get', via: [:get]
  match 'api/v1/project/:id' => 'project#get', constraints: { id: /\d+/ }, via: [:get]
  match 'api/v1/project/company/:id' => 'project#get_company', via: [:get]

  #rating
  match 'api/v1/rating' => 'rating#create', via: [:post]
  match 'api/v1/rating/:token' => 'rating#get', via: [:get]

end
