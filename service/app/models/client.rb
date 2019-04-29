# frozen_string_literal: true

class Client < ApplicationRecord
  has_many :subscriptions

  validates :name,  presence: true
  validates :email, presence: true, email: true

  # CPF needs to be fully formatted
  validates :cpf,   presence: true, cpf: {strict: true}, uniqueness: true, length: { is: 14 }
end
