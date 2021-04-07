//
//  EmptyBusCellNode.swift
//  BusNS
//
//  Created by Marko Popić on 12/9/19.
//  Copyright © 2019 Crystal Pigeon. All rights reserved.
//

import AsyncDisplayKit

final class EmptyBusCellNode: ASCellNode {
    
    private let containerNode = ASDisplayNode()
    
    override init() {
        super.init()
    }
    
    override func didLoad() {
        self.layer.shadowColor = Theme.current.color(.shadowColor).cgColor
        self.layer.shadowOffset = CGSize(width: 6, height: 6)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 5
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = false
        self.selectionStyle = .none
        self.backgroundColor = Theme.current.color(.busCell_backgroundColor)
        self.createLoader()
    }
    
    private func createLoader() {
        let containerView = UIView(frame: self.view.bounds)
        
        let imageLayer = CAShapeLayer()
        imageLayer.backgroundColor = UIColor.clear.cgColor
        imageLayer.bounds = CGRect(x: containerView.bounds.midX - 21, y: containerView.bounds.midY - 20, width: 42, height: 40)
        imageLayer.position = CGPoint(x: containerView.bounds.midX ,y: containerView.bounds.midY)
        imageLayer.contents = Theme.current.mode == .dark ? UIImage.logoWhite.cgImage : UIImage.logo.cgImage
        imageLayer.add(AnimationManager.shared.animatePulsatingLayer(), forKey: nil)
        
        containerView.layer.addSublayer(imageLayer)
        self.view.addSubview(containerView)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        self.containerNode.style.preferredSize = CGSize(width: UIScreen.main.bounds.width * 0.9, height: 120)
        return ASWrapperLayoutSpec(layoutElement: self.containerNode)
    }
}
