# frozen_string_literal: true

class Subscription < ApplicationRecord
  belongs_to :client

  validates :phone_model, presence: true
  validates :full_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :payments, presence: true, numericality: { greater_than_or_equal_to: 0 }

  # IMEI numbers have multiple variations:
  # - IMEI: AA-BBBBBB-CCCCCC-D (last digit is a checksum)
  # - IMEISV: AA-BBBBBB-CCCCCC-EE (last two digits are the software version of the phone)
  # The first 14 digits are the same between the two variations, so we only store them.
  # Some methods of getting the IMEI from a given phone may only output the first 14 digits anyway
  # TODO: We also don't bother with the checksum, at least for now
  validates :imei, presence: true, length: 14..16, format: /\d{14,16}/
  before_validation :clean_up_imei
  after_validation :truncate_imei
  
  def clean_up_imei
    # We discard dashes, but not other characters (so we can create meaningful error messages)
    self.imei = imei.tr('-', '')
  end

  def truncate_imei
    # Since we don't know what variation will be given (15 or 16 digits), we just truncate it in any case
    self.imei = imei[0...14]
  end
end
