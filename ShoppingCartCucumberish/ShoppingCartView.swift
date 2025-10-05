import SwiftUI

struct ShoppingCartView: View {
    @EnvironmentObject var shoppingCart: ShoppingCart
    @State private var isShowingClearAlert = false

    var body: some View {
        let cart = shoppingCart

        NavigationView {
            VStack {
                if cart.items.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "cart.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.gray.opacity(0.5))
                        Text("您的购物车是空的")
                            .font(.title)
                            .foregroundColor(.gray)
                    }
                } else {
                    List {
                        ForEach(cart.items) { item in
                            HStack(spacing: 15) {
                                Image(item.product.imageName)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 60, height: 60)
                                    .cornerRadius(8)
                                    .clipped()

                                VStack(alignment: .leading, spacing: 5) {
                                    Text(item.product.name)
                                        .font(.headline)
                                    Text(String(format: "单价: $%.2f", item.product.price))
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }

                                Spacer()

                                Text("x\(item.quantity)")
                                    .font(.title3)
                                    .fontWeight(.medium)
                                    .accessibilityIdentifier("quantity_\(item.product.name)")
                            }
                            .padding(.vertical, 5)
                        }
                        .onDelete { indexSet in
                            cart.removeItems(at: indexSet)
                        }
                    }

                    HStack {
                        Text("总计:")
                            .font(.headline)
                        Spacer()
                        Text(String(format: "$%.2f", cart.totalPrice))
                            .font(.headline)
                            .accessibilityIdentifier("totalPrice")
                    }
                    .padding()
                }
            }
            .navigationTitle("购物车")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    if !cart.items.isEmpty {
                        Button {
                            isShowingClearAlert = true
                        } label: {
                            Image(systemName: "trash")
                        }

                        EditButton()
                    }
                }
            }
            .alert(isPresented: $isShowingClearAlert) {
                Alert(
                    title: Text("确认清空吗？"),
                    message: Text("此操作将移除购物车中的所有商品。"),
                    primaryButton: .destructive(Text("清空")) {
                        cart.clearCart()
                    },
                    secondaryButton: .cancel(Text("取消"))
                )
            }
        }
    }
}
struct ShoppingCartView_Previews: PreviewProvider {
    static var previews: some View {
        ShoppingCartView()
            .environmentObject(previewCartWithApple)
    }

    static var previewCartWithApple: ShoppingCart {
        let cart = ShoppingCart()
        let apple = Product(id: 2, name: "苹果", price: 1.99, imageName: "apple")
        cart.addProduct(product: apple)
        return cart
    }
}
