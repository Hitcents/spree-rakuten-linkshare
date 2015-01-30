module Spree
  module Order::RakutenLinkshare
    def rakuten_sku_list
      line_items.map { |li| li.variant.sku.gsub('|', ' ') }.join('|')
    end

    def rakuten_qty_list
      line_items.map { |li| li.quantity }.join('|')
    end

    def rakuten_amt_list
      # TODO: make sure that line-item level and order-level promos are considered
      line_items.map { |li| ((li.price.to_f + li.promo_total.to_f) * li.quantity * 100).to_i }.join('|')
    end

    def rakuten_name_list
      line_items.map { |li| URI::escape(li.variant.name.gsub('|', '')) }.join('|')
    end
  end
end
