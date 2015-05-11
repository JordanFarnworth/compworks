class UsersController < ApplicationController

  before_action :find_user, only: [:show, :edit, :update, :destroy]
  before_action :find_users, only: [:index]


  def index
    @users = User.all
  end

  def show

  end

  def find_user
    @user = User.active.find params[:id]
  end

  def find_users
    @users = User.all.active
  end

  def create
    @user = User.new user_params
    if @user.save
      redirect_to @user
    else
      render 'new'
    end
  end

  private
  def flash_message(method = 'update')
    flash[:success] = "New User <a class=\"link-color\" href=#{user_path(@user)}>#{@user.name}</a> #{method == 'update' ? 'updated' : 'created'}!".html_safe
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

end
