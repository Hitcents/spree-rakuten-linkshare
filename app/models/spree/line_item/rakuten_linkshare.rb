module Spree
  module LineItem::RakutenLinkshare
    def rakuten_linkshare_amount
      ((price.to_f + promo_total.to_f) * quantity * 100).to_i
    end
  end
end
