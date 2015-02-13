class PopulateSpreeOrdersAddRakutenCancelSentAt < ActiveRecord::Migration
  def up
    execute 'UPDATE spree_orders SET rakuten_cancel_sent_at = NOW() WHERE state = "canceled"'
  end

  def down
    execute 'UPDATE spree_orders SET rakuten_cancel_sent_at = NULL'
  end
end
