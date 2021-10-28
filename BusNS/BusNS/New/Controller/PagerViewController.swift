//
//  PagerViewController.swift
//  Skenit Admin
//
//  Created by Marko Popić on 10/25/21.
//

import AsyncDisplayKit
import UIKit

//MARK: - TabPager protocol
protocol TabPager {
    func scrollToPage(at index: Int)
}

//MARK: - PagerChildViewController
class PagerChildViewController: BaseViewController {
    var tabName: String
    weak var containerViewController: PagerViewController?
    
    init(tabName: String) {
        self.tabName = tabName
        super.init()
    }
}

//MARK: - PagerViewController
class PagerViewController: BaseViewController {
    
    var tabNode: TabNode
    var tabControllers: [PagerChildViewController]
    var pager = ASPagerNode()
    
    override init() {
        self.tabNode = TabNode(items: [], selectedIndex: 0)
        self.tabControllers = self.tabNode.items.map({ item in
            return PagerChildViewController(tabName: item)
        })
        super.init()
    }
    
    func setupDelegates() {
        self.pager.setDelegate(self)
        self.pager.setDataSource(self)
        self.tabNode.tabPager = self
        for controller in self.tabControllers {
            controller.containerViewController = self
        }
    }
    
    override func setupUI() {
        super.setupUI()
        self.pager.backgroundColor = .background
    }
    
    override func setupData() {
        super.setupData()
        self.setupDelegates()
    }
}

//MARK: - Pager delegate
extension PagerViewController: ASPagerDelegate, ASPagerDataSource, UIScrollViewDelegate, TabPager {
    func numberOfPages(in pagerNode: ASPagerNode) -> Int {
        return tabNode.items.count
    }
    
    func pagerNode(_ pagerNode: ASPagerNode, nodeAt index: Int) -> ASCellNode {
        let cell = ASCellNode { () -> PagerChildViewController in
            return self.tabControllers[index]
        }
        return cell
    }
    
    func scrollToPage(at index: Int) {
        DispatchQueue.main.async {
            self.pager.scrollToPage(at: index, animated: true)
        }
    }
    
    func scrollToNextPage() {
        DispatchQueue.main.async {
            let nextPage = self.pager.currentPageIndex + 1
            if nextPage < self.tabControllers.count {
                self.pager.scrollToPage(at: nextPage, animated: true)
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.pager.view {
            self.tabNode.moveLine(to: scrollView.contentOffset)
        }
    }
}
