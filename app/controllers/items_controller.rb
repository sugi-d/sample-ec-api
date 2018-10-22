class ItemsController < ApplicationController
  before_action :authenticate_user, except: [:index, :show]
  before_action :set_item, only: [:update, :destroy]

  def index
    offset = params[:offset] || 0
    limit = params[:limit] || 30
    items = Item.list(items_url, offset.to_i, limit.to_i)
    return render json: items
  end

  def show
    item = Item.find_by(id: params[:id])
    return head :bad_request if item.blank?
    return render json: { messages: [I18n.t('api_errors.unviewable_item')] }, status: :unprocessable_entity unless item.viewable?
    return render json: { name: item.name, price: item.price }
  end

  def create
    item = current_user.items.new(item_params)

    if item.save
      return head :created
    else
      return render json: { messages: item.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    return head :bad_request if @item.blank?
    @item.attributes = item_params

    if @item.save
      return head :no_content
    else
      return render json: { messages: @item.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    return head :bad_request if @item.blank?
    @item.logical_delete
    if @item.errors.any?
      return render json: { messages: @item.errors.full_messages }, status: :unprocessable_entity
    else
      return head :no_content
    end
  end

  private
    def set_item
      @item = current_user.items.find_by(id: params[:id])
    end

    def item_params
      params.permit(:name, :price, :publish_status)
    end
end
