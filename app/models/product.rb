class Product < ActiveRecord::Base
  belongs_to :search

  def self.create_from_api(api_item)
    create(
      name: api_item['title'].try(:first),
      link: api_item['viewItemURL'].try(:first),
      price: api_item['sellingStatus'][0]['convertedCurrentPrice'][0]['__value__'],
      description: api_item['subtitle'].try(:first)
    )
  end

  def self.create_from_crawler(crawler_data)
    create(
      name: crawler_data.css('.lvtitle').text.strip,
      link: crawler_data.css('.lvtitle a').first['href'],
      price: Monetize.parse(crawler_data.css('.lvprice span').children.first.text).to_f
    )
  end
end
