import SwiftUI

struct ShoppingCartView: View {
    // 通过 @EnvironmentObject 直接从环境中获取共享的 ViewModel 实例
    @EnvironmentObject var viewModel: ProductListViewModel

    var body: some View {
        // 使用 List 来显示购物车内容
        List {
            // 遍历购物车字典中的每一个键值对（商品和数量）
            // 我们通过商品名称来排序，以确保列表顺序稳定
            ForEach(viewModel.cart.sorted(by: { $0.key.name < $1.key.name }), id: \.key) { product, quantity in
                HStack(spacing: 16) { // 增加了元素间的间距
                    // ▼▼▼▼▼ 新增代码 ▼▼▼▼▼
                    // 根据 imageName 显示商品图片
                    // 假设图片已经添加到了你的 Assets.xcassets 中
                    Image(product.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(8)
                    // ▲▲▲▲▲ 新增代码 ▲▲▲▲▲
                    
                    VStack(alignment: .leading) {
                        Text(product.name)
                            .font(.headline)
                        Text(product.price, format: .currency(code: "USD"))
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    // 显示数量
                    Text("x \(quantity)") // 格式调整为 "x 2"
                        .font(.title3)
                        .fontWeight(.medium) // 字体加粗
                        .accessibilityIdentifier("quantity_label_\(product.name)")
                }
                .padding(.vertical, 8) // 增加了垂直内边距，让行高更舒适
                // 为每一行添加标识符
                .accessibilityIdentifier("cart_item_\(product.name)")
            }
        }
        // 为整个 List 添加标识符，方便测试时查找
        .accessibilityIdentifier("cart_list_view")
        .navigationTitle("我的购物车")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                // 清空购物车按钮
                Button("Clear Cart") {
                    viewModel.clearCart()
                }
                .accessibilityIdentifier("clear_cart_button")
            }
        }
    }
}

// MARK: - Previews
struct ShoppingCartView_Previews: PreviewProvider {
    static var previews: some View {
        // 在预览中，我们需要创建一个 ViewModel 实例并手动注入
        // 这样预览才能正常工作
        let previewViewModel = ProductListViewModel()
        
        // 使用新的 Product 结构来创建预览数据
        let product1 = Product(id: 1, name: "MacBook Pro", price: 1299.99, imageName: "macbook.pro") // 假设的图片名称
        let product2 = Product(id: 2, name: "Magic Mouse", price: 79.00, imageName: "magic.mouse") // 假设的图片名称
        
        previewViewModel.addToCart(product: product1)
        previewViewModel.addToCart(product: product1)
        previewViewModel.addToCart(product: product2)
        
        return NavigationView {
            ShoppingCartView().environmentObject(previewViewModel)
        }
    }
}
