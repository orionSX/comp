class UsersController < ApplicationController
  before_action :set_user, only: [ :show, :edit, :update, :destroy ]

  def index
    @page = (params[:page] || 1).to_i
    @per_page = 5
    @users = User.all
    @users = @users.where("email LIKE ?", "%#{params[:email_filter]}%") if params[:email_filter].present?
    @users = @users.offset((@page - 1) * @per_page).limit(@per_page)
    @total_pages = (User.count.to_f / @per_page).ceil
  end

  def show
  @reservations=@user.reservations
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save

      redirect_to @user, notice: "User was successfully created."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: "User was successfully updated."
    else
      render :edit
    end
  end

  def destroy
begin
    @user.destroy!
    redirect_to users_url, notice: "User was successfully deleted."
  rescue ActiveRecord::RecordNotDestroyed => e
    redirect_to users_url, alert: e.record.errors.full_messages.to_sentence
  rescue => e
    redirect_to users_url, alert: "An unexpected error occurred: #{e.message}"
  end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email)
  end
end
