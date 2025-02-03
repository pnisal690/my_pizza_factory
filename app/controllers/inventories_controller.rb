class InventoriesController < ApplicationController
  def index
    render json: Inventory.all
  end

  def update
    inventory = Inventory.find_by(item_type: params[:item_type], item_id: params[:item_id])
    if inventory.update(quantity: params[:quantity])
      render json: { message: 'Inventory updated successfully' }, status: :ok
    else
      render json: { errors: inventory.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
