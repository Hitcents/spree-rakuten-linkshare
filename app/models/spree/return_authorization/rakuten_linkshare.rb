module Spree
  module ReturnAuthorization::RakutenLinkshare

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
    end

    def line_items
      # consolidates inventory_units by sku
      line_items = {}
       self.inventory_units.each do |unit|
           line_items[unit.variant.sku] ||= {}
           line_items[unit.variant.sku][:qty] ||= 0
           line_items[unit.variant.sku][:qty] += 1
           line_items[unit.variant.sku][:line_item] = order.find_line_item_by_variant(unit.variant)
           line_items[unit.variant.sku][:unit] = unit
         end
       line_items
     end
  end
end
