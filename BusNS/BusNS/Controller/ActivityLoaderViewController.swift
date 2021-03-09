//
//  ActivityLoaderViewController.swift
//  BusNS
//
//  Created by Marko Popić on 11/23/19.
//  Copyright © 2019 Crystal Pigeon. All rights reserved.
//

import AsyncDisplayKit

class ActivityLoaderViewController: ASDKViewController<ASDisplayNode> {
    
    private let containerNode: ASDisplayNode
    public var isOnScreen: Bool {
        return self.isViewLoaded && view.window != nil
    }
    
    override init() {
        self.containerNode = ASDisplayNode()
        super.init(node: containerNode)
        self.containerNode.backgroundColor = UIColor.black.withAlphaComponent(0.25)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        let containerView = UIView(frame: self.view.bounds)
        
        let imageLayer = CAShapeLayer()
        imageLayer.backgroundColor = UIColor.clear.cgColor
        imageLayer.bounds = CGRect(x: UIScreen.main.bounds.midX - 42, y: UIScreen.main.bounds.midY - 40, width: 84, height: 80)
        imageLayer.position = CGPoint(x: UIScreen.main.bounds.midX ,y: UIScreen.main.bounds.midY)
        imageLayer.contents = UIImage(named: "logo-white")?.cgImage
        imageLayer.add(AnimationManager.shared.animatePulsatingLayer(), forKey: nil)
        
        let textLayer = CATextLayer()
        textLayer.backgroundColor = UIColor.clear.cgColor
        textLayer.frame = CGRect(x: UIScreen.main.bounds.midX - 75, y: UIScreen.main.bounds.midY + 60, width: 150, height: 20)
        textLayer.string = "Loading lines...".localized()
        textLayer.fontSize = 14
        textLayer.font = Fonts.muliRegular10
        textLayer.foregroundColor = Theme.current.color(.animationTextColor).cgColor
        textLayer.alignmentMode = .center
        textLayer.contentsScale = UIScreen.main.scale
        
        containerView.layer.addSublayer(imageLayer)
        containerView.layer.addSublayer(textLayer)
        self.view.addSubview(containerView)
    }
    
    public func stop() {
        self.dismiss(animated: false, completion: nil)
    }
}
