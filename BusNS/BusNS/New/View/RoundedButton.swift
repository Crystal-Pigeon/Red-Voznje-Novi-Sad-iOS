import AsyncDisplayKit
import QuartzCore

class RoundedButton: ASButtonNode {
    
    let size: CGFloat = 50
    
    override func didLoad() {
        super.didLoad()
        self.setImage(.plus, for: .normal)
        self.cornerRadius = size / 2
        
        self.shadowOffset = CGSize(width: 4, height: 4)
        self.shadowRadius = size / 2
        self.shadowOpacity = 0.25
        self.shadowColor = UIColor.black.cgColor
        
        self.backgroundColor = .primary
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        self.style.height = ASDimensionMake(size)
        self.style.width = ASDimensionMake(size)
        self.imageNode.style.height = ASDimensionMake(size * 0.5)
        self.imageNode.style.width = ASDimensionMake(size * 0.5)
        return ASCenterLayoutSpec(centeringOptions: .XY, sizingOptions: .minimumXY, child: self.imageNode)
    }
}

