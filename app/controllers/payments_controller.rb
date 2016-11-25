class PaymentsController < ApplicationController
  def create
    if params[:card_token].present?
      render json: { paid: true }
    else
      render json: { paid: false }
    end
  end
end
