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
                    // 点击购物车图标，导航到购物车视图
                    // 注意：确保这里的 ShoppingCartView 是您购物车视图的正确名称
                    NavigationLink(destination: ShoppingCartView().environmentObject(viewModel)) {
                        ZStack(alignment: .topTrailing) {
                            // 购物车图标
                            Image(systemName: "cart")
                                .font(.title2)

                            // 仅当购物车数量大于0时，显示红色角标
                            if viewModel.totalItemCount > 0 {
                                Text("\(viewModel.totalItemCount)")
                                    .font(.caption2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding(5)
                                    .background(Color.red)
                                    .clipShape(Circle())
                                    .offset(x: 12, y: -12)
                                    .accessibilityIdentifier("cart_item_count_text")
                            }
                        }
                        // ▼▼▼▼▼ 关键修正 ▼▼▼▼▼
                        // 将标识符放在 ZStack 上，确保整个可点击区域都能被测试框架识别
                        .accessibilityIdentifier("cart_icon_button")
                        // ▲▲▲▲▲ 修正结束 ▲▲▲▲▲
                    }
                }
            }
        }
        // 视图出现时，让 viewModel 加载商品，这是一个很好的实践！
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
