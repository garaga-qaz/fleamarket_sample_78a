class CategoriesController < ApplicationController
  before_action :set_parents

  def search
    respond_to do |format|
      format.html
      format.json do
        if params[:parent_id]
          @childrens = Category.find(params[:parent_id]).children
        elsif params[:children_id]
          @grandChilds = Category.find(params[:children_id]).children
        end
      end
    end
  end

  private

  def set_parents
    @parents = Category.where(ancestry: nil)
  end

end
