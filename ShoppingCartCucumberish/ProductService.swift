import Foundation
import Combine
// 正确的、可测试的代码
import Foundation

class ProductService: ObservableObject {
    @Published var products: [Product] = []
    
    // 接受一个 Bundle，并默认为 .main
    init(bundle: Bundle = .main) {
        self.products = loadProducts(from: bundle)
    }

    private func loadProducts(from bundle: Bundle) -> [Product] {
      
        // 从传入的 bundle 中查找文件
       
        // 仅当 Features 是一个蓝色的“文件夹引用”时，才使用此代码
        guard let url = bundle.url(forResource: "products",
                                   withExtension: "json",
                                   subdirectory: "Features") else { // <--  {
            print("❌ 错误: 无法在指定的 bundle 中找到 products.json。666")
            return [] // 返回空数组而不是崩溃
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let products = try decoder.decode([Product].self, from: data)
            print("✅ 成功从 bundle 加载了 \(products.count) 个商品。")
            return products
        } catch {
            print("❌ 错误: 解码 products.json 失败: \(error)")
            return [] // 返回空数组而不是崩溃
        }
    }
}
