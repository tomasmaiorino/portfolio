Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  match 'api/v1/client' => 'client#create', via: [:post]

end
