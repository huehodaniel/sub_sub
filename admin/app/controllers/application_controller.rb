# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :create_service
  after_action :close_service

  protected

  def create_service
    @service = SubSub.build
  end

  def close_service
    @service&.close
  end
end
