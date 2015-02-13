module Spree
  module Admin
    class RakutenLinkshareSettingsController < Admin::BaseController
      def edit
        render :edit
      end

      def update
        [:merchant_id, :ftp_host, :ftp_username, :ftp_password].each do |setting|
          SpreeRakutenLinkshare::Config[setting] = params[setting]
        end
        flash[:success] = Spree.t(:successfully_updated, :resource => Spree.t(:rakuten_linkshare_settings))
        render :edit
      end
    end
  end
end
