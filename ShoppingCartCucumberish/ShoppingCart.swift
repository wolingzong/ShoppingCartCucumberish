import Foundation
import Combine

class ShoppingCart: ObservableObject {

    @Published var items: [CartItem] = []

    /// 计算总价的计算属性
    var totalPrice: Double {
        items.reduce(0) { total, item in
            total + (item.product.price * Double(item.quantity))
        }
    }

    /// --- 这是修改后的方法 ---
    /// 将函数定义从 'add(_ product: Product)' 修改为 'add(product: Product)'
    /// 这样它就能匹配您视图中 'add(product: ...)' 的调用方式
   func addProduct(product: Product) {
        if let index = items.firstIndex(where: { $0.product.name == product.name }) {
            // 如果商品已存在，则数量加一
            items[index].quantity += 1
        } else {
            // 如果是新商品，则添加到数组
            items.append(CartItem(product: product, quantity: 1))
        }
    }

    /// 移除特定商品的方法 (用于 List 的 onDelete)
    func removeItems(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
    }

    /// 清空购物车中所有商品
    func clearCart() {
        items.removeAll()
    }
}
