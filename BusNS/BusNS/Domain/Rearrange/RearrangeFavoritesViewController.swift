//
//  RearrangeFavoritesViewController.swift
//  BusNS
//
//  Created by Ena Vorkapic on 11/25/19.
//  Copyright © 2019 Crystal Pigeon. All rights reserved.
//

import AsyncDisplayKit
import FirebaseAnalytics
import UIKit

class RearrangeFavoritesViewController: BaseViewController {
    
    //MARK: UI Properties
    private var tableNode = ASTableNode()
    private let viewModel = RearrangeFavoritesViewModel()
    private let noDataNode = NoDataNode(text: "You haven't added any lines to favorites".localized())
}

extension RearrangeFavoritesViewController {
    override func setupUI() {
        super.setupUI()
        self.title = "Rearrange".localized()
        self.tableNode.backgroundColor = .background
        self.tableNode.delegate = self
        self.tableNode.dataSource = self
        self.tableNode.view.isEditing = true
        self.tableNode.view.separatorColor = .secondaryText
        self.tableNode.view.tableFooterView = UIView()
        self.tableNode.view.backgroundView = self.viewModel.favorites.isEmpty ? noDataNode.view : nil
    }
    
    override func setupLayout() {
        super.setupLayout()
        self.node.layoutSpecBlock = { [weak self] node, constrainedSize in
            guard let self = self else { return ASLayoutSpec() }
            return ASWrapperLayoutSpec(layoutElement: self.tableNode)
        }
    }
}

//MARK: - Table
extension RearrangeFavoritesViewController: ASTableDataSource, ASTableDelegate {
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.favorites.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        let bus = self.viewModel.getBusNameBy(id: viewModel.favorites[indexPath.row])
        let cell = ASTextCellNode()
        cell.textNode.attributedText = NSAttributedString(bus, color: .primaryText, font: .muliSemiBold15)
        cell.backgroundColor = .clear
        cell.textNode.pointSizeScaleFactors = [0.9,0.8]
        cell.textNode.maximumNumberOfLines = 1
        return cell
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
        Analytics.logEvent("sort_favorite_lanes", parameters: nil)
        viewModel.rearrange(sourceIndexPath: sourceIndexPath, destinationIndexPath: destinationIndexPath)
    }
}
