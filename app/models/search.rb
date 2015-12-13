class Search < ActiveRecord::Base
  require 'open-uri'

  has_many :products

  validates :query, presence: true

  # Parsed items from JSON parser
  #
  # Structure of JSON:
  #   [
  #     {
  #       "title" => "Nikon",
  #       "viewItemURL" => "http://www.ebay.com/itm",
  #       "sellingStatus" => [{
  #         "convertedCurrentPrice' => {
  #           { "@currencyId" => "USD", "__value__" => "1209.55" }
  #         },
  #       }],
  #       "subtitle" => "Nikon 500D"
  #     }
  #   ]
  def parsed_items
    crawler_data['findItemsAdvancedResponse'][0]['searchResult'][0]['item']
  rescue NoMethodError
    []
  end

  # JSON parser
  def crawler_data
    @crawler_data ||= JSON.load(open(crawler_url))
  end

  # URL of Finding API
  # http://www.developer.ebay.com/DevZone/finding/CallRef/findItemsAdvanced.html
  #
  # Simple request using only keyword's search
  def crawler_url
    "http://svcs.ebay.com/services/search/FindingService/v1?OPERATION-NAME=findItemsAdvanced" +
      "&SERVICE-VERSION=1.9.0" +
      "&SECURITY-APPNAME=#{Settings.ebay.app_id}" +
      "&RESPONSE-DATA-FORMAT=JSON" +
      "&REST-PAYLOAD" +
      "&keywords=#{query}" 
  end

  #def find_products
    #EbayCrawlerJob.perform_later(id)
  #end
end
