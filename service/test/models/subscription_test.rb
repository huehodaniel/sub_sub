# frozen_string_literal: true

require 'test_helper'

class SubscriptionTest < ActiveSupport::TestCase
  setup do
    @client = clients(:one)
  end

  test "happy path" do
    subscription = @client.subscriptions.build(
      full_price: Faker::Commerce.price,
      imei: Faker::Code.imei,
      phone_model: Faker::Commerce.product_name,
      payments: Faker::Number.positive(1, 100).to_i
    )

    assert subscription.save
  end

  test "IMEI clean-up/truncation" do
    formatted_imei = "11-222222-333333-44"

    subscription = @client.subscriptions.build(
      full_price: Faker::Commerce.price,
      imei: formatted_imei,
      phone_model: Faker::Commerce.product_name,
      payments: Faker::Number.positive(1, 100).to_i
    )

    assert subscription.save
    
    imei = formatted_imei.tr('-', '')
    assert imei[0..13] == subscription.imei
  end

  test "valid phone model" do
    wrong = @client.subscriptions.build(
      full_price: Faker::Commerce.price,
      imei: Faker::Code.imei,
      phone_model: '',
      payments: Faker::Number.positive(1, 100).to_i
    )
  
    # Test phone presence
    assert wrong.invalid?
    assert wrong.errors.added?(:phone_model, :blank)
  end

  test "valid IMEI" do
    wrong = @client.subscriptions.build(
      full_price: Faker::Commerce.price,
      phone_model: Faker::Commerce.product_name,
      payments: Faker::Number.positive(1, 100).to_i
    )
  
    # Test IMEI presence
    wrong.imei = ''
    assert wrong.invalid?
    assert wrong.errors.added?(:imei, :blank)

    # Test IMEI length
    wrong.imei = '11-223344-333333-44-55'
    assert wrong.invalid?
    assert wrong.errors.added?(:imei, :too_long, count: 16)

    wrong.imei = '11-223344-33333'
    assert wrong.invalid?
    assert wrong.errors.added?(:imei, :too_short, count: 14)
    
    # Test IMEI format
    wrong.imei = 'AA-BBBBBB-CCCCCC-EE'
    assert wrong.invalid?
    assert wrong.errors.added?(:imei, :invalid, value: 'AABBBBBBCCCCCCEE')
  end

  test "valid full price" do
    wrong = @client.subscriptions.build(
      imei: Faker::Code.imei,
      phone_model: Faker::Commerce.product_name,
      payments: Faker::Number.positive(1, 100).to_i
    )
  
    # Test full price presence
    wrong.full_price = ''
    assert wrong.invalid?
    assert wrong.errors.added?(:full_price, :blank)

    # Test full price positivity
    wrong.full_price = -100.00
    assert wrong.invalid?
    assert wrong.errors.added?(:full_price, :greater_than_or_equal_to, value: -100.00, count: 0)
  end

  test "valid payments" do
    wrong = @client.subscriptions.build(
      imei: Faker::Code.imei,
      phone_model: Faker::Commerce.product_name,
      full_price: Faker::Commerce.price
    )
  
    # Test payments presence
    wrong.payments = nil
    assert wrong.invalid?
    assert wrong.errors.added?(:payments, :blank)
    
    # Test payments positivity
    wrong.payments = -1
    assert wrong.invalid?
    assert wrong.errors.added?(:payments, :greater_than_or_equal_to, value: -1, count: 0)
  end

end
