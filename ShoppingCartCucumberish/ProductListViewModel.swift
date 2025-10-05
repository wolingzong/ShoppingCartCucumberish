import Foundation
import Combine



class ProductListViewModel: ObservableObject, Observable {
    
    // MARK: - Published Properties for UI
    
    // 商品列表数据源
    @Published var products: [Product] = []
    
    // 购物车内容，使用字典存储商品及其数量 [商品: 数量]
    @Published var cartItems: [Product: Int] = [:]
    
    // 购物车中所有商品的总件数（用于右上角角标）
    @Published var totalItemCount: Int = 0
    
    // 购物车中不同商品种类的数量（用于BDD测试）
    @Published var uniqueItemCount: Int = 0

    
    // MARK: - Public Methods
    
    // 加载商品数据
    func loadProducts() {
        // 为了测试，我们确保这里包含了所有测试用例中需要的商品
        self.products = [
            Product(id: 1, name: "MacBook Pro", price: 1299.99, imageName: "laptopcomputer"),
            Product(id: 2, name: "Magic Mouse", price: 79.00, imageName: "magicmouse"),
            Product(id: 3, name: "USB-C Cable", price: 19.00, imageName: "cable.connector"),
            Product(id: 4, name: "iPhone 15", price: 799.00, imageName: "iphone"),
            Product(id: 5, name: "Apple Watch", price: 399.00, imageName: "applewatch"),
            Product(id: 6, name: "iPad Air", price: 599.00, imageName: "ipad")
        ]
    }
    
    // 添加商品到购物车
    func addToCart(product: Product) {
        cartItems[product, default: 0] += 1
        print("已添加 \(product.name) 到购物车。当前数量: \(cartItems[product]!)")
        updateCartCounts()
    }
    
    // 清空购物车（用于BDD测试的 "Given" 步骤）
    func clearCart() {
        cartItems = [:]
        print("购物车已清空。")
        updateCartCounts()
    }
    
    // 获取指定名称商品的数量（用于BDD测试的 "Then" 步骤）
    func quantity(for productName: String) -> Int {
        // 查找购物车中是否有该商品
        guard let productInCart = cartItems.keys.first(where: { $0.name == productName }) else {
            return 0
        }
        // 返回该商品的数量
        return cartItems[productInCart, default: 0]
    }
    
    // MARK: - Private Helper
    
    // 每次购物车变动时，更新总数量和种类数量
    private func updateCartCounts() {
        // 计算总件数 (e.g., 2个A, 1个B -> 总数是3)
        totalItemCount = cartItems.values.reduce(0, +)
        
        // 计算种类数 (e.g., 2个A, 1个B -> 种类是2)
        uniqueItemCount = cartItems.keys.count
    }
}
