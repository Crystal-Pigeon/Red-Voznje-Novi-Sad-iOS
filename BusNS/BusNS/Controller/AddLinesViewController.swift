//
//  AddLinesViewController.swift
//  BusNS
//
//  Created by Ena Vorkapic on 11/11/19.
//  Copyright © 2019 Crystal Pigeon. All rights reserved.
//

import AsyncDisplayKit

class AddLinesViewController: ASViewController<ASDisplayNode> {
    
    //MARK: UI Properties
    private let containerNode: ASDisplayNode
    private let tableNode = ASTableNode()
    private let urbanBusesButton = ASButtonNode()
    private let suburbanBusesButton = ASButtonNode()
    private let separatorNode = ASDisplayNode()
    private let buses: [String] = []
    
    init() {
        self.containerNode = ASDisplayNode()
        super.init(node: containerNode)
        self.containerNode.automaticallyManagesSubnodes = true
        self.title = "Add lines".localized()
        tableNode.delegate = self
        tableNode.dataSource = self
        layout()
        appearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func lineTypeButtonTapped(sender: ASButtonNode) {
        if sender == urbanBusesButton {
            UIView.animate(withDuration: 0.3) {
                self.separatorNode.position.x = 0 + (UIScreen.main.bounds.width / 4)
            }
        }
        else if sender == suburbanBusesButton {
            UIView.animate(withDuration: 0.3) {
                self.separatorNode.position.x = UIScreen.main.bounds.width / 2 + (UIScreen.main.bounds.width / 4)
            }
        }
    }
}

//MARK: Layout
extension AddLinesViewController {
    
    private func layout() {
        containerNode.layoutSpecBlock = { node, constrainedSize in
            let stack = ASStackLayoutSpec.vertical()
            let buttonStack = self.initLinesTypeButtonsLayout(width: constrainedSize.max.width, height: constrainedSize.max.height)
            
            self.suburbanBusesButton.addTarget(self, action: #selector(self.lineTypeButtonTapped(sender:)), forControlEvents: .touchUpInside)
            self.urbanBusesButton.addTarget(self, action: #selector(self.lineTypeButtonTapped(sender:)), forControlEvents: .touchUpInside)
            
            stack.children = [buttonStack, self.tableNode]
            self.tableNode.style.preferredSize = CGSize(width: constrainedSize.max.width, height: constrainedSize.max.height - (constrainedSize.max.height * 0.07 + 3))
            return stack
        }
    }
    
    private func appearance() {
        self.separatorNode.backgroundColor = Theme.current.color(.dayIndicatorColor)
        
        self.suburbanBusesButton.backgroundColor = Theme.current.color(.navigationBackgroundColor)
        self.urbanBusesButton.backgroundColor = Theme.current.color(.navigationBackgroundColor)
        
        self.suburbanBusesButton.setAttributedTitle(self.node.attributedText(with: "Suburban".localized(), color: Theme.current.color(.navigationTintColor), uiFont: Fonts.muliRegular15), for: .normal)
        self.urbanBusesButton.setAttributedTitle(self.node.attributedText(with: "Urban".localized(), color: Theme.current.color(.navigationTintColor), uiFont: Fonts.muliRegular15), for: .normal)
    }
    
    private func initLinesTypeButtonsLayout(width: CGFloat, height: CGFloat) -> ASDisplayNode {
        let linesTypeContainterNode = ASDisplayNode()
        linesTypeContainterNode.automaticallyManagesSubnodes = true
        linesTypeContainterNode.backgroundColor = Theme.current.color(.navigationBackgroundColor)
        linesTypeContainterNode.style.preferredLayoutSize = ASLayoutSizeMake(ASDimensionMake(width), ASDimensionMake((height * 0.07) + 3))
        
        linesTypeContainterNode.layoutSpecBlock = { node, constrainedSize in
            let horizontalStack = ASStackLayoutSpec.horizontal()
            self.urbanBusesButton.style.preferredLayoutSize = ASLayoutSizeMake(ASDimensionMake(width / 2), ASDimensionMake(height * 0.07))
            self.suburbanBusesButton.style.preferredLayoutSize = ASLayoutSizeMake(ASDimensionMake(width / 2), ASDimensionMake(height * 0.07))
            self.separatorNode.style.preferredLayoutSize = ASLayoutSizeMake(ASDimensionMake(width / 2), ASDimensionMake(height * 0.01))
            horizontalStack.children = [self.urbanBusesButton, self.suburbanBusesButton]
            
            let verticalStack = ASStackLayoutSpec.vertical()
            verticalStack.children = [horizontalStack, self.separatorNode]
            return verticalStack
        }
        
        return linesTypeContainterNode
    }
}

extension AddLinesViewController: ASTableDataSource, ASTableDelegate {
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 1
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return buses.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        
        let cellNode = ASTextCellNode()
        cellNode.textAttributes = [
            NSAttributedString.Key.font: Fonts.muliRegular15,
            NSAttributedString.Key.foregroundColor: Theme.current.color(.lineTextColor)
        ]
        for bus in buses {
            cellNode.text = bus
        }
        return cellNode
    }
}
