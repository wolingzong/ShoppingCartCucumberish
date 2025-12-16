import Foundation
import Combine

// ViewModel 现在是一个 ObservableObject，可以被 SwiftUI 视图观察
class ProductListViewModel: ObservableObject {
    
    // @Published 属性包装器会在属性值改变时，自动通知所有观察它的视图进行刷新
    @Published var products: [Product] = []
    @Published var cart: [Product: Int] = [:]

    // 计算属性：购物车中商品的总数量（例如，2个A，1个B，总数是3）
    var totalItemCount: Int {
        cart.values.reduce(0, +)
    }
    
    // 计算属性：购物车中商品的种类数量（例如，2个A，1个B，种类是2）
    var uniqueItemCount: Int {
        cart.keys.count
    }

    // 用于加载商品数据的方法
    func loadProducts() {
        // 优先从 UI 测试环境中获取 JSON 字符串
        if let jsonString = ProcessInfo.processInfo.environment["UITestProductsJSON"] {
            print("ℹ️ [ViewModel] 正在从 UI 测试环境加载 products.json...")
            if let data = jsonString.data(using: .utf8) {
                let decoder = JSONDecoder()
                if let decodedProducts = try? decoder.decode([Product].self, from: data) {
                    self.products = decodedProducts
                    return
                }
            }
        }
        
        // 如果不处于 UI 测试环境，则从项目的 Bundle 中加载
        print("ℹ️ [ViewModel] 正在从 App Bundle 加载 products.json...")
        if let url = Bundle.main.url(forResource: "products", withExtension: "json") {
            if let data = try? Data(contentsOf: url) {
                let decoder = JSONDecoder()
                if let decodedProducts = try? decoder.decode([Product].self, from: data) {
                    self.products = decodedProducts
                }
            }
        }
    }

    // 添加商品到购物车
    func addToCart(product: Product) {
        cart[product, default: 0] += 1
        print("🛒 [ViewModel] 已添加 '\(product.name)'。当前购物车: \(cart)")
    }

    // 从购物车移除商品
    func removeFromCart(product: Product) {
        if let count = cart[product], count > 1 {
            cart[product] = count - 1
        } else {
            cart.removeValue(forKey: product)
        }
        print("🛒 [ViewModel] 已移除 '\(product.name)'。当前购物车: \(cart)")
    }

    // 清空购物车
    func clearCart() {
        cart.removeAll()
        print("🗑️ [ViewModel] 购物车已清空。")
    }
}
