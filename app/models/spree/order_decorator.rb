module Spree
  Order.class_eval do
    include Order::RakutenLinkshare
  end
end
