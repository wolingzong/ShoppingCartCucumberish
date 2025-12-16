import SwiftUI

struct ProductListView: View {
    // ViewModel 负责管理商品数据和购物车逻辑
    @StateObject private var viewModel = ProductListViewModel()

    var body: some View {
        NavigationView {
            List(viewModel.products) { product in
                ProductCell(product: product) {
                    viewModel.addToCart(product: product)
                }
            }
            .navigationTitle("商品列表")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    // 使用 NavigationLink 导航到购物车视图
                    NavigationLink(destination: ShoppingCartView().environmentObject(viewModel)) {
                        // ZStack 用于将角标叠加在购物车图标之上
                        ZStack(alignment: .topTrailing) {
                            Image(systemName: "cart")
                                .font(.title2)

                            // 仅当购物车内商品总数大于0时，才显示红色角标
                            if viewModel.totalItemCount > 0 {
                                Text("\(viewModel.totalItemCount)")
                                    .font(.caption2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding(5)
                                    .background(Color.red)
                                    .clipShape(Circle())
                                    .offset(x: 12, y: -12)
                                    // 为角标文本也添加一个标识符，方便单独验证数量
                                    .accessibilityIdentifier("cart_item_count_text")
                            }
                        }
                    }
                    // ▼▼▼▼▼ 关键修复 ▼▼▼▼▼
                    // 为整个 NavigationLink 添加可访问性标识符。
                    // 这是 UI 测试能够找到并点击此按钮的核心。
                    .accessibilityIdentifier("cart_button")
                    // ▲▲▲▲▲ 关键修复 ▲▲▲▲▲
                }
            }
        }
        // 当视图首次出现时，让 viewModel 加载商品数据
        .onAppear {
            viewModel.loadProducts()
        }
    }
}

struct ProductListView_Previews: PreviewProvider {
    static var previews: some View {
        ProductListView()
    }
}
