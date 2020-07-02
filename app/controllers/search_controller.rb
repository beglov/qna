class SearchController < ApplicationController
  def index
    authorize! :index, :search
    @results = Services::Search.new(params[:context], params[:q]).call
  end
end
