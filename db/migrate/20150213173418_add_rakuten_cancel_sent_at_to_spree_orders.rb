class AddRakutenCancelSentAtToSpreeOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :rakuten_cancel_sent_at, :datetime
    add_index :spree_orders, :rakuten_cancel_sent_at
  end
end
