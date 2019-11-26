//
//  MainViewController.swift
//  BusNS
//
//  Created by Ena Vorkapic on 11/12/19.
//  Copyright © 2019 Crystal Pigeon. All rights reserved.
//

import AsyncDisplayKit

class MainViewController: ASViewController<ASDisplayNode> {
    
    //MARK: UI Properties
    private let containerNode: ASDisplayNode
    private let workdayButton = ASButtonNode()
    private let saturdayButton = ASButtonNode()
    private let sundayButton = ASButtonNode()
    private let separatorNode = ASDisplayNode()
    private let messageLabelNode = ASTextNode()
    private let logoImageNode = ASImageNode()
    private var workDayBusesCollectionNode: ASCollectionNode!
    private var saturdayBusesCollectionNode: ASCollectionNode!
    private var sundayBusesCollectionNode: ASCollectionNode!
    private let scrollNode = ASScrollNode()
    private var mainViewModel = MainViewModel()
    
    init() {
        self.containerNode = ASDisplayNode()
        super.init(node: containerNode)
        self.containerNode.automaticallyManagesSubnodes = true
        self.title = "Bus NS".localized()
        self.containerNode.backgroundColor = Theme.current.color(.backgroundColor)
        self.scrollNode.automaticallyManagesSubnodes = true
        self.scrollNode.backgroundColor = Theme.current.color(.backgroundColor)
        mainViewModel.observer = self
        layout()
        scrollLayout()
        appearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.mainViewModel.getData()
        self.scrollNode.view.isPagingEnabled = true
        self.scrollNode.view.showsHorizontalScrollIndicator = false
        self.scrollNode.view.delegate = self
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPress.minimumPressDuration = 0.4
        self.view.addGestureRecognizer(longPress)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "settings_icon"), landscapeImagePhone: UIImage(named: "settings_icon"), style: .plain, target: self, action: #selector(settingsButtonTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "rearrange_icon"), landscapeImagePhone: UIImage(named: "rearrange_icon"), style: .plain, target: self, action: #selector(rearrangeButtonTapped))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.mainViewModel.shouldSetNeedsLayout() {
            self.scrollNode.setNeedsLayout()
            self.containerNode.setNeedsLayout()
        }
        self.refreshUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if DateManager.instance.getDayOfWeek() == "N" {
            self.scrollNode.view.setContentOffset(CGPoint(x: UIScreen.main.bounds.width / 3 * 6, y: 0), animated: false)
        } else if DateManager.instance.getDayOfWeek() == "S" {
            self.scrollNode.view.setContentOffset(CGPoint(x: UIScreen.main.bounds.width / 3 * 3, y: 0), animated: false)
        } else {
            self.scrollNode.view.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.mainViewModel.resetLastCount()
    }
    
    @objc private func dayButtonTapped(sender: ASButtonNode) {
        if sender == workdayButton {
            if !self.mainViewModel.favorites.isEmpty {
                self.scrollNode.view.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            }
        } else if sender == saturdayButton {
            if !self.mainViewModel.favorites.isEmpty {
                self.scrollNode.view.setContentOffset(CGPoint(x: UIScreen.main.bounds.width / 3 * 3, y: 0), animated: true)
            }
        } else if sender == sundayButton {
            if !self.mainViewModel.favorites.isEmpty {
                self.scrollNode.view.setContentOffset(CGPoint(x: UIScreen.main.bounds.width / 3 * 6, y: 0), animated: true)
            }
        }
    }
    
    @objc private func addButtonTapped(sender: ASButtonNode) {
        guard let navigationController = self.navigationController else { return }
        navigationController.pushViewController(AddLinesViewController(), animated: true)
    }
    
    @objc private func settingsButtonTapped() {
        guard let navigationController = self.navigationController else { return }
        navigationController.pushViewController(SettingsViewController(), animated: true)
    }
    
    @objc private func rearrangeButtonTapped() {
        guard let navigationController = self.navigationController else { return }
        navigationController.pushViewController(RearrangeFavoritesViewController(), animated: true)
    }
    
    @objc private func handleLongPress(sender: UILongPressGestureRecognizer){
        if sender.state == .began {
            let touchPointWD = sender.location(in: workDayBusesCollectionNode.view)
            let touchPointSat = sender.location(in: saturdayBusesCollectionNode.view)
            let touchPointSun = sender.location(in: sundayBusesCollectionNode.view)
            var currentIndexPath: IndexPath?
            if let indexPathWD = workDayBusesCollectionNode.view.indexPathForItem(at: touchPointWD) {
                currentIndexPath = indexPathWD
            } else if let indexPathSat = saturdayBusesCollectionNode.view.indexPathForItem(at: touchPointSat) {
                currentIndexPath = indexPathSat
            } else if let indexPathSun = sundayBusesCollectionNode.view.indexPathForItem(at: touchPointSun) {
                currentIndexPath = indexPathSun
            }
            
            guard let indexPath = currentIndexPath else { return }
            let busID = self.mainViewModel.favorites[indexPath.row]
            let busName = self.mainViewModel.getBusNameBy(id: busID)
            
            let actionSheet = UIAlertController(title: busName, message: "Are you sure you want remove the line?".localized(), preferredStyle: .actionSheet)
            let actionDelete = UIAlertAction(title: "Remove".localized(), style: .destructive) { (action) in
                self.mainViewModel.favorites.remove(at: indexPath.row)
                self.workDayBusesCollectionNode.deleteItems(at: [indexPath])
                self.saturdayBusesCollectionNode.deleteItems(at: [indexPath])
                self.sundayBusesCollectionNode.deleteItems(at: [indexPath])
                StorageManager.store(self.mainViewModel.favorites, to: .caches, as: StorageKeys.favorites)
                if self.mainViewModel.favorites.isEmpty {
                    self.containerNode.setNeedsLayout()
                }
                actionSheet.dismiss(animated: true, completion: nil)
            }
            let actionCancel = UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: nil)
            actionSheet.addAction(actionDelete)
            actionSheet.addAction(actionCancel)
            if #available(iOS 13.0, *), Theme.current.mode == .dark {
                actionSheet.view.overrideUserInterfaceStyle = .dark
            }
            present(actionSheet, animated: true, completion: nil)
        }
    }
}

//MARK: Layout
extension MainViewController {
    private func layout() {
        let emptyScreenStack = self.initEmptyScreenLayout()
        let buttonsStack = self.initDaysButtonsLayout(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        let addButton = self.addButtonAppereance()
        
        containerNode.layoutSpecBlock = { node, constrainedSize in
            self.workDayBusesCollectionNode = self.initCollectionNode(width: constrainedSize.max.width, height: constrainedSize.max.height)
            self.workDayBusesCollectionNode.view.tag = 0
            self.saturdayBusesCollectionNode = self.initCollectionNode(width: constrainedSize.max.width, height: constrainedSize.max.height)
            self.saturdayBusesCollectionNode.view.tag = 1
            self.sundayBusesCollectionNode = self.initCollectionNode(width: constrainedSize.max.width, height: constrainedSize.max.height)
            self.sundayBusesCollectionNode.view.tag = 2
            
            let stack = ASStackLayoutSpec.vertical()
            stack.children = self.mainViewModel.favorites.isEmpty ? [buttonsStack, emptyScreenStack] : [buttonsStack, self.scrollNode]

            let addButtonStack = ASStackLayoutSpec.vertical()
            addButtonStack.verticalAlignment = .bottom
            addButtonStack.horizontalAlignment = .right
            addButtonStack.child = addButton
            
            let insetSpec = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20), child: addButtonStack)
            
            return ASBackgroundLayoutSpec(child: insetSpec, background: stack)
        }
    }
    
    private func scrollLayout() {
        self.scrollNode.layoutSpecBlock = { node, size in
            let stack = ASStackLayoutSpec.horizontal()
            stack.children = self.workDayBusesCollectionNode != nil ? [self.workDayBusesCollectionNode, self.saturdayBusesCollectionNode,  self.sundayBusesCollectionNode] : []
            return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), child: stack)
        }
     }
    
    private func initCollectionNode(width: CGFloat, height: CGFloat) -> ASCollectionNode {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = UIScreen.main.bounds.width * 0.03
        flowLayout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: UIScreen.main.bounds.height * 0.07 + 10, right: 0)
        
        let collectionNode = ASCollectionNode(collectionViewLayout: flowLayout)
        collectionNode.delegate = self
        collectionNode.dataSource = self
        collectionNode.style.preferredLayoutSize = ASLayoutSizeMake(ASDimensionMake(width), ASDimensionMake(height))
        collectionNode.backgroundColor = Theme.current.color(.backgroundColor)
        collectionNode.showsVerticalScrollIndicator = false
        return collectionNode
    }
    
    private func appearance() {
        self.scrollNode.view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: UIScreen.main.bounds.width * 3)
        
        self.separatorNode.backgroundColor = Theme.current.color(.dayIndicatorColor)
        
        self.messageLabelNode.attributedText = self.node.attributed(text: "Click the \"+\" button to add buses".localized(), color: Theme.current.color(.mainScreenTextColor), font: Fonts.muliRegular17)
        self.messageLabelNode.truncationMode = .byWordWrapping
        self.messageLabelNode.maximumNumberOfLines = 2
        self.messageLabelNode.style.preferredLayoutSize = ASLayoutSizeMake(ASDimensionMake(UIScreen.main.bounds.width * 0.7), ASDimensionAuto)
        
        if Theme.current.mode == .dark {
            self.logoImageNode.image = UIImage(named: "logo-white")
            self.logoImageNode.alpha = 0.75
        } else {
            self.logoImageNode.image = UIImage(named: "logo")
        }
        self.logoImageNode.contentMode = .scaleAspectFit
        self.logoImageNode.style.preferredLayoutSize = ASLayoutSizeMake(ASDimensionMake(UIScreen.main.bounds.width * 0.5), ASDimensionAuto)
        
        setupDayButtonAppearance(dayButton: workdayButton, title: "Work day".localized())
        setupDayButtonAppearance(dayButton: saturdayButton, title: "Saturday".localized())
        setupDayButtonAppearance(dayButton: sundayButton, title: "Sunday".localized())
    }
    
    private func setupDayButtonAppearance(dayButton: ASButtonNode, title: String) {
        dayButton.backgroundColor = Theme.current.color(.navigationBackgroundColor)
        dayButton.setAttributedTitle(self.node.attributed(text: title, color: Theme.current.color(.navigationTintColor), font: Fonts.muliRegular15), for: .normal)
        dayButton.addTarget(self, action: #selector(dayButtonTapped(sender:)), forControlEvents: .touchUpInside)
    }
    
    private func initDaysButtonsLayout(width: CGFloat, height: CGFloat) -> ASDisplayNode {
        let daysContainterNode = ASDisplayNode()
        daysContainterNode.automaticallyManagesSubnodes = true
        daysContainterNode.backgroundColor = Theme.current.color(.navigationBackgroundColor)
        self.workdayButton.style.preferredLayoutSize = ASLayoutSizeMake(ASDimensionMake(width / 3), ASDimensionMake(height * 0.07))
        self.saturdayButton.style.preferredLayoutSize = ASLayoutSizeMake(ASDimensionMake(width / 3), ASDimensionMake(height * 0.07))
        self.sundayButton.style.preferredLayoutSize = ASLayoutSizeMake(ASDimensionMake(width / 3), ASDimensionMake(height * 0.07))
        self.separatorNode.style.preferredLayoutSize = ASLayoutSizeMake(ASDimensionMake(width / 3), ASDimensionMake(3))
        
        daysContainterNode.layoutSpecBlock = { node, constrainedSize in
            let horizontalStack = ASStackLayoutSpec.horizontal()
            horizontalStack.children = [self.workdayButton, self.saturdayButton, self.sundayButton]
            
            let verticalStack = ASStackLayoutSpec.vertical()
            verticalStack.children = [horizontalStack, self.separatorNode]
            
            return verticalStack
        }
        return daysContainterNode
    }
    
    private func initEmptyScreenLayout() -> ASLayoutSpec {
        let stack = ASStackLayoutSpec.vertical()
        stack.spacing = UIScreen.main.bounds.height * 0.05
        stack.horizontalAlignment = .middle
        stack.children = [self.messageLabelNode, self.logoImageNode]
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0), child: stack)
    }
    
    private func addButtonAppereance() -> ASButtonNode {
        let button = ASButtonNode()
        button.style.preferredSize = CGSize(width: 60, height: 60)
        button.cornerRadius = 30
        button.layer.shadowOffset = CGSize(width: 6, height: 6)
        button.layer.shadowColor = Theme.current.color(.shadowColor).cgColor
        button.layer.shadowRadius = 24
        button.layer.shadowOpacity = 1
        button.layer.masksToBounds = false
        button.backgroundColor = Theme.current.color(.addButtonBackgroundColor)
        if Theme.current.mode == .dark {
            button.setImage(UIImage(named: "plus-white"), for: .normal)
            button.alpha = 0.75
        } else {
            button.setImage(UIImage(named: "plus"), for: .normal)
        }
        button.contentHorizontalAlignment = .middle
        button.contentVerticalAlignment = .center
        
        button.addTarget(self, action: #selector(addButtonTapped(sender:)), forControlEvents: .touchUpInside)
        
        return button
    }
}

//MARK: CollectionNode delegate & data source
extension MainViewController: ASCollectionDataSource, ASCollectionDelegate {
    func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
        return 1
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return mainViewModel.favorites.count
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeForItemAt indexPath: IndexPath) -> ASCellNode {
        let busId = mainViewModel.favorites[indexPath.row]
        let path = StorageKeys.bus + busId
        if StorageManager.fileExists(path, in: .caches) {
            let buses = StorageManager.retrieve(path, from: .caches, as: [Bus].self)
            if let bus = buses.first(where: { $0.day == self.mainViewModel.tagsDict[collectionNode.view.tag]} )  {
                return BusCellNode(bus: bus)
            }
            let bus = buses[0]
            let newBus = Bus(id: bus.id, number: bus.number, name: bus.name, lineA: nil, lineB: nil, line: "There is no schedule".localized(), day: self.mainViewModel.tagsDict[collectionNode.view.tag]!, scheduleA: nil, scheduleB: nil, schedule: nil, extras: "")
            return BusCellNode(bus: newBus)
        }
        return ASCellNode()
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionNode.nodeForItem(at: indexPath) as? BusCellNode {
            cell.isOpened = !cell.isOpened
        }
    }
}

//MARK: Observer
extension MainViewController: MainObserver {
    func refreshUI() {
        self.workDayBusesCollectionNode.reloadData()
        self.saturdayBusesCollectionNode.reloadData()
        self.sundayBusesCollectionNode.reloadData()
    }
    
    func refreshCell(busID: String) {
        if let wdIndex = self.mainViewModel.favorites.firstIndex(of: busID) {
            self.workDayBusesCollectionNode.reloadItems(at: [IndexPath(row: wdIndex, section: 0)])
        }
        if let satIndex = self.mainViewModel.favorites.firstIndex(of: busID) {
            self.saturdayBusesCollectionNode.reloadItems(at: [IndexPath(row: satIndex, section: 0)])
        }
        if let sunIndex = self.mainViewModel.favorites.firstIndex(of: busID) {
            self.sundayBusesCollectionNode.reloadItems(at: [IndexPath(row: sunIndex, section: 0)])
        }
    }
    
    func showError(message: String) {
        showAlert(title: "", message: message, duration: 2)
    }
}

//MARK: Scrolling between scrollView pages
extension MainViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView != self.scrollNode.view { return }
        self.separatorNode.position.x = scrollView.contentOffset.x/3 + (self.separatorNode.calculatedSize.width / 2)
    }
}
