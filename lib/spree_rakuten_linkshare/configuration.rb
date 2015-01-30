module SpreeRakutenLinkshare
  class Configuration < Spree::Preferences::Configuration
    puts "I am in SpreeRakutenLinkshare::Configuration"
    preference :merchant_id, :string
  end
end
