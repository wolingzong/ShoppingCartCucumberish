// ProductListView.swift - 正确的修正示例
import SwiftUI

// 假设你的 ProductListView 是这样的
struct ProductListView: View {
    
    // 1. 使用 @EnvironmentObject 来接收从上层注入的 ProductStore 实例。
       @EnvironmentObject var productStore: ProductStore
    var body: some View {
           // 2. 直接使用 productStore.products 来构建列表。
           //    因为 products 是 @Published，当数据加载完成后，列表会自动刷新。
           List(productStore.products) { product in
               // 这是您的商品行视图
               // 确保 accessibility identifier 设置正确，以便测试可以找到它
               ProductRow(product: product)
                   .accessibilityElement(children: .combine)
                   .accessibilityIdentifier("product_cell_\(product.name)")
           }
           .navigationTitle("Products")
       }
    
   
}


//// --- 这是你需要修改的地方 ---
//struct ProductListView_Previews: PreviewProvider {
//    static var previews: some View {
//        // 创建一个符合定义的、用于预览的样本数据
//        let sampleProducts = [
//            Product(id: 1, name: "Sample Cucumber", price: 1.99, imageName: "cucumber-image"),
//            Product(id: 2, name: "Sample Tomato", price: 2.50, imageName: "tomato-image")
//        ]
//        
//        // 将样本数据传递给视图
//        ProductListView(products: sampleProducts)
//    }
//}
