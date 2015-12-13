class EbayCrawlerJob < ActiveJob::Base
  queue_as :default

  def perform(search_id)
    ActiveRecord::Base.connection_pool.with_connection do
      search = Search.find_by_id search_id
      return unless search

      search.parsed_items.each do |parsed_item|
        search.products.create(
          name: parsed_item['title'].try(:first),
          link: parsed_item['viewItemURL'].try(:first),
          price: parsed_item['sellingStatus'][0]['convertedCurrentPrice'][0]['__value__'],
          description: parsed_item['subtitle'].try(:first)
        )
      end
    end
  end
end
