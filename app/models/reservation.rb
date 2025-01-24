class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :computer

  validates :user_id, :computer_id, :start_time, :end_time, presence: true
  validate :end_time_after_start_time
  validate :no_overlapping_reservations

  private

  def end_time_after_start_time
    if start_time.present? && end_time.present? && end_time <= start_time
      errors.add(:end_time, "must be after the start time")
    end
  end

  def no_overlapping_reservations
    if computer_id.present? && start_time.present? && end_time.present?
      overlapping_reservations = Reservation.where(computer_id: computer_id)
                                            .where.not(id: id)
        .where("start_time < ? AND end_time > ?", end_time, start_time)
      if overlapping_reservations.exists?
        errors.add(:base, "The selected computer is already reserved during this time period")
      end
    end
  end
end
