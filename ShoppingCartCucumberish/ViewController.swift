import UIKit

// 我们需要一个自定义的 TableViewCell 来放置 "添加" 按钮
class ProductTableViewCell: UITableViewCell {
    // 当按钮被点击时，这个闭包将被调用
    var onAddButtonTapped: (() -> Void)?

    // 使用代码添加一个按钮，这样更简单
    private lazy var addButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "cart.badge.plus")
        let button = UIButton(configuration: config, primaryAction: UIAction { [weak self] _ in
            // 调用闭包
            self?.onAddButtonTapped?()
        })
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier) // 使用 subtitle 样式显示价格
        
        // 将按钮添加到 cell 的视图中
        contentView.addSubview(addButton)
        
        // 设置按钮的约束
        NSLayoutConstraint.activate([
            addButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            addButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// 这是您的主视图控制器
class ViewController: UITableViewController {

    // 这一行已被移除 -> private let products = mockProducts
    // 视图控制器现在会直接使用在 Model.swift 中定义的全局 'products' 常量
    
    // 共享的购物车实例
    private let shoppingCart = ShoppingCart()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "商品"
        
        // 注册我们自定义的 Cell
        tableView.register(ProductTableViewCell.self, forCellReuseIdentifier: "ProductCell")
    }

    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 这里会自动使用全局的 'products' 常量
        return products.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 复用 Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductTableViewCell
        
        // 这里会自动使用全局的 'products' 常量
        let product = products[indexPath.row]
        
        // 配置 Cell 内容
        cell.textLabel?.text = product.name
        cell.detailTextLabel?.text = String(format: "$%.2f", product.price)
        cell.imageView?.image = UIImage(systemName: product.imageName)
        
        // 关键步骤：为 UI 测试设置 Accessibility Identifier
        cell.accessibilityIdentifier = "product_cell_\(product.name)"
        
        // 配置按钮的点击事件
        cell.onAddButtonTapped = { [weak self] in
            guard let self = self else { return }
          self.shoppingCart.addProduct(product: product)
            print("已添加 \(product.name)")
            // 你可以在这里添加一个动画或提示
        }
        
        return cell
    }
}
