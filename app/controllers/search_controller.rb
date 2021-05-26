class SearchController < ApplicationController
  
  def new
    @resources =  SearchSphinxService::RESOURCES.keys
  end

  def result
    @result = SearchSphinxService.search(params_search)
  end

  def params_search
    params.permit(:resources,:search,:commit,:controller,:action)
  end
end
