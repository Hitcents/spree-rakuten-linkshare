module SpreeRakutenLinkshare
  class Configuration < Spree::Preferences::Configuration
    preference :merchant_id, :string
    preference :ftp_host, :string
    preference :ftp_username, :string
    preference :ftp_password, :string
  end
end
