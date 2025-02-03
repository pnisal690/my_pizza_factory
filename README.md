# MY_Pizza_Factory - Pizza Ordering System

## Overview
MY_Pizza_Factory is an online pizza ordering system built using Ruby on Rails. Customers can place pizza orders with different crusts, toppings, and sides. The system also manages inventory to ensure orders can be fulfilled based on available stock.

## Features
- Customers can order pizzas with different sizes, crusts, and toppings.
- Sides (Cold drink, Mousse cake) can be added to an order.
- Inventory management ensures orders can be processed only when ingredients are available.
- Business rules:
  - Non-vegetarian pizzas cannot have paneer topping.
  - Orders cannot exceed the available inventory.
- Automated RSpec tests and fixture-based test data.

## Installation
### Prerequisites
- Ruby 3.3.3
- Rails 8.0
- MySQL

### Setup
1. Clone the repository:
   ```sh
   git clone https://github.com/pnisal690/my_pizza_factory.git
   cd MY_PIZZA_FACTORY
   ```
2. Install dependencies:
   ```sh
   bundle install
   ```
3. Setup the database:
   ```sh
   rails db:create
   rails db:migrate
   rails db:seed
   ```
4. Start the Rails server:
   ```sh
   rails server
   ```

## API Endpoints
### Create an Order
**POST /orders**
```json
{
  "order": {
    "customer_name": "John Doe",
    "pizzas": [
      {
        "pizza_id": 1,
        "size": "Medium",
        "crust_id": 1,
        "topping_ids": [3, 2]
      }
    ],
    "sides": [
      {
        "side_id": 1,
        "quantity": 2
      }
    ]
  }
}
```

### Response
- **Success (201 Created):**
  ```json
  {
    "message": "Order confirmed successfully!",
    "order_id": 123
  }
  ```
- **Failure (422 Unprocessable Entity):**
  ```json
  {
    "errors": ["Non-vegetarian pizza cannot have paneer topping"]
  }
  ```

## Running Tests
### Using RSpec
Run all test cases:
```sh
rspec
```
Run specific tests:
```sh
rspec spec/requests/orders_spec.rb
```

## Database Schema
### Tables
- **pizzas** (id, name, category, price_regular, price_medium, price_large, created_at, updated_at)
- **crusts** (id, name, price, created_at, updated_at)
- **toppings** (id, name, price, is_vegetarian, created_at, updated_at)
- **sides** (id, name, price, created_at, updated_at)
- **orders** (id, customer_name, total_price, created_at, updated_at)
- **order_items** (id, order_id, pizza_id, crust_id, size, quantity, total_amount, created_at, updated_at)
- **order_sides** (id, order_id, side_id, quantity, created_at, updated_at)
- **inventories** (id, item_type, item_id, quantity, created_at, updated_at)

## Contributors
- prashant Nisal (pnisal690@gmail.com)

Thank You
