class UsersController < ApplicationController
  before_action :set_parents

  def edit
  end

  def update
    if current_user.update(user_params)
      redirect_to root_path
    else
      render :edit
    end
  end
  
  def show
  end

  
  private

  def user_params
    params.require(:user).permit(:nickname, :email [:url, :_destroy, :id])
  end

  def set_parents
    @parents = Category.where(ancestry: nil)
  end

end
