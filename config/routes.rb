Spree::Core::Engine.routes.draw do
  namespace :admin do
    resource :rakuten_linkshare_settings, only: [:edit, :update]
  end
end
