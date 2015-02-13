module Spree
  LineItem.class_eval do
    include LineItem::RakutenLinkshare
  end
end
