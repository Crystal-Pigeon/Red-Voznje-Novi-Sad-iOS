//
//  RearrangeFavoritesViewController.swift
//  BusNS
//
//  Created by Ena Vorkapic on 11/25/19.
//  Copyright © 2019 Crystal Pigeon. All rights reserved.
//

import AsyncDisplayKit

class RearrangeFavoritesViewController: ASViewController<ASDisplayNode> {
    //MARK: UI Properties
    private let containerNode: ASDisplayNode
    private var tableNode = ASTableNode()
    private let rearrangeFavoritesViewModel = RearrangeFavoritesViewModel()
    
    init() {
        self.containerNode = ASDisplayNode()
        super.init(node: containerNode)
        self.containerNode.automaticallyManagesSubnodes = true
        self.containerNode.backgroundColor = Theme.current.color(.settingsBackgroundColor)
        self.title = "Rearrange favorites".localized()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RearrangeFavoritesViewController {
    private func layout() {
        self.containerNode.layoutSpecBlock = { node, constrainedSize in
            self.tableNode = self.initTableNode(width: constrainedSize.max.width, height: constrainedSize.max.height)
            return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), child: self.tableNode)
        }
    }
    
    private func initTableNode(width: CGFloat, height: CGFloat) -> ASTableNode {
        let tableNode = ASTableNode()
        tableNode.style.preferredLayoutSize = ASLayoutSize(width: ASDimensionMake(width), height: ASDimensionMake(height - (height * 0.07 + 3)))
        tableNode.backgroundColor = Theme.current.color(.addLinesTable)
        tableNode.delegate = self
        tableNode.dataSource = self
        tableNode.view.isEditing = true
        if Theme.current.mode == .dark {
            tableNode.view.separatorColor = Theme.current.color(.tableSeparatorColor)
        }
        return tableNode
    }
}

//MARK: Table source and delegate
extension RearrangeFavoritesViewController: ASTableDataSource, ASTableDelegate {
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 1
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return self.rearrangeFavoritesViewModel.favorites.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        
        let cellNode = ASTextCellNode()
        cellNode.textAttributes = [
            NSAttributedString.Key.font: Fonts.muliRegular15,
            NSAttributedString.Key.foregroundColor: Theme.current.color(.busCell_lineTextColor)
        ]
        cellNode.selectionStyle = .none
        
        if let bus = BusManager.getBusBy(id: rearrangeFavoritesViewModel.favorites[indexPath.row])?.first {
            cellNode.text = bus.number + " " + bus.name
        }
        return cellNode
    }
    
     func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }

     func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        rearrangeFavoritesViewModel.rearrange(sourceIndexPath: sourceIndexPath, destinationIndexPath: destinationIndexPath)
    }
}
