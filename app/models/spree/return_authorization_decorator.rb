module Spree
  ReturnAuthorization.class_eval do
    include ReturnAuthorization::RakutenLinkshare
  end
end
