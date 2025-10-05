import SwiftUI

struct ProductListView: View {
    @StateObject private var viewModel = ProductListViewModel()

    var body: some View {
        NavigationView {
            List(viewModel.products) { product in
                ProductCell(product: product) {
                    viewModel.addToCart(product: product)
                }
                // ✅ **关键修复**: 标识符已经被移至 ProductCell 内部。
                // 必须从这里移除，以防止标识符重复。
            }
            .navigationTitle("商品列表")
        }
    }
}

struct ProductListView_Previews: PreviewProvider {
    static var previews: some View {
        ProductListView()
    }
}
