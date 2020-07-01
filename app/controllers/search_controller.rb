class SearchController < ApplicationController
  def index
    authorize! :index, :search

    model = if params[:context] == 'All'
              ThinkingSphinx
            else
              params[:context].classify.constantize
            end

    @results = model.search(params[:q])
  end
end
