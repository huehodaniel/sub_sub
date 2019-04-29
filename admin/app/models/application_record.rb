# frozen_string_literal: true

class ApplicationRecord
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :created_at, :datetime
  attribute :updated_at, :datetime

  def to_param
    id&.to_s
  end
end
