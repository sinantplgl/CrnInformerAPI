Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api, path: '/api' do
    get 'addrequest', to: 'main#create', as: 'create'
    get 'checkspace', to: 'main#check_available', as: 'check'
    get 'sendmail', to: 'main#inform_by_mail', as: 'mail'
  end
end
