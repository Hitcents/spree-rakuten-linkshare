require 'net/ftp'

module Spree
  module Order::RakutenLinkshare

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def upload_rakuten_linkshare_cancelled_feed
        raise 'Rakuten FTP Host not defined' unless SpreeRakutenLinkshare::Config.ftp_host.present?
        raise 'Rakuten FTP Username not defined' unless SpreeRakutenLinkshare::Config.ftp_username.present?
        raise 'Rakuten FTP Password not defined' unless SpreeRakutenLinkshare::Config.ftp_password.present?

        orders = rakuten_cancelled_orders
        returns = rakuten_received_returns
        return if orders.empty? && returns.empty?


        file = create_rakuten_linkshare_cancel_file(orders, returns)
        return unless file

        Net::FTP.open(SpreeRakutenLinkshare::Config.ftp_host) do |ftp|
          ftp.login SpreeRakutenLinkshare::Config.ftp_username, SpreeRakutenLinkshare::Config.ftp_password
          ftp.puttextfile file
        end

        orders.each { |o| o.update_column(:rakuten_cancel_sent_at, Time.now) }
        returns.each { |r| r.update_column(:rakuten_return_sent_at, Time.now) }
      end

      def rakuten_cancelled_orders
        where(state: "canceled", rakuten_cancel_sent_at: nil)
      end

      def rakuten_received_returns
        Spree::ReturnAuthorization.where(state: "received", rakuten_return_sent_at: nil)
      end

      def create_rakuten_linkshare_cancel_file(orders, returns)
        filename = Rails.root.join('tmp', rakuten_linkshare_cancel_file_filename)
        f = File.new(filename, 'w')

        orders.each do |o|
          o.line_items.each do |li|
            f.puts [
              o.number,
              "\t",
              o.created_at.strftime("%Y-%m-%d"),
              o.completed_at.strftime("%Y-%m-%d"),
              li.variant.sku,
              li.quantity,
              li.rakuten_linkshare_amount * -1,
              ((li.price.to_f + li.promo_total.to_f) * li.quantity * -100).to_i,
              li.currency,
              "\t",
              "\t",
              "\t",
              li.name,
            ].map { |x| x.to_s.gsub('|', ' ') }.join('|')
          end
        end

        returns.each do |r|
          r.line_items.each do |sku, data|
            f.puts [
              r.order.number,
              "\t",
              r.order.created_at.strftime("%Y-%m-%d"),
              r.order.completed_at.strftime("%Y-%m-%d"),
              sku,
              data[:qty],
              data[:line_item].rakuten_linkshare_amount * -1,
              data[:line_item].currency,
              "\t",
              "\t",
              "\t",
              data[:line_item].name,
            ].map { |x| x.to_s.gsub('|', ' ') }.join('|')
          end
        end

        f.close

        filename
      end

      def rakuten_linkshare_cancel_file_filename
        "#{SpreeRakutenLinkshare::Config.merchant_id}_trans#{DateTime.now.strftime("%Y%m%d")}.txt"
      end
    end

    def rakuten_sku_list
      line_items.map { |li| li.variant.sku.gsub('|', ' ') }.join('|')
    end

    def rakuten_qty_list
      line_items.map { |li| li.quantity }.join('|')
    end

    def rakuten_amt_list
      line_items.map { |li| ((li.price.to_f + li.promo_total.to_f) * li.quantity * 100).to_i }.join('|')
    end

    def rakuten_name_list
      line_items.map { |li| URI::escape(li.variant.name.gsub('|', '')) }.join('|')
    end
  end
end
