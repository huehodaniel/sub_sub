# frozen_string_literal: true

class Client < ApplicationRecord
  attribute :id, :integer
  attribute :name, :string
  attribute :cpf, :string
  attribute :email, :string
end
