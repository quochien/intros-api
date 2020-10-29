Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get 'copy' => 'copy#index'
  get 'copy/refresh' => 'copy#refresh'
  get 'copy/:key' => 'copy#show', constraints: { key: /.*/ }
end
