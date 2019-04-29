# frozen_string_literal: true

class SubscriptionsController < ApplicationController
  before_action :set_client_id, only: %i[index new create]
  before_action :set_subscription, only: %i[show edit update destroy]

  # GET /clients/1/subscriptions
  def index
    *, @subscriptions = @service.get_subscriptions(@client_id)
  end

  # GET /subscriptions/1
  def show; end

  # GET /clients/1/subscriptions/new
  def new
    @subscription = Subscription.new
  end

  # GET /subscriptions/1/edit
  def edit; end

  # POST /subscriptions
  def create
    @subscription = Subscription.new(subscription_params)

    respond_to do |format|
      ok, result = @service.create_subscription(@client_id, subscription_params)

      if ok
        format.html { redirect_to subscription_path(result), notice: 'Subscription was successfully created.' }
      else
        result.populate_model(@subscription)
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /subscriptions/1
  def update
    respond_to do |format|
      ok, result = @service.update_subscription(params[:id], subscription_params)

      if ok
        format.html { redirect_to subscription_path(@subscription), notice: 'Subscription was successfully updated.' }
      else
        @subscription = Subscription.new(subscription_params.merge(
                                           'client_id' => @subscription.client_id, 'id' => params[:id]
                                         ))
        result.populate_model(@subscription)

        format.html { render :edit }
      end
    end
  end

  # DELETE /subscriptions/1
  def destroy
    @service.delete_subscription(params[:id])

    respond_to do |format|
      format.html { redirect_to client_subscriptions_url(@subscription.client_id), notice: 'Subscription was successfully destroyed.' }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_subscription
    *, @subscription = @service.get_subscription(params[:id])
  end

  def set_client_id
    @client_id = params[:client_id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def subscription_params
    params.require(:subscription).permit(:phone_model, :imei, :full_price, :payments)
  end
end
