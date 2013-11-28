class UsersController < ApplicationController
  before_filter :redirect_nonsigned_in_user, only:  [:index, :edit, :update, :destroy]
  before_filter :redirect_signed_in_user, only: [:new, :create]
  before_filter :correct_user, only:    [:edit, :update]
  before_filter :admin_user, only: :destroy
  # before_filter :prevent_self_deletion, only: [:destroy]

  def new
    @user = User.new
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def edit
  end

  def destroy
    unless current_user == ( user = User.find(params[:id]) )
      user.destroy
      flash[:success] = "User destroyed"
    end
      redirect_to users_url
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end

  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  private
    def redirect_nonsigned_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in."
      end
    end

    def redirect_signed_in_user
      redirect_to root_url if signed_in?
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
