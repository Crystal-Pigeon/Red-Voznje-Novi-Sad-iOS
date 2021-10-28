//
//  LinesDataViewController.swift
//  BusNS
//
//  Created by Marko Popić on 10/28/21.
//  Copyright © 2021 Crystal Pigeon. All rights reserved.
//

import AsyncDisplayKit
import UIKit
import FirebaseAnalytics

class LinesDataViewController: PagerChildViewController {
    
    private var data = [Line]()
    private let tableNode = ASTableNode()
    private let noDataNode = NoDataNode(text: "There is no schedule".localized())
    
    func setData(_ data: [Line]) {
        self.data = data
        self.tableNode.reloadSections([0], with: .fade)
        self.reloadBackgroundView()
    }
    
    func reloadBackgroundView() {
        self.tableNode.view.backgroundView = data.isEmpty ? noDataNode.view : nil
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.tableNode.reloadSections([0], with: .fade)
    }
}

//MARK: - Setup
extension LinesDataViewController {
    override func setupData() {
        super.setupData()
        self.tableNode.delegate = self
        self.tableNode.dataSource = self
    }
    
    override func setupUI() {
        super.setupUI()
        self.tableNode.backgroundColor = .background
        self.tableNode.view.separatorColor = .secondaryText
        self.tableNode.view.tableFooterView = UIView()
        self.tableNode.view.showsVerticalScrollIndicator = false
        self.tableNode.view.contentInsetAdjustmentBehavior = .never
        self.tableNode.contentInset.bottom = 30
    }
    
    override func setupLayout() {
        super.setupLayout()
        self.node.layoutSpecBlock = { [weak self] node, constrainedSize in
            guard let self = self else { return ASLayoutSpec() }
            return ASWrapperLayoutSpec(layoutElement: self.tableNode)
        }
    }
}

//MARK: - Table delegate
extension LinesDataViewController: ASTableDelegate, ASTableDataSource {
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        let data = self.data[indexPath.row]
        let cell = ASTextCellNode()
        cell.textNode.attributedText = NSAttributedString(data.fullName, color: .primaryText, font: .muliSemiBold15)
        cell.backgroundColor = .clear
        cell.textNode.pointSizeScaleFactors = [0.9,0.8]
        cell.textNode.maximumNumberOfLines = 1
        cell.selectionStyle = .none
        cell.accessoryType = DatabaseManager.shared.favorites.contains(data.id) ? .checkmark : .none
        return cell
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        Haptic.shared.pulse()
        let data = self.data[indexPath.row]
        if DatabaseManager.shared.favorites.contains(data.id) {
            DatabaseManager.shared.removeFavorite(id: data.id)
        } else {
            DatabaseManager.shared.appendFavorite(id: data.id)
        }
        tableNode.reloadRows(at: [indexPath], with: .fade)
    }
}
