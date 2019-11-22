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
    private let urbanBusesButton = ASButtonNode()
    private let suburbanBusesButton = ASButtonNode()
    private let separatorNode = ASDisplayNode()
    private var linesViewModel = AddLinesViewModel()
    private let scrollNode = ASScrollNode()
    private var urbanBusesTableNode = ASTableNode()
    private var suburbanBusesTableNode = ASTableNode()
    
    init() {
        self.containerNode = ASDisplayNode()
        super.init(node: containerNode)
        self.containerNode.automaticallyManagesSubnodes = true
        self.scrollNode.automaticallyManagesSubnodes = true
        self.title = "Add lines".localized()
        linesViewModel.observer = self
        layout()
        scrollLayout()
        appearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        linesViewModel.getLines()
        self.scrollNode.view.isPagingEnabled = true
        self.scrollNode.view.showsHorizontalScrollIndicator = false
        self.scrollNode.view.delegate = self
    }
    
    @objc private func lineTypeButtonTapped(sender: ASButtonNode) {
        if sender == self.urbanBusesButton {
            self.scrollNode.view.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        } else if sender == self.suburbanBusesButton {
            self.scrollNode.view.setContentOffset(CGPoint(x: UIScreen.main.bounds.width, y: 0), animated: true)
        }
    }
}

//MARK: Layout
extension AddLinesViewController {
    private func layout() {
        let buttonStack = self.initLinesTypeButtonsLayout(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.urbanBusesTableNode = self.initTableNode(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.suburbanBusesTableNode = self.initTableNode(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        self.containerNode.layoutSpecBlock = { node, constrainedSize in
            let stack = ASStackLayoutSpec.vertical()
            stack.children = [buttonStack, self.scrollNode]
            return stack
        }
    }
    
    private func scrollLayout() {
        self.scrollNode.layoutSpecBlock = { node, size in
            self.scrollNode.view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: UIScreen.main.bounds.width * 2)
            let stack = ASStackLayoutSpec.horizontal()
            stack.children = [self.urbanBusesTableNode, self.suburbanBusesTableNode]
            return stack
        }
    }
    
    private func appearance() {
        self.separatorNode.backgroundColor = Theme.current.color(.dayIndicatorColor)
        
        self.suburbanBusesButton.backgroundColor = Theme.current.color(.navigationBackgroundColor)
        self.urbanBusesButton.backgroundColor = Theme.current.color(.navigationBackgroundColor)
        
        self.suburbanBusesButton.setAttributedTitle(self.node.attributed(text: "Suburban".localized(), color: Theme.current.color(.navigationTintColor), font: Fonts.muliRegular15), for: .normal)
        self.urbanBusesButton.setAttributedTitle(self.node.attributed(text: "Urban".localized(), color: Theme.current.color(.navigationTintColor), font: Fonts.muliRegular15), for: .normal)
        
        self.suburbanBusesButton.addTarget(self, action: #selector(self.lineTypeButtonTapped(sender:)), forControlEvents: .touchUpInside)
        self.urbanBusesButton.addTarget(self, action: #selector(self.lineTypeButtonTapped(sender:)), forControlEvents: .touchUpInside)
    }
    
    private func initTableNode(width: CGFloat, height: CGFloat) -> ASTableNode {
        let tableNode = ASTableNode()
        tableNode.style.preferredLayoutSize = ASLayoutSize(width: ASDimensionMake(width), height: ASDimensionMake(height - (height * 0.07 + 3)))
        tableNode.backgroundColor = Theme.current.color(.addLinesTable)
        tableNode.delegate = self
        tableNode.dataSource = self
        return tableNode
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
        if tableNode == self.urbanBusesTableNode {
            return linesViewModel.urbanLines.count
        } else {
            return linesViewModel.suburbanLines.count
        }
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        
        let cellNode = ASTextCellNode()
        cellNode.textAttributes = [
            NSAttributedString.Key.font: Fonts.muliRegular15,
            NSAttributedString.Key.foregroundColor: Theme.current.color(.busCell_lineTextColor)
        ]
        cellNode.selectionStyle = .none
        
        if tableNode == self.urbanBusesTableNode {
            cellNode.text = linesViewModel.urbanLines[indexPath.row].number + "  " + linesViewModel.urbanLines[indexPath.row].name
            if linesViewModel.favorites.contains(linesViewModel.urbanLines[indexPath.row].id) {
                 cellNode.accessoryType = .checkmark
            }
        } else {
            cellNode.text = linesViewModel.suburbanLines[indexPath.row].number + "  " + linesViewModel.suburbanLines[indexPath.row].name
            if linesViewModel.favorites.contains(linesViewModel.suburbanLines[indexPath.row].id) {
                 cellNode.accessoryType = .checkmark
            }
        }
        return cellNode
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        if tableNode == self.urbanBusesTableNode {
            let line = linesViewModel.urbanLines[indexPath.row]
            linesViewModel.addToFavourites(id: line.id)
        } else {
            let line = linesViewModel.suburbanLines[indexPath.row]
            linesViewModel.addToFavourites(id: line.id)
        }
        tableNode.reloadRows(at: [indexPath], with: .fade)
    }
}

//MARK: Observer
extension AddLinesViewController: AddLinesObserver {
    func refreshUI() {
        self.urbanBusesTableNode.reloadData()
        self.suburbanBusesTableNode.reloadData()
    }
    func showLoader() {
        print("LOADER")
    }
}

//MARK: Scrolling between scrollView pages
extension AddLinesViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView != self.scrollNode.view { return }
        self.separatorNode.position.x = scrollView.contentOffset.x/2 + (self.separatorNode.calculatedSize.width / 2)
    }
}
