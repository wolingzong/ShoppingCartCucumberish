import Foundation

// 商品模型
struct Product: Codable, Identifiable {
    var id: Int
    var name: String
    var price: Double
    var imageName: String
}


// 购物车项目模型
struct CartItem: Identifiable {
    let id = UUID()
    var product: Product
    var quantity: Int
}

// 从 JSON 文件加载的商品数据
// 注意：mockProducts 被移除了，替换为从文件加载
let products: [Product] = load("products.json")

