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
    func dumpAllUIElements(app: XCUIApplication) {
        print("🧩 [DEBUG] 开始遍历所有 UI 元素")

        let allElements = app.descendants(matching: .any).allElementsBoundByIndex
        print("📊 [DEBUG] 元素总数: \(allElements.count)")

        for (index, element) in allElements.enumerated() {
            print("""
            🔹 [Element \(index)]
            - Type: \(element.elementType)
            - Identifier: "\(element.identifier)"
            - Label: "\(element.label)"
            - Frame: \(element.frame)
            - Exists: \(element.exists)
            """)
        }

        print("✅ [DEBUG] 元素遍历完成")
    }
    // 定义所有与购物车相关的步骤
    func setup() {
        
       
        Given("the app is launched") { _, _ in
            let app = XCUIApplication()
            app.launch()
        }

                Given("the application is launched and the shopping cart is empty") { _, _ in
                    let app = XCUIApplication()
                            
                    // 2. 在测试包中找到 products.json 的 URL
                    let testBundle = Bundle(for: CucumberishInitializer.self)

                    print("📦 [DEBUG] 测试 Bundle 路径: \(testBundle.bundlePath)")
                    print("📦 [DEBUG] 尝试在 Features 子目录中查找 products.json")

                    guard let url = testBundle.url(forResource: "products", withExtension: "json", subdirectory: "Features") else {
                        print("❌ [DEBUG] 未找到 products.json 文件")
                        print("📂 [DEBUG] Features 文件夹内容如下（如果存在）：")

                        if let featuresFolderURL = testBundle.url(forResource: "Features", withExtension: nil) {
                            do {
                                let contents = try FileManager.default.contentsOfDirectory(atPath: featuresFolderURL.path)
                                for file in contents {
                                    print(" - \(file)")
                                }
                            } catch {
                                print("❌ [DEBUG] 无法读取 Features 文件夹内容: \(error)")
                            }
                        } else {
                            print("❌ [DEBUG] Features 文件夹不存在或未打包进测试 Bundle")
                        }

                        XCTFail("❌ 无法在测试包中找到 products.json 文件！请检查 Target Membership 设置。")
                        return
                    }

                    print("✅ [DEBUG] 成功找到 products.json 文件，路径为: \(url.path)")

                    
                    
                            // 2. 在测试包中找到 products.json 的 URL
                            guard let url = testBundle.url(forResource: "products", withExtension: "json",subdirectory: "Features") else {
                                XCTFail("❌ 无法在测试包中找到 products.json 文件！请检查 Target Membership 设置。")
                                return
                            }
                            
                            // 3. 将文件内容读取为字符串
                            guard let jsonString = try? String(contentsOf: url, encoding: .utf8) else {
                                XCTFail("❌ 无法将 products.json 读取为字符串！")
                                return
                            }
                            
                            // 4. 将整个 JSON 字符串放入环境变量
                            app.launchEnvironment["UITestProductsJSON"] = jsonString
                            // --- 核心修改结束 ---
                            
                            app.launch()
                            
                            // (可选) 确保购物车是空的
                            let clearButton = app.buttons["Clear Cart"]
                            if clearButton.exists {
                                clearButton.tap()
                            }
                }
        // 假如 (Given)

//        // 场景一：将商品添加到空的购物车
//                Given("the application is launched and the shopping cart is empty") { _, _ in
//                    // 在这里实现清空购物车的逻辑
//                    print("场景一：将商品添加到空的购物车...")
//                    MockShoppingCart.shared.clear()
//                }
        
        // 当 (When)
        When("I add an item named \"(.*?)\" to the shopping cart") { (args, userInfo) in
            guard let productName = args?.first else {
                XCTFail("未指定商品名称")
                return
            }
            
            let app = XCUIApplication()
            
            // 假设你的商品列表是一个 CollectionView 或 TableView
            // 并且每个商品Cell的 accessibility identifier 是 "product_cell_\(productName)"
            let productCell = app.cells["product_cell_\(productName)"]
            
            
            print("🔍 [DEBUG] 查找商品 Cell: product_cell_\(productName)")
            print("📱 [DEBUG] 当前界面元素数量: \(app.descendants(matching: .any).count)")
            
            self.dumpAllUIElements(app: app)
            
            
            let productIdentifier = "product_cell_\(productName)"
                       let addButtonIdentifier = "add_button_\(productName)"
                       
                       // ✅ **核心修复** ✅
                       // 不要再使用 app.cells. 我们从日志中得知，标识符在 `otherElements` 上。
                       // 我们直接查找这个带有标识符的元素。
                       let productElement = app.otherElements[productIdentifier]
            
           
            
            XCTAssertTrue(productElement.waitForExistence(timeout: 5), "商品'\(productName)'不存在")
            
            
            // 在父元素内部查找我们正确构建了标识符的按钮
                       let addButton = productElement.buttons[addButtonIdentifier]
                       
                       // ✅ **最终修复** ✅
                       // 这里的断言信息也更正了，确保我们查找的是正确的按钮。
                       XCTAssertTrue(addButton.exists, "断言失败: 在商品 '\(productName)' 中找不到标识符为 '\(addButtonIdentifier)' 的添加按钮。")
                       
            
           
            
            addButton.tap()
        }
        
        // 那么 (Then)
        
        Then(#"the (?:number of items in the )?shopping cart should (?:be|contain) (\d+)(?: unique item(?:s)?)?"#) { (args, _) in
                    guard let expectedCountString = args?.first, let expectedCount = Int(expectedCountString) else {
                        XCTFail("❌ 期望数量丢失或不是一个有效的数字。")
                        return
                    }
                    
                    print("✔️ [VERIFY] 验证购物车中应有 \(expectedCount) 种商品")
            let app = XCUIApplication()
                    // 1. 点击购物车按钮
                    let cartButton = app.buttons["cart_button"]
                    XCTAssertTrue(cartButton.waitForExistence(timeout: 5), "🚨 购物车按钮 'cart_button' 未找到！请再次确认已彻底清理构建缓存并重新编译。")
                    cartButton.tap()
                    
                    // 2. 等待并验证购物车列表视图是否存在
                    let cartList = app.collectionViews["cart_list_view"]
                    XCTAssertTrue(cartList.waitForExistence(timeout: 5), "🚨 购物车列表 'cart_list_view' 未找到！请确保已在 ShoppingCartView 中正确设置。")
                    
                    // 3. 验证购物车中独立商品行（Cell）的数量
                    XCTAssertEqual(cartList.cells.count, expectedCount, "期望购物车中有 \(expectedCount) 种商品, 但实际找到了 \(cartList.cells.count) 种。")
                }
                
                And("the quantity of the item named \"(.*)\" should be (\\d+)") { (args, _) in
                    guard let itemName = args?.first, let expectedQuantityString = args?[1], let expectedQuantity = Int(expectedQuantityString) else {
                        XCTFail("❌ 无效的参数：无法解析商品名称或期望数量。")
                        return
                    }
                    
                    print("✔️ [VERIFY] 验证商品 '\(itemName)' 的数量应为 \(expectedQuantity)")
                    let app = XCUIApplication()
                    // 此时购物车页面应该已经被上一个步骤打开了
                    let quantityLabelIdentifier = "quantity_label_\(itemName)"
                    let quantityLabel = app.staticTexts[quantityLabelIdentifier]
                    
                    XCTAssertTrue(quantityLabel.waitForExistence(timeout: 5), "🚨 未找到商品 '\(itemName)' 的数量标签。标识符: '\(quantityLabelIdentifier)'")
                    
                    // 从 "Quantity: 2" 这样的文本中提取数字
                    let labelText = quantityLabel.label
                    guard let quantity = Int(labelText.components(separatedBy: .decimalDigits.inverted).joined()) else {
                        XCTFail("无法从标签文本 '\(labelText)' 中解析出数量。")
                        return
                    }

                    XCTAssertEqual(quantity, expectedQuantity, "商品 '\(itemName)' 的期望数量是 \(expectedQuantity), 但实际显示为 \(quantity)。")
                }
        
    }
}
