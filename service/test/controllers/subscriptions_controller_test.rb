# frozen_string_literal: true

require 'test_helper'

class SubscriptionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @client = clients(:one)
    @subscription = subscriptions(:one)
    @new = @client.subscriptions.build(
      full_price: Faker::Commerce.price,
      imei: Faker::Code.imei,
      phone_model: Faker::Commerce.product_name,
      payments: Faker::Number.positive(1, 100).to_i
    )
  end

  test 'should get index' do
    get client_subscriptions_url(@client), as: :json
    assert_response :success
  end

  test 'should create subscription' do
    assert_difference('Subscription.count') do
      post client_subscriptions_url(@client), params: { subscription: { full_price: @new.full_price, imei: @new.imei, phone_model: @new.phone_model, payments: @new.payments } }, as: :json
    end

    assert_response 201
  end

  test 'should show subscription' do
    get subscription_url(@subscription), as: :json
    assert_response :success
  end

  test 'should update subscription' do
    patch subscription_url(@subscription), params: { subscription: { full_price: @subscription.full_price, imei: @subscription.imei, phone_model: @subscription.phone_model, payments: @subscription.payments } }, as: :json
    assert_response 200
  end

  test 'should destroy subscription' do
    assert_difference('Subscription.count', -1) do
      delete subscription_url(@subscription), as: :json
    end

    assert_response 204
  end
end
