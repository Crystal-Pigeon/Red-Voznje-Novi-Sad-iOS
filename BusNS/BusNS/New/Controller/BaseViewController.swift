import AsyncDisplayKit

class BaseViewController: ASDKViewController<ASDisplayNode> {
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override init() {
        super.init(node: ASDisplayNode())
        self.node.automaticallyManagesSubnodes = true
        self.setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.node.backgroundColor = .background
        self.setupData()
        self.setupUI()
        self.navigationController?.view.backgroundColor = .primary
        self.navigationItem.backButtonTitle = ""
        self.setupNavigationBarAppearance()
    }
    
    //MARK: - Setup methods
    @objc dynamic func setupData() {}
    
    @objc dynamic func setupUI() { }
    
    @objc dynamic func setupLayout() {}
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13, *), traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            self.node.backgroundColor = .background
            self.setupUI()
        }
    }
}

/// Base view controller with node of type ASScrollNode
class ScrollViewController: ASDKViewController<ASDisplayNode> {
    let scrollNode = ASScrollNode()
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override init() {
        super.init(node: ASDisplayNode())
        self.node.automaticallyManagesSubnodes = true
        self.scrollNode.automaticallyManagesSubnodes = true
        self.scrollNode.automaticallyManagesContentSize = true
        self.setupScrollLayout()
        self.layout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupData()
        self.setupUI()
        self.scrollNode.view.showsVerticalScrollIndicator = false
        self.navigationController?.view.backgroundColor = .background
        self.navigationItem.backButtonTitle = ""
        self.setupNavigationBarAppearance()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let contentRect: CGRect = self.scrollNode.view.subviews.reduce(into: .zero) { rect, view in
            rect = rect.union(view.frame)
        }
        self.scrollNode.view.contentSize = contentRect.size
    }
    
    //MARK: - Setup methods
    @objc dynamic func setupData() {}
    
    @objc dynamic func setupUI() {}
    
    @objc dynamic func setupScrollLayout() {}
    
    @objc dynamic func layout() {
        self.node.layoutSpecBlock = { node, constrinedSize in
            self.node.backgroundColor = .background
            return ASWrapperLayoutSpec(layoutElement: self.scrollNode)
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13, *), traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            self.node.backgroundColor = .background
            self.setupUI()
//            let nav = self.navigationController?.navigationBar.frame.height ?? 0
//            let status: CGFloat = self.statusBarHeight
//            scrollNode.view.contentInset.bottom = -nav - status
        }
    }
}
