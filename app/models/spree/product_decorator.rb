module Spree
  Product.class_eval do
    include Product::RakutenLinkshare
  end
end
