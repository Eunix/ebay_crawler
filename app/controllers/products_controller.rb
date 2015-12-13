class ProductsController < ApplicationController
  before_action :set_search

  def index
    @products = @search.products
  end

  private

  def set_search
    @search = Search.find params[:search_id]
  end
end
