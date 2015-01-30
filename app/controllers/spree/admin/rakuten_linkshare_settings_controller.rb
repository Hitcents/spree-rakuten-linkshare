module Spree
  module Admin
    class RakutenLinkshareSettingsController < Admin::BaseController
      def edit
        render :edit
      end

      def update
        SpreeRakutenLinkshare::Config[:merchant_id] = params[:merchant_id]
        flash[:success] = Spree.t(:successfully_updated, :resource => Spree.t(:rakuten_linkshare_settings))
        render :edit
      end
    end
  end
end
