module SpreeRakutenLinkshare
  class Configuration < Spree::Preferences::Configuration
    preference :merchant_id, :string
  end
end
