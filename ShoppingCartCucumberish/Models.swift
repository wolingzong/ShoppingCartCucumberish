import Foundation

// 商品结构体
struct Product: Equatable, Hashable {
    let name: String
    let price: Double
}

// 购物车结构体
struct ShoppingCart {
    private(set) var items: [Product: Int] = [:] // 使用字典存储商品和数量

    // 计算商品总件数
    var totalItemQuantity: Int {
        return items.values.reduce(0, +)
    }

    // 计算购物车总价
    var totalPrice: Double {
        return items.reduce(0) { (result, item) -> Double in
            let (product, quantity) = item
            return result + product.price * Double(quantity)
        }
    }

    // 添加商品
    mutating func addProduct(_ product: Product) {
        items[product, default: 0] += 1
    }
}
