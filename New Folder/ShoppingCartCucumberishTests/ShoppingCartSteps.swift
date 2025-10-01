import Foundation
import XCTest

@testable import ShoppingCartCucumberish // 导入主应用模块以访问 Models

// 定义一个简单的上下文，用于在不同步骤间共享数据
class TestContext {
    static var cart: ShoppingCart!
    static let iphone18 = Product(name: "iPhone 18", price: 1299.00)
}

// 这个函数包含了所有步骤的定义
func shoppingCartSteps() {

    // MARK: - Given Steps

    Given("my shopping cart is empty") { _, _ in
        TestContext.cart = ShoppingCart()
        XCTAssertTrue(TestContext.cart.items.isEmpty)
    }

    Given("my cart already has \"(\\d+)\" item of \"(.*)\"") { args, _ in
        let quantity = Int(args![0])!
        let productName = args![1]
        
        TestContext.cart = ShoppingCart()
        if productName == TestContext.iphone18.name {
            for _ in 0..<quantity {
                TestContext.cart.addProduct(TestContext.iphone18)
            }
        }
        XCTAssertEqual(TestContext.cart.totalItemQuantity, quantity)
    }

    // MARK: - When Steps

    When("I add the product \"(.*)\" to the cart") { args, _ in
        let productName = args![0]
        if productName == TestContext.iphone18.name {
            TestContext.cart.addProduct(TestContext.iphone18)
        } else {
            XCTFail("未知的商品: \(productName)")
        }
    }

    // MARK: - Then Steps

    Then("I should see \"(\\d+)\" item in the cart") { args, _ in
        let expectedQuantity = Int(args![0])!
        XCTAssertEqual(TestContext.cart.totalItemQuantity, expectedQuantity)
    }

    And("the total price of the cart should be \"([0-9.]+)\"") { args, _ in
        let expectedPrice = Double(args![0])!
        XCTAssertEqual(TestContext.cart.totalPrice, expectedPrice, accuracy: 0.001)
    }
}
