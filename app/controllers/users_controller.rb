class UsersController < ApplicationController

  before_action :authenticate_user!

  def index
    @users = User.all
  end

  def account
    @user = current_user
    @deposits = @user.deposits.order("created_at desc").limit(10)
  end

  def deposit
    @user = current_user
    @game_centers = GameCenter.all
  end

  def show
    @user = User.find(params[:id])
    unless current_user.admin?
      unless @user == current_user
        redirect_to root_path, :alert => "Access denied."
      end
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(secure_params)
      redirect_to users_path, :notice => "User updated."
    else
      redirect_to users_path, :alert => "Unable to update user."
    end
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    redirect_to users_path, :notice => "User deleted."
  end

  private


  def secure_params
    params.require(:user).permit(:role)
  end

end
