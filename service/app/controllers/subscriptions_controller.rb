# frozen_string_literal: true

class SubscriptionsController < ApplicationController
  before_action :set_client, only: %i[index create]
  before_action :set_subscription, only: %i[show update destroy]

  # GET /clients/1/subscriptions
  def index
    @subscriptions = @client.subscriptions

    render json: @subscriptions
  end

  # GET /subscriptions/1
  def show
    render json: @subscription
  end

  # POST /clients/1/subscriptions
  def create
    @subscription = @client.subscriptions.build(subscription_params)

    if @subscription.save
      render json: @subscription, status: :created, location: @subscription
    else
      render json: @subscription.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /subscriptions/1
  def update
    if @subscription.update(subscription_params)
      render json: @subscription
    else
      render json: @subscription.errors, status: :unprocessable_entity
    end
  end

  # DELETE /subscriptions/1
  def destroy
    @subscription.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_subscription
    @subscription = Subscription.find(params[:id])
  end

  def set_client
    @client = Client.find(params[:client_id])
  end

  # Only allow a trusted parameter "white list" through.
  def subscription_params
    params.require(:subscription).permit(:imei, :phone_model, :full_price, :full_price, :payments)
  end
end
