class TransactionsController < ApplicationController
  before_action :authenticate_user

  def create
    item = Item.find_by(id: params[:item_id])
    return head :bad_request if item.blank?
    begin
      Transaction.buy!(current_user.id, item.id)
      return head :created
    rescue => e
      return render json: { messages: [e.message] }, status: :unprocessable_entity
    end
  end
end
