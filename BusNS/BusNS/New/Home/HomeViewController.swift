//
//  HomeViewController.swift
//  BusNS
//
//  Created by Marko Popić on 10/28/21.
//  Copyright © 2021 Crystal Pigeon. All rights reserved.
//

import AsyncDisplayKit
import UIKit

class HomeViewController: PagerViewController {
    
    private let addButton = RoundedButton()
    private let viewModel = HomeViewModel()
    
    override init() {
        super.init()
        self.tabNode = TabNode(items: [
            "Work day".localized(),
            "Saturday".localized(),
            "Sunday".localized()], selectedIndex: Date.currentWeekday)
        self.tabControllers = tabNode.items.map({ item in
            return HomeDataViewController(tabName: item)
        })
    }
    
    func reloadControllers() {
        for tabController in tabControllers {
            guard let controller = tabController as? HomeDataViewController else { continue }
            switch controller.tabName {
                case "Saturday".localized(): controller.setData(self.viewModel.saturdayBuses)
                case "Sunday".localized(): controller.setData(self.viewModel.sundayBuses)
                default: controller.setData(self.viewModel.workdayBuses)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.reloadControllers()
    }
}

//MARK: - Setup
extension HomeViewController {
    override func setupData() {
        super.setupData()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: .gearshape, style: .plain, target: self, action: #selector(settingsButtonClicked))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: .arrange, style: .plain, target: self, action: #selector(arrangeButtonClicked))
        self.addButton.addTarget(self, action: #selector(addButtonClicked), forControlEvents: .touchUpInside)
        DownloadManager.shared.addObserver(self)
    }
    
    override func setupUI() {
        super.setupUI()
        self.title = DatabaseManager.shared.season?.season ?? "Red Vožnje".localized()
    }
    
    override func setupLayout() {
        super.setupLayout()
        self.node.layoutSpecBlock = { [weak self] node, constrainedSize in
            guard let self = self else { return ASLayoutSpec() }
            let stack = ASStackLayoutSpec.vertical()
            stack.children = [self.tabNode, self.pager]
            self.pager.style.height = ASDimensionMake(constrainedSize.max.height - self.tabNode.calculatedSize.height)
            
            let inset = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 20), child: self.addButton)
            
            let addButtonStack = ASStackLayoutSpec.vertical()
            addButtonStack.alignItems = .end
            addButtonStack.verticalAlignment = .bottom
            addButtonStack.child = inset
            
            let overlay = ASOverlayLayoutSpec(child: stack, overlay: addButtonStack)
            return overlay
        }
    }
}

//MARK: - Button Actions
extension HomeViewController {
    @objc private func settingsButtonClicked() {
        self.navigationController?.pushViewController(HelpViewController(), animated: true)
    }
    
    @objc private func arrangeButtonClicked() {
        self.navigationController?.pushViewController(RearrangeFavoritesViewController(), animated: true)
    }
    
    @objc private func addButtonClicked() {
        self.navigationController?.pushViewController(LinesViewController(), animated: true)
    }
}

//MARK: - Downloader
extension HomeViewController: DownloadObserver {
    func downloaderDidFinish() {
        self.reloadControllers()
        self.setupUI()
    }
}
