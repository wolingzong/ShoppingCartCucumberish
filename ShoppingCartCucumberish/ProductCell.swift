import SwiftUI

// 这是商品列表中的单元格（Cell）视图
struct ProductCell: View {
    let product: Product
    let onAddToCart: () -> Void // 一个闭包，用于处理“添加到购物车”的动作

    var body: some View {
        HStack {
            // 商品名称和价格
            VStack(alignment: .leading) {
                Text(product.name)
                    .font(.headline)
                Text(product.price, format: .currency(code: "USD"))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .accessibilityIdentifier("product_info_\(product.name)")

            Spacer()

            // “添加”按钮
            Button(action: onAddToCart) {
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
                    .foregroundColor(.green)
            }
            .accessibilityIdentifier("add_button_\(product.name)")
        }
        .padding(.vertical, 4)
        // 整个 HStack 是一个可访问性元素，标识符为 product_cell_...
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("product_cell_\(product.name)")
    }
}
