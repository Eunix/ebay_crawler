class Search < ActiveRecord::Base
  require 'open-uri'

  has_many :products

  validates :query, presence: true

  def fetch_products
    if Settings.ebay.crawler
      fetch_products_with_crawler
    else
      fetch_products_with_api
    end
  end

  def fetch_products_with_api
    api_items.each do |api_item|
      products.create_from_api api_item
    end
  end

  def fetch_products_with_crawler
    crawler_items.each do |crawler_item|
      products.create_from_crawler crawler_item
    end
  end

  # Parsed items from JSON API parser
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
  def api_items
    api_data['findItemsAdvancedResponse'][0]['searchResult'][0]['item']
  rescue NoMethodError
    []
  end

  # JSON API parser
  def api_data
    @api_data ||= JSON.load(open(api_url))
  end

  # URL of Finding API
  # http://www.developer.ebay.com/DevZone/finding/CallRef/findItemsAdvanced.html
  #
  # Simple request using only keyword's search
  def api_url
    "http://svcs.ebay.com/services/search/FindingService/v1?OPERATION-NAME=findItemsAdvanced" +
      "&SERVICE-VERSION=1.9.0" +
      "&SECURITY-APPNAME=#{Settings.ebay.app_id}" +
      "&RESPONSE-DATA-FORMAT=JSON" +
      "&REST-PAYLOAD" +
      "&keywords=#{query}" 
  end

  def crawler_items
    crawler_data.css('.sresult')
  end

  def crawler_data
    @crawler_data ||= Nokogiri::HTML(open(crawler_url), nil, 'utf-8')
  end

  # URL of eBay Search Page
  def crawler_url
    "http://www.ebay.com/sch/i.html?_nkw=#{query}"
  end
end
