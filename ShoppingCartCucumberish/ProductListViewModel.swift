import Foundation
import Combine

// 1. 遵循 ObservableObject 协议
class ProductListViewModel: ObservableObject {
    
    // 2. 使用 @Published 包装你的数据源
    // 当这个数组改变时，任何观察这个 ViewModel 的 View 都会自动刷新
    @Published var products: [Product] = []

    init() {
        // 在这里加载你的商品数据，例如从网络或本地数据库
        // 为了演示，我们直接加载一些示例数据
        loadSampleProducts()
    }
    
    func loadSampleProducts() {
        self.products = [
            Product(id: 1, name: "MacBook Pro", price: 1299.99, imageName: "laptopcomputer"),
            Product(id: 2, name: "iPhone 15", price: 799.00, imageName: "iphone"),
            Product(id: 3, name: "Apple Watch", price: 399.00, imageName: "applewatch"),
            Product(id: 4, name: "iPad Air", price: 599.00, imageName: "ipad")
        ]
    }
    
    func addToCart(product: Product) {
        // 在这里处理添加到购物车的逻辑
        print("Added \(product.name) to cart!")
    }
}
