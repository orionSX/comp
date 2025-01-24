class ReservationsController < ApplicationController
  before_action :set_reservation, only: [ :show, :edit, :update, :destroy ]

  def index
    @page = (params[:page] || 1).to_i
    @per_page = 5
    @reservations = Reservation.all
    if params[:date_filter].present?
      date = Date.parse(params[:date_filter]) rescue nil
      @reservations = @reservations.where("DATE(start_time) = ?", date) if date
    end
    @reservations = @reservations.offset((@page - 1) * @per_page).limit(@per_page)
    @total_pages = (Reservation.count.to_f / @per_page).ceil
  end

  def show
  end

  def new
    @reservation = Reservation.new
  end

  def create
    @reservation = Reservation.new(reservation_params)
    if overlapping_reservation?(@reservation)
      flash.now[:alert] = "The computer is already reserved for this time period."
      render :new
    elsif @reservation.start_time >= @reservation.end_time
      flash.now[:alert] = "Start time must be before end time."
      render :new
    elsif @reservation.save
      redirect_to @reservation, notice: "Reservation was successfully created."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if overlapping_reservation?(@reservation)
      flash.now[:alert] = "The computer is already reserved for this time period."
      render :edit
    elsif @reservation.start_time >= @reservation.end_time
      flash.now[:alert] = "Start time must be before end time."
      render :edit
    elsif @reservation.update(reservation_params)
      redirect_to @reservation, notice: "Reservation was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @reservation.destroy
    redirect_to reservations_url, notice: "Reservation was successfully deleted."
  end

  private

  def set_reservation
    @reservation = Reservation.find(params[:id])
  end

  def reservation_params
    params.require(:reservation).permit(:user_id, :computer_id, :start_time, :end_time)
  end

  def overlapping_reservation?(reservation)
    Reservation.where(computer_id: reservation.computer_id)
                .where.not(id: reservation.id)
                .where("start_time < ? AND end_time > ?", reservation.end_time, reservation.start_time)
                .exists?
  end
end
