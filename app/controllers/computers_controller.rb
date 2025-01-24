class ComputersController < ApplicationController
  before_action :set_computer, only: [ :show, :edit, :update, :destroy ]

  def index
    @page = (params[:page] || 1).to_i
    @per_page = 5
    @computers = Computer.all
    @computers = @computers.where("name LIKE ?", "%#{params[:name_filter]}%") if params[:name_filter].present?
    @computers = @computers.offset((@page - 1) * @per_page).limit(@per_page)
    @total_pages = (Computer.count.to_f / @per_page).ceil
  end

  def show
    @reservations =Reservation.where(computer_id: @computer.id)
  end

  def new
    @computer = Computer.new
  end

  def create
    @computer = Computer.new(computer_params)
    if @computer.save
      redirect_to @computer, notice: "Computer was successfully created."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @computer.update(computer_params)
      redirect_to @computer, notice: "Computer was successfully updated."
    else
      render :edit
    end
  end

  def destroy
begin
    @computer.destroy!
    redirect_to computers_url, notice: "Computer was successfully deleted."
  rescue ActiveRecord::RecordNotDestroyed => e
    redirect_to computers_url, alert: e.record.errors.full_messages.to_sentence
  rescue => e
    redirect_to computers_url, alert: "An unexpected error occurred: #{e.message}"
  end
  end

  private

  def set_computer
    @computer = Computer.find(params[:id])
  end

  def computer_params
    params.require(:computer).permit(:name, :video_card, :cpu, :motherboard, :monitor, :keyboard, :mouse, :price_per_hour)
  end
end
