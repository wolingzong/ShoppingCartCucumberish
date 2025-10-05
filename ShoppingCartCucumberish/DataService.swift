import Foundation

// 一个通用的数据加载函数
// T 可以是任何遵循 Decodable 协议的类型 (例如 [Product])
func load<T: Decodable>(_ filename: String) -> T {
    let data: Data

    let directoryName = "Features"       // 所在的目录名
   

    
    // 1. 从 App Bundle 中查找文件 URL
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil,subdirectory: directoryName)
    else {
        fatalError("无法在 App Bundle 中找到文件: \(filename)")
    }

    // 2. 从文件 URL 加载数据
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("无法从文件加载数据: \(filename)\n错误: \(error)")
    }

    // 3. 解码 JSON 数据
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("无法解析文件: \(filename)\n错误: \(error)")
    }
}
