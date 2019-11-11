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
    private var linesViewModel = AddLinesViewModel()
    
    init() {
        self.containerNode = ASDisplayNode()
        super.init(node: containerNode)
        self.containerNode.automaticallyManagesSubnodes = true
        self.title = "Add lines".localized()
        linesViewModel.observer = self
        linesViewModel.fetchLines()
        tableNode.delegate = self
        tableNode.dataSource = self
        layout()
        appearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func lineTypeButtonTapped(sender: ASButtonNode) {
        self.linesViewModel.changeLineType(isTypeUrban: sender == self.urbanBusesButton)
        self.tableNode.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        UIView.animate(withDuration: 0.3) {
            if sender == self.urbanBusesButton {
                self.separatorNode.position.x = 0 + (UIScreen.main.bounds.width / 4)
            } else if sender == self.suburbanBusesButton {
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
        
        self.suburbanBusesButton.setAttributedTitle(self.node.attributed(text: "Suburban".localized(), color: Theme.current.color(.navigationTintColor), font: Fonts.muliRegular15), for: .normal)
        self.urbanBusesButton.setAttributedTitle(self.node.attributed(text: "Urban".localized(), color: Theme.current.color(.navigationTintColor), font: Fonts.muliRegular15), for: .normal)
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

//MARK: Table delegate & data source
extension AddLinesViewController: ASTableDataSource, ASTableDelegate {
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 1
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return linesViewModel.lines.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        
        let cellNode = ASTextCellNode()
        cellNode.textAttributes = [
            NSAttributedString.Key.font: Fonts.muliRegular15,
            NSAttributedString.Key.foregroundColor: Theme.current.color(.lineTextColor)
        ]
        cellNode.selectionStyle = .none
        cellNode.text = linesViewModel.lines[indexPath.row].number + "  " + linesViewModel.lines[indexPath.row].name
        
        return cellNode
    }
}

extension AddLinesViewController: AddLinesObserver {
    func refreshUI() {
        self.tableNode.reloadData()
    }
    
    func showError(message: String) {
        self.showAlert(title: "", message: message, duration: 2)
    }
}
