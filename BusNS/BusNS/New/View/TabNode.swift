import AsyncDisplayKit

class TabNode: ASCellNode {
    
    var tabButtons = [ASButtonNode]()
    let items: [String]
    var selectedIndex: Int
    var tabPager: TabPager?
    private let lineNode = ASDisplayNode()
    private let lineHeight: CGFloat = 2
    private let height: CGFloat = 44
    
    init(items: [String], selectedIndex: Int) {
        self.items = items
        self.selectedIndex = selectedIndex >= items.count ? items.count - 1 : selectedIndex
        super.init()
        self.createButtons()
        self.automaticallyManagesSubnodes = true
    }
    
    override func didLoad() {
        super.didLoad()
        self.lineNode.backgroundColor = .white
        self.backgroundColor = .primary
        self.selectAtCurrentIndex()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        self.prepareButtons(self.constrainedSizeForCalculatedLayout)
        self.lineNode.style.width = ASDimensionMake(constrainedSize.max.width / CGFloat(self.items.count))
        self.lineNode.style.height = ASDimensionMake(self.lineHeight)
        
        self.style.height = ASDimensionMake(self.height)
        
        let buttonsStack = ASStackLayoutSpec.horizontal()
        buttonsStack.children = self.tabButtons
        
        let mainStack = ASStackLayoutSpec.vertical()
        mainStack.children = [buttonsStack, self.lineNode]
        
        return mainStack
    }
    
    private func createButtons() {
        self.tabButtons = self.items.map({ item in
            let button = ASButtonNode()
            button.setTitle(item, with: .muliRegular15, with: .white, for: .normal)
            button.setTitle(item, with: .muliRegular15, with: .white, for: .selected)
            button.addTarget(self, action: #selector(buttonClicked(_ :)), forControlEvents: .touchUpInside)
            return button
        })
    }
    
    private func prepareButtons(_ constrainedSize: ASSizeRange) {
        for button in self.tabButtons {
            button.style.width = ASDimensionMake(constrainedSize.max.width / CGFloat(self.items.count))
            button.style.height = ASDimensionMake(self.height - self.lineHeight)
        }
    }
}

//MARK: - Select a single button
extension TabNode {
    @objc private func buttonClicked(_ sender: ASButtonNode) {
        self.selectButton(sender)
    }
    
    @objc private func selectButton(_ sender: ASButtonNode) {
        if sender.isSelected { return }
        
        guard let index = self.tabButtons.firstIndex(where: { button in
            return sender.titleNode.attributedText == button.titleNode.attributedText
        }) else { return }
        
        self.tabPager?.scrollToPage(at: Int(index))
    }
    
    private func changeSelectedIndex(index: Int) {
        self.tabButtons[selectedIndex].isSelected = false
        self.tabButtons[index].isSelected = true
        self.selectedIndex = index
    }
}

//MARK: - Public methods
extension TabNode {
    func moveLine(to point: CGPoint) {
        self.lineNode.position.x = (point.x / CGFloat(self.items.count)) + (self.lineNode.style.width.value / 2.0)
        let index = Int(self.lineNode.position.x / self.lineNode.style.width.value)
        self.changeSelectedIndex(index: index)
    }
    
    func selectAtCurrentIndex() {
        self.selectButton(self.tabButtons[selectedIndex])
        self.changeSelectedIndex(index: selectedIndex)
    }
}
