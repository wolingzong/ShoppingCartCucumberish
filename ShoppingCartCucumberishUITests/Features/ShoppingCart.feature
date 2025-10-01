# language: en
Feature: Shopping Cart Management
  In order to allow users to purchase products, they need to be able to add items to the shopping cart.

  Background:
    Given the application is launched and the shopping cart is empty

  Scenario: Add an item to an empty shopping cart
    When I add an item named "MacBook Pro" to the shopping cart
    Then the number of items in the shopping cart should be 1

  Scenario: Add multiple different items to the shopping cart
    When I add an item named "MacBook Pro" to the shopping cart
    And I add an item named "Magic Mouse" to the shopping cart
    Then the number of items in the shopping cart should be 2

  Scenario: Adding the same item multiple times increases its quantity
    When I add an item named "USB-C Cable" to the shopping cart
    And I add an item named "USB-C Cable" to the shopping cart again
    Then the shopping cart should contain 1 unique item
    And the quantity of the item named "USB-C Cable" should be 2
