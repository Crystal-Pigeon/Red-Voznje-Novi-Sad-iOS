//
//  LinesViewController.swift
//  BusNS
//
//  Created by Marko Popić on 10/28/21.
//  Copyright © 2021 Crystal Pigeon. All rights reserved.
//

import AsyncDisplayKit
import UIKit

class LinesViewController: PagerViewController {
    
    private let viewModel = LinesViewModel()
    
    override init() {
        super.init()
        self.tabNode = TabNode(items: [
            "Urban".localized(),
            "Subrban".localized()], selectedIndex: 0)
        self.tabControllers = tabNode.items.map({ item in
            return LinesDataViewController(tabName: item)
        })
    }
    
    func reloadControllers() {
        for tabController in tabControllers {
            guard let controller = tabController as? LinesDataViewController else { continue }
            switch controller.tabName {
                case "Urban".localized(): controller.setData(self.viewModel.urbanLines)
                default: controller.setData(self.viewModel.suburbanLines)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.reloadControllers()
    }
}

//MARK: - Setup
extension LinesViewController {
    override func setupData() {
        super.setupData()
        self.title = "Add lines".localized()
    }
    
    override func setupUI() {
        super.setupUI()
    }
    
    override func setupLayout() {
        super.setupLayout()
        self.node.layoutSpecBlock = { [weak self] node, constrainedSize in
            guard let self = self else { return ASLayoutSpec() }
            let stack = ASStackLayoutSpec.vertical()
            stack.children = [self.tabNode, self.pager]
            self.pager.style.flexGrow = 100
//            self.pager.style.height = ASDimensionMake(constrainedSize.max.height - self.tabNode.calculatedSize.height)
            return stack
        }
    }
}

