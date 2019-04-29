# frozen_string_literal: true

class Subscription < ApplicationRecord
  attribute :id, :integer
  attribute :client_id, :integer
  attribute :phone_model, :string
  attribute :imei, :string
  attribute :full_price, :decimal
  attribute :payments, :integer
end
