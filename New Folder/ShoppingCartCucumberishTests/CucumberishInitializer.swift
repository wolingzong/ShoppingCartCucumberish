import Foundation
import Cucumberish
// Cucumberish 的入口点，它会在测试开始时被自动调用
@objc public class CucumberishInitializer: NSObject {
    @objc public static func setupCucumberish() {
        // 在这里，我们告诉 Cucumberish 我们的步骤定义在哪里
        // 我们将在下一步创建这个函数
        shoppingCartSteps()

        // 从当前测试 Bundle 中加载并执行所有 .feature 文件
        let bundle = Bundle(for: CucumberishInitializer.self)
        Cucumberish.executeFeatures(inDirectory: "", from: bundle, includeTags: nil, excludeTags: nil)
    }
}
