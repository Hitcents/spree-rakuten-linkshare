class PopulateSpreeReturnAuthorizationsAddRakutenReturnSentAt < ActiveRecord::Migration
  def up
    execute 'UPDATE spree_return_authorizations SET rakuten_return_sent_at = NOW() WHERE state = "received"'
  end

  def down
    execute 'UPDATE spree_return_authorizations SET rakuten_return_sent_at = NULL'
  end
end
