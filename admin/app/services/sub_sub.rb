# frozen_string_literal: true

class SubSub
  attr_reader :http, :endpoint

  def initialize(endpoint)
    @http = HTTP.persistent endpoint
  end

  # GET /clients
  def all_clients
    request Client, :get, '/clients', collection: true
  end

  # GET /clients/1
  def get_client(id)
    request Client, :get, "/clients/#{id}"
  end

  # POST /clients
  def create_client(payload)
    request Client, :post, '/clients', payload.as_json
  end

  # PUT /clients/1
  def update_client(id, payload)
    request Client, :put, "/clients/#{id}", payload.as_json.except('id')
  end

  # DELETE /clients/1
  def delete_client(id)
    request Client, :delete, "/clients/#{id}", no_result: true
  end

  # GET /clients/1/subscriptions
  def get_subscriptions(client_id)
    request Subscription, :get, "/clients/#{client_id}/subscriptions", collection: true
  end

  # GET /subscriptions/1
  def get_subscription(id)
    request Subscription, :get, "/subscriptions/#{id}"
  end

  # POST /clients/1/subscriptions
  def create_subscription(client_id, payload)
    request Subscription, :post, "/clients/#{client_id}/subscriptions", payload.as_json
  end

  # PUT /subscriptions/1
  def update_subscription(id, payload)
    request Subscription, :put, "/subscriptions/#{id}", payload.as_json.except('id')
  end

  # DELETE /clients/1
  def delete_subscription(id)
    request Subscription, :delete, "/subscriptions/#{id}", no_result: true
  end

  def close
    @http&.close
    @http = nil
  end

  private

  def request(klass, method, route, payload = {}, collection: false, no_result: false)
    response = http.send method, route, json: payload

    if response.status.success?
      return [true, nil] if no_result
        
      data = response.parse

      if collection
        [true, data.map { |h| klass.new(h) }]
      else
        [true, klass.new(data)]
      end
    else
      [false, SubSub::Error.new(response.parse)]
    end
  end

  class << self
    def build
      new(Rails.configuration.x.sub_sub.endpoint)
    end

    def use
      instance = build
      yield instance
    ensure
      instance.close
    end
  end
end
