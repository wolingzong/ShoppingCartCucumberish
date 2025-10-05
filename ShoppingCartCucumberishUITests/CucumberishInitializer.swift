// 文件: /Users/watson/Desktop/ShoppingCartCucumberish/ShoppingCartCucumberishUITests/CucumberishInitializer.swift

import Foundation
import XCTest // 确保导入 XCTest
import Cucumberish
import SwiftUI

@objc public class CucumberishInitializer: NSObject {

    @objc public class func CucumberishSwiftInit() {
        // 在所有测试开始前执行的全局设置
        let shoppingSteps = ShoppingCartSteps()
                shoppingSteps.setup()

               
       
        
        let bundle = Bundle(for: CucumberishInitializer.self)
        

        
        
        
        
        // ==================== 调试代码开始 ====================
               print("🔍 开始检查 .feature 文件是否存在...")
               let featureFileName = "ShoppingCart" // 文件名 (不含扩展名)
               let featureFileExtension = "feature" // 扩展名
               let directoryName = "Features"       // 所在的目录名

       
      
        if let bundlePath = bundle.resourcePath {
            let featuresPath = "\(bundlePath)/Features"
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: featuresPath) {
                print("✅ Features 文件夹存在于 bundle 中：\(featuresPath)")
                if let files = try? fileManager.contentsOfDirectory(atPath: featuresPath) {
                    print("📦 文件夹内容：")
                    files.forEach { print(" - \($0)") }
                }
            } else {
                print("❌ Features 文件夹未找到，请确认是否为 folder reference")
            }
        }



        
               // 尝试获取文件的完整路径
               let featurePath = bundle.path(forResource: featureFileName,
                                            ofType: featureFileExtension,
                                            inDirectory: directoryName)

               if let path = featurePath {
                   print("✅ 成功! 文件已找到，路径是: \(path)")
                   
                   // 尝试读取文件内容，以100%确认
                   do {
                       let content = try String(contentsOfFile: path, encoding: .utf8)
                       print("📄 文件内容预览 (前100个字符): \(String(content.prefix(100)))...")
                   } catch {
                       print("⚠️ 警告: 文件找到了，但读取内容失败: \(error.localizedDescription)")
                   }
               } else {
                   print("❌ 失败! 在测试包的'\(directoryName)'目录中找不到'\(featureFileName).\(featureFileExtension)'文件。")
                   print("👉 请立即检查该文件的 'Target Membership' 是否已勾选您的 UI Test Target！")
                   
                   // 为了进一步调试，列出 Resources 目录下的所有文件和文件夹
                   if let resourcePath = bundle.resourcePath {
                       do {
                           let contents = try FileManager.default.contentsOfDirectory(atPath: resourcePath)
                           print("\n📦 当前测试包(Resources)中的内容有: \(contents)")
                       } catch {
                           print("无法列出测试包内容。")
                       }
                   }
                   // 强制测试失败，因为没有 feature 文件测试也无法进行
                   XCTFail("Feature file not found. Check console logs for details.")
               }
               // ==================== 调试代码结束 ====================
        

        
        
        Cucumberish.executeFeatures(inDirectory: "Features", from: bundle, includeTags: nil, excludeTags: nil)

    }
}
