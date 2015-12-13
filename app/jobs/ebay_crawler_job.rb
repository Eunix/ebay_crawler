class EbayCrawlerJob < ActiveJob::Base
  queue_as :default

  def perform(query)
    ActiveRecord::Base.connection_pool.with_connection do
      #Product.create name: query   
    end
  end

  def ebay
  end
end
