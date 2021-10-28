import AsyncDisplayKit
import UIKit

class NoDataNode: ASCellNode {
    
    //MARK: - UI Elements
    private let imageNode = ASImageNode()
    private let textNode = ASTextNode()
    
    //MARK: - Properties
    private var text: String
    private let spacing: CGFloat = 20
    private let insets: UIEdgeInsets
    
    //MARK: - Life Cycle
    init(text: String, insets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)) {
        self.text = text
        self.insets = insets
        super.init()
        self.automaticallyManagesSubnodes = true
    }
    
    override func didLoad() {
        super.didLoad()
        setupUI()
    }
    
    //MARK: - Setup
    private func setupUI() {
        self.backgroundColor = .background
        self.imageNode.image = .logo
        self.imageNode.contentMode = .scaleAspectFit
        self.textNode.attributedText = NSAttributedString(self.text, color: .secondaryText, font: .muliRegular17)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        self.setupSizes(constrainedSize: constrainedSize)
        
        let stack = ASStackLayoutSpec.vertical()
        stack.children = [self.imageNode, self.textNode]
        stack.spacing = self.spacing
        stack.horizontalAlignment = .middle
        
        let center = ASCenterLayoutSpec(centeringOptions: .XY, sizingOptions: .minimumXY, child: stack)
        let inset = ASInsetLayoutSpec(insets: self.insets, child: center)
        
        return inset
    }
    
    private func setupSizes(constrainedSize: ASSizeRange) {
        let imageSize = constrainedSize.max.width * 0.3
        self.imageNode.style.preferredLayoutSize = ASLayoutSize(width: ASDimensionMake(imageSize), height: ASDimensionMake(imageSize))
    }
}
