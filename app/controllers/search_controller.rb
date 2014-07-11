class SearchController < ApplicationController
  
  require "#{Rails.root}/lib/tasks/task_utilities"
  include TaskUtilities

  def search

    type = encode(params[:type]) if params[:type]
    word = params[:word]

    if type.nil?
      @item = searchInAllModels(word)
    elsif type == "municipality" || type == "province" || type == "region"
      @item = findItemByName(type.capitalize, word)
    end

    respond_to do |format|
      # format.html
      format.json { render json: @item }
    end
  end

  def searchInAllModels word
    item = findItemByName("Municipality", word)
    if item == nil
      item = findItemByName("Province", word)
      if item == nil
        item = findItemByName("Region", word)
      end
    end
    return item
  end

end