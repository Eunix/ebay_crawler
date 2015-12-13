class SearchesController < ApplicationController
  # GET /searches/new
  # GET /
  def new
    @search = Search.new
  end

  # POST /searches
  def create
    @search = Search.create search_params
    EbayCrawlerJob.perform_later(@search) if @search
  end
  
  private

  def search_params
    params.require(:search).permit(:query)
  end
end
