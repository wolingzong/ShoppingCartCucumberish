// ShoppingCartCucumberishApp.swift - (修正后的代码)
import SwiftUI

@main
struct ShoppingCartCucumberishApp: App {
    // 1. 把这两行关于 `products` 的代码完全删除
    // let products: [Product] = load("products.json")
    // 1. 使用 @StateObject 创建 ProductStore 的实例。
       //    @StateObject 确保这个实例的生命周期和 App 保持一致。
       //    当 App 启动时，ProductStore 的 init() 方法会自动运行。
       @StateObject private var productStore = ProductStore()
    @StateObject private var cart = ShoppingCart()
    var body: some Scene {
            WindowGroup {
                // 2. 将 productStore 实例注入到 SwiftUI 的环境中。
                //    这样，任何子视图都可以通过 @EnvironmentObject 访问它。
                ContentView() // <-- 这里是您的根视图
                    .environmentObject(productStore)
                                   .environmentObject(cart)
            }
        }
    

   
}
