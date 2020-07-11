class Api::V1::Merchants::FindController < ApplicationController

  def index 
    render json: MerchantSerializer.new(Merchant.find_all(params))
  end

  def show 
    render json: MerchantSerializer.new(Merchant.find_one(params))
  end

  
end