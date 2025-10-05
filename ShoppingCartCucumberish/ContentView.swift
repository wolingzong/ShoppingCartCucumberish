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


struct ProductRow: View {
    let product: Product

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(product.name)
                    .font(.headline)
                    .accessibilityIdentifier("product_cell_\(product.name)") // ✅ 绑定在 Cell 容器上
                Text(String(format: "$%.2f", product.price))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Button(action: {
                print("点击了添加按钮： \(product.name)")
            }) {
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
            }
         
            .accessibilityIdentifier("add_button_\(product.name)") // ✅ 唯一标识
        }
        .padding(.vertical, 8)
        .background(Color.clear) // ✅ 强制 Cell 成为可识别容器
        
        
        // 1. 移除 .contentShape(Rectangle())
                       // 2. 添加 .accessibilityElement(children: .contain)
                       .accessibilityElement(children: .contain)
                       // 3. 保留 .accessibilityIdentifier(...)
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


