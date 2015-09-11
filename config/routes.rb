resources :closure_rules, :only => [:index, :destroy, :create] do
  post 'activate', to: "closure_rules#activate", as: :activate
  post 'apply', to: "closure_rules#apply", as: :apply
end