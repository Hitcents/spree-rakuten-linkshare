class AddRakutenReturnSentAtToSpreeReturnAuthorizations < ActiveRecord::Migration
  def change
    add_column :spree_return_authorizations, :rakuten_return_sent_at, :datetime
    add_index :spree_return_authorizations, :rakuten_return_sent_at
  end
end
