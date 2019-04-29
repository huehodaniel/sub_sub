# frozen_string_literal: true

require 'test_helper'

class ClientTest < ActiveSupport::TestCase
  test "happy path" do
    client = Client.new(
      cpf: CPF.generate(true),
      email: Faker::Internet.email,
      name: Faker::Name.name
    )

    assert client.save
  end

  test "valid name" do
    wrong = Client.new(
      cpf: CPF.generate(true),
      email: Faker::Internet.email,
      name: ''
    )

    # Test name presence
    assert wrong.invalid?
    assert wrong.errors.added?(:name, :blank)
  end

  test "valid CPF" do
    wrong = Client.new(
      email: Faker::Internet.email,
      name: Faker::Name.name
    )
  
    # Test CPF presence
    wrong.cpf = ''
    assert wrong.invalid?
    assert wrong.errors.added?(:cpf, :blank)

    # Test CPF length
    wrong.cpf = CPF.generate # this generates an unformmatted CPF, we accept only formatted (with 14 characters)
    assert wrong.invalid?
    assert wrong.errors.added?(:cpf, :wrong_length, count: 14)

    # Test CPF format
    wrong.cpf = "000.000.000-00"
    assert wrong.invalid?
    assert wrong.errors.added?(:cpf, :invalid_cpf, value: "000.000.000-00")
  end

  test "unique CPF" do
    client = Client.create!(
      cpf: CPF.generate(true),
      email: Faker::Internet.email,
      name: Faker::Name.name
    )

    wrong = Client.new(
      cpf: client.cpf,
      email: Faker::Internet.email,
      name: Faker::Name.name
    )
  
    # Test uniqueness validation
    assert wrong.invalid?
    assert wrong.errors.added?(:cpf, :taken, value: client.cpf)

    # Test constraint
    assert_raise(ActiveRecord::RecordNotUnique) { wrong.save(validate: false) }
  end

  test "valid email" do
    wrong = Client.new(
      cpf: CPF.generate(true),
      email: "wrong.email&hotmail.com.br",
      name: Faker::Name.name
    )
  
    # Test email validation
    assert wrong.invalid?
    assert wrong.errors.added?(:email, :invalid_email, value: "wrong.email&hotmail.com.br")
  end
end
