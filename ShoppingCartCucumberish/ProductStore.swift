import Foundation
import SwiftUI

// --- 修改开始 ---
// 我们使用产品名称作为唯一的、稳定的ID
// --- 修改结束 ---

class ProductStore: ObservableObject {
    
    @Published var products: [Product] = []

    init() {
        // 这部分代码保持不变，它在运行时加载数据
        if let jsonString = ProcessInfo.processInfo.environment["UITestProductsJSON"] {
            guard let data = jsonString.data(using: .utf8) else { return }
            do {
                self.products = try JSONDecoder().decode([Product].self, from: data)
            } catch {
                print("❌ FATAL: Failed to decode JSON string. Error: \(error)")
            }
        } else {
            self.products = loadProductsFromMainBundle()
        }
    }
    
    private func loadProductsFromMainBundle() -> [Product] {
        guard let url = Bundle.main.url(forResource: "products", withExtension: "json") else {
            return []
        }
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode([Product].self, from: data)
        } catch {
            return []
        }
    }
}
