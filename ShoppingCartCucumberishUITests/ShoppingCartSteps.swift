import Foundation
import XCTest
import Cucumberish
// 导入主应用模块，以便访问 UI 元素
// 确保 'ShoppingCartCucumberish' 是您主应用 Target 的正确名称
@testable import ShoppingCartCucumberish
// 这是一个模拟的购物车类，用于演示。
// 在您的真实项目中，您应该与您应用的实际UI和数据模型进行交互。
class MockShoppingCart {
    static let shared = MockShoppingCart()
    private var items: [String: Int] = [:] // [商品名: 数量]

    func clear() {
        items = [:]
        print("Shopping cart cleared.")
    }

    func addItem(named name: String) {
        items[name, default: 0] += 1
        print("Added '\(name)'. New quantity: \(items[name]!).")
    }

    var totalItemCount: Int {
        // 计算所有商品的总件数
        return items.values.reduce(0, +)
    }
    
    var uniqueItemCount: Int {
        // 计算独立商品的种类数
        return items.keys.count
    }

    func quantity(forItemNamed name: String) -> Int {
        return items[name] ?? 0
    }
}
class ShoppingCartSteps {
    
    // 定义所有与购物车相关的步骤
    func setup() {
        
        // 假如 (Given)

        // 场景一：将商品添加到空的购物车
                Given("the application is launched and the shopping cart is empty") { _, _ in
                    // 在这里实现清空购物车的逻辑
                    print("场景一：将商品添加到空的购物车...")
                    MockShoppingCart.shared.clear()
                }
        
        // 当 (When)
        When("我将名为\"(.*?)\"的商品添加到购物车") { (args, userInfo) in
            guard let productName = args?.first else {
                XCTFail("未指定商品名称")
                return
            }
            
            let app = XCUIApplication()
            
            // 假设你的商品列表是一个 CollectionView 或 TableView
            // 并且每个商品Cell的 accessibility identifier 是 "product_cell_\(productName)"
            let productCell = app.cells["product_cell_\(productName)"]
            XCTAssertTrue(productCell.waitForExistence(timeout: 5), "商品'\(productName)'不存在")
            
            // 假设每个Cell里有一个 "add_to_cart_button"
            let addButton = productCell.buttons["add_to_cart_button"]
            XCTAssertTrue(addButton.exists, "添加按钮不存在")
            
            addButton.tap()
        }
        
        // 那么 (Then)
        Then("购物车中的商品数量应为 (\\d+)") { (args, userInfo) in
            guard let expectedCountString = args?.first,
                  let expectedCount = Int(expectedCountString) else {
                XCTFail("未指定期望的商品数量")
                return
            }
            
            let app = XCUIApplication()
            let cartBadge = app.staticTexts["cart_badge_count"]
            
            // 使用断言验证结果
            XCTAssertEqual(cartBadge.label, "\(expectedCount)", "购物车数量不符合预期")
        }
    }
}
