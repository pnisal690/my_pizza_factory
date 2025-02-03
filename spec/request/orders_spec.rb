require 'rails_helper'

RSpec.describe 'Orders API', type: :request do
  fixtures :inventories, :pizzas, :crusts, :toppings, :sides, :orders, :order_items, :order_sides

  let!(:pizza_inventory) { inventories(:pizza_inventory) }
  let!(:crust_inventory) { inventories(:crust_inventory) }
  let!(:paneer_topping_inventory) { inventories(:topping_paneer_inventory) }
  let!(:capsicum_topping_inventory) { inventories(:topping_capsicum_inventory) }
  let!(:cold_drink_inventory) { inventories(:side_cold_drink_inventory) }
  let!(:mousse_cake_inventory) { inventories(:side_mousse_cake_inventory) }

  describe 'POST /orders' do
    context 'when order is valid' do
      it 'creates an order and returns success response' do
        post '/orders', params: {
          order: {
            customer_name: 'prashant nisal',
            pizzas: [
              {
                pizza_id: pizzas(:deluxe_veggie).id,
                size: 'Medium',
                crust_id: crusts(:new_hand_tossed).id,
                topping_ids: [toppings(:paneer).id, toppings(:capsicum).id]
              }
            ],
            sides: [
              {
                side_id: sides(:cold_drink).id,
                quantity: 2
              }
            ]
          }
        }, as: :json
        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)

        # Check the JSON response as expected
        expect(json_response['message']).to eq('Order confirmed successfully!')
        expect(json_response['order']['status']).to eq('confirmed')
        # prices : deluxe_veggie: 200, capsicum_topping:25, paneer_topping:35,side: 55*2 => total 370
        expect(json_response['order']['total_amount']).to eq(370)
      end

      it "validates Business rule: Non-vegetarian pizzas can't have paneer topping" do
        post '/orders', params: {
          order: {
            customer_name: 'prashant nisal',
            pizzas: [
              {
                pizza_id: pizzas(:non_veg_supreme).id,
                size: 'Medium',
                crust_id: crusts(:new_hand_tossed).id,
                topping_ids: [toppings(:paneer).id]
              }
            ]
          }
        }, as: :json
        expect(response).to have_http_status(422)
        json_response = JSON.parse(response.body)

        expect(json_response['error']).to include('Unprocessable Content')
      end
    end
  end
end
