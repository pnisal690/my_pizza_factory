class OrdersController < ApplicationController
  def create
    order_params = order_params() # Ensure params are permitted

    order = Order.new(customer_name: order_params[:customer_name], status: 'pending', total_amount: 0)

    order_params[:pizzas].each do |pizza_params|
      pizza = Pizza.find_by(id: pizza_params[:pizza_id])
      crust = Crust.find_by(id: pizza_params[:crust_id])

      return render json: { error: 'Invalid pizza or crust ID' }, status: :unprocessable_entity unless pizza && crust

      order_item = order.order_items.build(pizza: pizza, crust: crust, size: pizza_params[:size], quantity: 1)

      if pizza_params[:topping_ids].present?
        toppings = Topping.where(id: pizza_params[:topping_ids])
        order_item.toppings << toppings
      end
    end

    order_params[:sides]&.each do |side_data|
      side = Side.find_by(id: side_data[:side_id])
      order.order_sides.build(side: side, quantity: side_data[:quantity]) if side
    end

    if order.save!
      if order.confirm_order!
        render json: { message: 'Order confirmed successfully!', order: order }, status: :created
      else
        render json: { errors: order.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { errors: order.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def order_params
    params.require(:order).permit(
      :customer_name,
      pizzas: [:pizza_id, :size, :crust_id, :is_vegetarian, { topping_ids: [] }],
      sides: %i[side_id quantity]
    )
  end
end
