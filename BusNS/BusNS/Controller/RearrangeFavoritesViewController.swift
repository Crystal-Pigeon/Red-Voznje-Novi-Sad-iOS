//
//  RearrangeFavoritesViewController.swift
//  BusNS
//
//  Created by Ena Vorkapic on 11/25/19.
//  Copyright © 2019 Crystal Pigeon. All rights reserved.
//

import AsyncDisplayKit

class RearrangeFavoritesViewController: ASDKViewController<ASDisplayNode> {
    //MARK: UI Properties
    private let containerNode: ASDisplayNode
    private var tableNode = ASTableNode()
    private let rearrangeFavoritesViewModel = RearrangeFavoritesViewModel()
    
    override init() {
        self.containerNode = ASDisplayNode()
        super.init(node: containerNode)
        self.title = "Rearrange".localized()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.containerNode.automaticallyManagesSubnodes = true
        self.containerNode.backgroundColor = Theme.current.color(.settingsBackgroundColor)
        self.layout()
        if #available(iOS 13.0, *), Theme.current.mode != .auto {
            self.view.overrideUserInterfaceStyle = Theme.current.mode == .dark ? .dark : .light
        }
    }
    
    override func updateColor() {
        tableNode.backgroundColor = Theme.current.color(.rearrangeFavoritesTable)
        tableNode.view.separatorColor = rearrangeFavoritesViewModel.favorites.isEmpty ? UIColor.clear : Theme.current.color(.tableSeparatorColor)
        self.containerNode.backgroundColor = Theme.current.color(.settingsBackgroundColor)
        self.tableNode.reloadData()
        if #available(iOS 13.0, *), Theme.current.mode != .auto {
            self.view.overrideUserInterfaceStyle = Theme.current.mode == .dark ? .dark : .light
        }
    }
}

extension RearrangeFavoritesViewController {
    private func layout() {
        self.tableNode = initTableNode()
        self.containerNode.layoutSpecBlock = { node, constrainedSize in
            self.tableNode.style.preferredLayoutSize = ASLayoutSize(width: ASDimensionMake(constrainedSize.max.width), height: ASDimensionMake(constrainedSize.max.height))
            return ASWrapperLayoutSpec(layoutElement: self.tableNode)
        }
    }
    
    private func initTableNode() -> ASTableNode {
        let tableNode = ASTableNode()
        tableNode.backgroundColor = Theme.current.color(.rearrangeFavoritesTable)
        tableNode.delegate = self
        tableNode.dataSource = self
        tableNode.view.isEditing = true
        tableNode.view.separatorColor = rearrangeFavoritesViewModel.favorites.isEmpty ? UIColor.clear : Theme.current.color(.tableSeparatorColor)
        tableNode.view.tableFooterView = UIView(frame: .zero)
        return tableNode
    }
}

//MARK: Table source and delegate
extension RearrangeFavoritesViewController: ASTableDataSource, ASTableDelegate {
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 1
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return !self.rearrangeFavoritesViewModel.favorites.isEmpty ? self.rearrangeFavoritesViewModel.favorites.count : 1
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        let cellNode = ASTextCellNode()
        cellNode.textAttributes = [
            NSAttributedString.Key.font: Fonts.muliRegular15,
            NSAttributedString.Key.foregroundColor: Theme.current.color(.rearrangeFavoritesLineColor)
        ]
        cellNode.selectionStyle = .none
        cellNode.text = !self.rearrangeFavoritesViewModel.favorites.isEmpty ? rearrangeFavoritesViewModel.getBusNameBy(id: rearrangeFavoritesViewModel.favorites[indexPath.row]) : "You haven't added any lines to favorites".localized()
        
        return cellNode
    }
    
     func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }

     func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return !self.rearrangeFavoritesViewModel.favorites.isEmpty
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        rearrangeFavoritesViewModel.rearrange(sourceIndexPath: sourceIndexPath, destinationIndexPath: destinationIndexPath)
    }
}
