# frozen_string_literal: true

class ClientsController < ApplicationController
  before_action :set_client, only: %i[show edit update destroy]

  # GET /clients
  def index
    *, @clients = @service.all_clients
  end

  # GET /clients/1
  def show; end

  # GET /clients/new
  def new
    @client = Client.new
  end

  # GET /clients/1/edit
  def edit; end

  # POST /clients
  def create
    @client = Client.new(client_params)

    respond_to do |format|
      ok, result = @service.create_client(client_params)

      if ok
        format.html { redirect_to result, notice: 'Client was successfully created.' }
      else
        result.populate_model(@client)
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /clients/1
  def update
    respond_to do |format|
      ok, result = @service.update_client(params[:id], client_params)

      if
        format.html { redirect_to result, notice: 'Client was successfully updated.' }
      else
        @client = Client.new(client_params)
        result.populate_model(@client)

        format.html { render :edit }
      end
    end
  end

  # DELETE /clients/1
  def destroy
    @service.delete_client(params[:id])

    respond_to do |format|
      format.html { redirect_to clients_url, notice: 'Client was successfully destroyed.' }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_client
    *, @client = @service.get_client(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def client_params
    params.require(:client).permit(:name, :cpf, :email)
  end
end
