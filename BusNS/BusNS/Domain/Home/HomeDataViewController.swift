//
//  HomeDataViewController.swift
//  BusNS
//
//  Created by Marko Popić on 10/28/21.
//  Copyright © 2021 Crystal Pigeon. All rights reserved.
//

import AsyncDisplayKit
import UIKit
import FirebaseAnalytics

class HomeDataViewController: PagerChildViewController {
    
    private var data = [Bus]()
    private let collectionNode: ASCollectionNode
    private let noDataNode = NoDataNode(text: "Click the \"+\" button to add buses".localized())
    private var refreshControl = UIRefreshControl()
    
    override init(tabName: String) {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 20
        flowLayout.sectionInset.top = 20
        self.collectionNode = ASCollectionNode(collectionViewLayout: flowLayout)
        super.init(tabName: tabName)
    }
    
    func setData(_ data: [Bus]) {
        self.data = data
        self.collectionNode.reloadSections([0])
        self.reloadBackgroundView()
    }
    
    func reloadBackgroundView() {
        self.collectionNode.view.backgroundView = data.isEmpty ? noDataNode.view : nil
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.collectionNode.reloadSections([0])
    }
    
    @objc private func handleLongPress(sender: UILongPressGestureRecognizer){
        if sender.state != .began { return }
        let touchPoint = sender.location(in: self.collectionNode.view)
        guard let indexPath = self.collectionNode.view.indexPathForItem(at: touchPoint) else { return }
        let bus = self.data[indexPath.row]
        
        Haptic.shared.pulse()
        let actionDelete = UIAlertAction(title: "Remove".localized(), style: .destructive) { (action) in
            Analytics.logEvent("delete_lane_on_long_press", parameters: ["lane_number": bus.id])
            
            //Local delete
            self.data.remove(at: indexPath.row)
            self.collectionNode.deleteItems(at: [indexPath])
            self.reloadBackgroundView()
            
            //Delete in database
            DatabaseManager.shared.removeFavorite(id: bus.id)
            
            //Reload all tabs in container
            if let controller = self.containerViewController as? HomeViewController {
                controller.reloadControllers()
            }
        }
        
        self.showActionSheet(with: bus.fullName, message: "Are you sure you want remove the line?".localized(), actions: [actionDelete], frame: CGRect(x: touchPoint.x, y: touchPoint.y, width: 0, height: 0))
    }
}

//MARK: - Setup
extension HomeDataViewController {
    override func setupData() {
        super.setupData()
        self.collectionNode.delegate = self
        self.collectionNode.dataSource = self
        self.collectionNode.view.refreshControl = self.refreshControl
        self.refreshControl.addTarget(self, action: #selector(self.pullToRefresh), for: .valueChanged)
        self.refreshControl.layer.zPosition = -1
    }
    
    override func setupUI() {
        super.setupUI()
        self.collectionNode.showsVerticalScrollIndicator = false
        self.collectionNode.backgroundColor = .background
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPress.minimumPressDuration = 0.4
        self.view.addGestureRecognizer(longPress)
    }
    
    override func setupLayout() {
        super.setupLayout()
        self.node.layoutSpecBlock = { [weak self] node, constrainedSize in
            guard let self = self else { return ASLayoutSpec() }
            return ASWrapperLayoutSpec(layoutElement: self.collectionNode)
        }
    }
}

//MARK: - Collection delegate
extension HomeDataViewController: ASCollectionDelegate, ASCollectionDataSource {
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeForItemAt indexPath: IndexPath) -> ASCellNode {
        let bus = self.data[indexPath.row]
        let cell = BusCell(bus: bus)
        return cell
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, didSelectItemAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            guard let cell = collectionNode.nodeForItem(at: indexPath) as? BusCell else { return }
            cell.isOpened = !cell.isOpened
        }
    }
}

//MARK: - Pull to refresh
extension HomeDataViewController {
    @objc func pullToRefresh() {
        self.showChooseAlert(title: "pull_refresh_title".localized(), message: "pull_refresh_message".localized(), cancel: "Cancel".localized(), option: "pull_refresh_action".localized()) {
            DownloadManager.shared.downloadData()
            self.refreshControl.endRefreshing()
        } cancelCompletion: {
            self.refreshControl.endRefreshing()
        }
    }
}
