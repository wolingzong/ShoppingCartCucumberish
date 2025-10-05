import SwiftUI

// ===================================================================
// 1. 主视图 (ContentView)
//    它从环境中获取商品列表，并使用 List 来展示它们。
// ===================================================================
struct ContentView: View {
    
    // 从环境中获取 ProductStore 实例
    @EnvironmentObject var productStore: ProductStore
    
    var body: some View {
        NavigationView {
            // 遍历 productStore 中的所有 products
            List(productStore.products) { product in
                // 为每个 product 创建一个 ProductRow，并将 product 数据传递给它
                // 这里就是之前报错的地方，现在 ProductRow 已经准备好接收数据了
                ProductRow(product: product)
            }
            .navigationTitle("商品列表")
        }
    }
}


// ===================================================================
// 2. 单行商品视图 (ProductRow)
//    这个视图负责展示单个商品的详细信息和“添加”按钮。
// ===================================================================
struct ProductRow: View {
    
    // 这个属性让 ProductRow 能够接收一个 Product 对象
    let product: Product
    
    var body: some View {
        HStack {
            // 商品信息
            VStack(alignment: .leading) {
                Text(product.name)
                    .font(.headline)
                Text(String(format: "$%.2f", product.price))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // 添加按钮
            Button(action: {
                // 这里的动作可以将来用于更新购物车状态
                print("点击了添加按钮： \(product.name)")
            }) {
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
            }
            // 【测试关键点】为按钮设置 accessibilityIdentifier
            .accessibilityIdentifier("add_to_cart_button")
        }
        .padding(.vertical, 8)
        // 【测试关键点】为整个商品行（Cell）设置 accessibilityIdentifier
        .accessibilityElement(children: .combine)
        .accessibilityIdentifier("product_cell_\(product.name)")
    }
}


// ===================================================================
// 3. SwiftUI 预览 (ContentView_Previews)
//    这部分用于在 Xcode 的预览画布中显示视图，它也需要被修复。
// ===================================================================
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        // 创建一个临时的 ProductStore 实例用于预览
        let previewStore = ProductStore()
        
        // 将实例注入到环境中，这样预览才能正常工作
        ContentView()
            .environmentObject(previewStore)
    }
}


