require 'net/ftp'

module Spree
  module Product::RakutenLinkshare

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods

      def upload_rakuten_linkshare_product_feed
        raise 'Rakuten FTP Host not defined' unless SpreeRakutenLinkshare::Config.ftp_host.present?
        raise 'Rakuten FTP Username not defined' unless SpreeRakutenLinkshare::Config.ftp_username.present?
        raise 'Rakuten FTP Password not defined' unless SpreeRakutenLinkshare::Config.ftp_password.present?

        primary_file = create_rakuten_linkshare_product_feed_primary_file

        Net::FTP.open(SpreeRakutenLinkshare::Config.ftp_host) do |ftp|
          ftp.login SpreeRakutenLinkshare::Config.ftp_username, SpreeRakutenLinkshare::Config.ftp_password
          ftp.puttextfile primary_file
        end
      end

      def create_rakuten_linkshare_product_feed_primary_file
        filename = Rails.root.join('tmp', rakuten_linkshare_product_feed_primary_file_filename)

        f = File.new(filename, 'w')
        f.print rakuten_linkshare_product_feed_primary_header + "\n"

        record_count = 0
        products_for_rakuten_linkshare_product_feed.find_each do |p|
          f.print p.rakuten_linkshare_product_feed_primary_file_record + "\n"
          record_count += 1
        end

        f.print ['TRL', record_count].join('|') + "\n"
        f.close

        filename
      end

      def rakuten_linkshare_product_feed_primary_file_filename
        "#{SpreeRakutenLinkshare::Config.merchant_id}_nmerchandis#{DateTime.now.strftime("%Y%m%d")}.txt"
      end

      def rakuten_linkshare_product_feed_primary_header
        ['HDR', SpreeRakutenLinkshare::Config.merchant_id, rakuten_linkshare_product_feed_header_company_name, rakuten_linkshare_product_feed_header_timestamp].map { |x| x.gsub('|', ' ') }.join('|')
      end

      def rakuten_linkshare_product_feed_header_company_name
        Spree::Config.site_name
      end

      def rakuten_linkshare_product_feed_header_timestamp
        DateTime.now.strftime("%Y-%m-%d/%H:%M:%S")
      end

      def products_for_rakuten_linkshare_product_feed
        all
      end
    end

    def rakuten_linkshare_product_feed_primary_file_record
      [
        rakuten_linkshare_product_feed_primary_file_record_product_id,
        rakuten_linkshare_product_feed_primary_file_record_product_name,
        rakuten_linkshare_product_feed_primary_file_record_sku_number,
        rakuten_linkshare_product_feed_primary_file_record_primary_category,
        rakuten_linkshare_product_feed_primary_file_record_secondary_categories,
        rakuten_linkshare_product_feed_primary_file_record_product_url,
        rakuten_linkshare_product_feed_primary_file_record_product_image_url,
        rakuten_linkshare_product_feed_primary_file_record_buy_url,
        rakuten_linkshare_product_feed_primary_file_record_short_description,
        rakuten_linkshare_product_feed_primary_file_record_long_description,
        rakuten_linkshare_product_feed_primary_file_record_discount,
        rakuten_linkshare_product_feed_primary_file_record_discount_type,
        rakuten_linkshare_product_feed_primary_file_record_sale_price,
        rakuten_linkshare_product_feed_primary_file_record_retail_price,
        rakuten_linkshare_product_feed_primary_file_record_begin_date,
        rakuten_linkshare_product_feed_primary_file_record_end_date,
        rakuten_linkshare_product_feed_primary_file_record_brand,
        rakuten_linkshare_product_feed_primary_file_record_shipping,
        rakuten_linkshare_product_feed_primary_file_record_is_deleted_flag,
        rakuten_linkshare_product_feed_primary_file_record_keywords,
        rakuten_linkshare_product_feed_primary_file_record_is_all_flag,
        rakuten_linkshare_product_feed_primary_file_record_manufacturer_part_number,
        rakuten_linkshare_product_feed_primary_file_record_manufacturer_name,
        rakuten_linkshare_product_feed_primary_file_record_shipping_information,
        rakuten_linkshare_product_feed_primary_file_record_availability,
        rakuten_linkshare_product_feed_primary_file_record_upc,
        rakuten_linkshare_product_feed_primary_file_record_class_id,
        rakuten_linkshare_product_feed_primary_file_record_is_product_link_flag,
        rakuten_linkshare_product_feed_primary_file_record_is_storefront_flag,
        rakuten_linkshare_product_feed_primary_file_record_is_merchandiser_flag,
        rakuten_linkshare_product_feed_primary_file_record_currency,
        rakuten_linkshare_product_feed_primary_file_record_m1,
      ].map { |x| x.to_s.gsub('|', ' ') }.join('|')
    end

    def rakuten_linkshare_product_feed_primary_file_record_product_id
      self.id
    end

    def rakuten_linkshare_product_feed_primary_file_record_product_name
      self.name
    end

    def rakuten_linkshare_product_feed_primary_file_record_sku_number
      self.sku
    end

    def rakuten_linkshare_product_feed_primary_file_record_primary_category
      self.taxons.any? ? self.taxons.first.name.slice(0,50) : ''
    end

    def rakuten_linkshare_product_feed_primary_file_record_secondary_categories
      self.taxons.any? ? self.taxons[1..self.taxons.length-1].map { |t| t.name }.join('~~') : ''
    end

    def rakuten_linkshare_product_feed_primary_file_record_product_url
      Spree::Config.site_url + "/products/" + self.slug
    end

    def rakuten_linkshare_product_feed_primary_file_record_product_image_url
      self.images.any? ? Spree::Config.site_url + self.images.first.attachment.url : ''
    end

    def rakuten_linkshare_product_feed_primary_file_record_buy_url
    end

    def rakuten_linkshare_product_feed_primary_file_record_short_description
      HTMLEntities.new.decode self.short_description.strip_html_tags.slice(0, 500) rescue ""
    end

    def rakuten_linkshare_product_feed_primary_file_record_long_description
      HTMLEntities.new.decode self.description.strip_html_tags.slice(0, 2000) rescue ""
    end

    def rakuten_linkshare_product_feed_primary_file_record_discount
    end

    def rakuten_linkshare_product_feed_primary_file_record_discount_type
    end

    def rakuten_linkshare_product_feed_primary_file_record_sale_price
    end

    def rakuten_linkshare_product_feed_primary_file_record_retail_price
    end

    def rakuten_linkshare_product_feed_primary_file_record_begin_date
      self.available? ? self.available_on.strftime('%m/%d/%Y') : ''
    end

    def rakuten_linkshare_product_feed_primary_file_record_end_date
    end

    def rakuten_linkshare_product_feed_primary_file_record_brand
    end

    def rakuten_linkshare_product_feed_primary_file_record_shipping
    end

    def rakuten_linkshare_product_feed_primary_file_record_is_deleted_flag
      self.available? ? 'N' : 'Y'
    end

    def rakuten_linkshare_product_feed_primary_file_record_keywords
    end

    def rakuten_linkshare_product_feed_primary_file_record_is_all_flag
      'Y'
    end

    def rakuten_linkshare_product_feed_primary_file_record_manufacturer_part_number
    end

    def rakuten_linkshare_product_feed_primary_file_record_manufacturer_name
    end

    def rakuten_linkshare_product_feed_primary_file_record_shipping_information
    end

    def rakuten_linkshare_product_feed_primary_file_record_availability
      self.total_on_hand > 0 ? "In Stock" : "Out of Stock"
    end

    def rakuten_linkshare_product_feed_primary_file_record_upc
    end

    def rakuten_linkshare_product_feed_primary_file_record_class_id
    end

    def rakuten_linkshare_product_feed_primary_file_record_is_product_link_flag
      'Y'
    end

    def rakuten_linkshare_product_feed_primary_file_record_is_storefront_flag
      'N'
    end

    def rakuten_linkshare_product_feed_primary_file_record_is_merchandiser_flag
      'Y'
    end

    def rakuten_linkshare_product_feed_primary_file_record_currency
      self.currency
    end

    def rakuten_linkshare_product_feed_primary_file_record_m1
    end
  end
end
