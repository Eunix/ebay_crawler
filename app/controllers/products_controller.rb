class ProductsController < ApplicationController
  def index
    EbayCrawlerJob.perform_later(params[:query]) if params[:query]
  end
end
