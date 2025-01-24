class Computer < ApplicationRecord
  has_many :reservations, dependent: :restrict_with_error

  validates :name, :video_card, :cpu, :motherboard, :monitor, :keyboard, :mouse, presence: true
  validates :price_per_hour, presence: true, numericality: { greater_than: 0, message: "must be a positive number" }
  before_destroy :check_for_reservations

  private

  def check_for_reservations
    if reservations.exists?
      errors.add(:base, "Cannot delete a computer that has existing reservations.")
      throw(:abort)
    end
  end
end
