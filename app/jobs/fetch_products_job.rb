class FetchProductsJob < ActiveJob::Base
  queue_as :default

  def perform(search_id)
    ActiveRecord::Base.connection_pool.with_connection do
      search = Search.find_by_id search_id
      return unless search

      search.fetch_products
    end
  end
end
