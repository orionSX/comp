class User < ApplicationRecord
  has_many :reservations, dependent: :restrict_with_error
 validates :email, presence: true, uniqueness: true, format: {
    with: URI::MailTo::EMAIL_REGEXP,
    message: "must be a valid email address"
  }

  validates :name, presence: true
  before_destroy :check_for_reservations

  private

  def check_for_reservations
    if reservations.exists?

      errors.add(:base, "Cannot delete a user that has existing reservations.")
      throw(:abort)
    end
  end
end
