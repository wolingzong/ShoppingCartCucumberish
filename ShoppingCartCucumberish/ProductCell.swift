import SwiftUI

struct ProductCell: View {
    let product: Product
    let onAddToCart: () -> Void

    var body: some View {
        // 标识符应用在 NavigationLink 上，使其成为一个可测试的整体
        NavigationLink(destination: Text("商品详情: \(product.name)")) {
            HStack(spacing: 16) {
                Image(systemName: product.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.secondary)
                    .padding(8)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 10))

                VStack(alignment: .leading, spacing: 4) {
                    // ✅ **最终清理**: 请确保这一行没有任何 .accessibilityIdentifier！
                    Text(product.name)
                        .font(.headline)
                    
                    Text(String(format: "$%.2f", product.price))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button(action: onAddToCart) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.accentColor)
                        .imageScale(.large)
                        .padding(.leading, 10)
                }
                .accessibilityIdentifier("add_button_\(product.name)")
            }
            .buttonStyle(PlainButtonStyle())
        }
        // ✅ 标识符只应该在这里，这是正确的。
        .accessibilityIdentifier("product_cell_\(product.name)")
    }
}

struct ProductCell_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                ProductCell(
                    product: Product(id: 1, name: "MacBook Pro", price: 1299.99, imageName: "laptopcomputer"),
                    onAddToCart: { }
                )
            }
            .listStyle(InsetGroupedListStyle())
        }
    }
}
