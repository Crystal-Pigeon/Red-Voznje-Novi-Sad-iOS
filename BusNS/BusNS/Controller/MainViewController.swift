//
//  MainViewController.swift
//  BusNS
//
//  Created by Ena Vorkapic on 11/12/19.
//  Copyright © 2019 Crystal Pigeon. All rights reserved.
//

import AsyncDisplayKit

class MainViewController: ASDKViewController<ASDisplayNode> {
    
    //MARK: UI Properties
    private let containerNode: ASDisplayNode
    private let workdayButton = ASButtonNode()
    private let saturdayButton = ASButtonNode()
    private let sundayButton = ASButtonNode()
    private let addButton = ASButtonNode()
    private let separatorNode = ASDisplayNode()
    private let messageLabelNode = ASTextNode()
    private let logoImageNode = ASImageNode()
    private var workDayBusesCollectionNode: ASCollectionNode!
    private var saturdayBusesCollectionNode: ASCollectionNode!
    private var sundayBusesCollectionNode: ASCollectionNode!
    private let scrollNode = ASScrollNode()
    private var mainViewModel = MainViewModel()
    
    override init() {
        self.containerNode = ASDisplayNode()
        super.init(node: containerNode)
        self.title = "Red Vožnje".localized()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.mainViewModel.observer = self
        self.mainViewModel.getData()
        self.containerNode.automaticallyManagesSubnodes = true
        self.scrollNode.automaticallyManagesSubnodes = true
        self.workDayBusesCollectionNode = self.initCollectionNode()
        self.saturdayBusesCollectionNode = self.initCollectionNode()
        self.sundayBusesCollectionNode = self.initCollectionNode()
        self.layout()
        self.scrollLayout()
        self.appearance()
        self.setupNavigationBarButtons()
        self.setupLongPressGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.colorAppearance()
        if self.mainViewModel.shouldSetNeedsLayout() {
            self.containerNode.setNeedsLayout()
            self.scrollNode.setNeedsLayout()
        }
        self.setupCurrentDay()
        self.refreshUI()
    }
    
    override func updateColor() {
        self.colorAppearance()
        self.refreshUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.mainViewModel.resetLastCount()
    }
    
    private func setupLongPressGesture() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPress.minimumPressDuration = 0.4
        self.view.addGestureRecognizer(longPress)
    }
    
    private func setupNavigationBarButtons() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "settings_icon"), landscapeImagePhone: UIImage(named: "settings_icon"), style: .plain, target: self, action: #selector(settingsButtonTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "rearrange_icon"), landscapeImagePhone: UIImage(named: "rearrange_icon"), style: .plain, target: self, action: #selector(rearrangeButtonTapped))
    }
    
    func setupCurrentDay() {
        if DateManager.instance.getDayOfWeek() == "N" {
            self.scrollNode.view.setContentOffset(CGPoint(x: UIScreen.main.bounds.width / 3 * 6, y: 0), animated: false)
        } else if DateManager.instance.getDayOfWeek() == "S" {
            self.scrollNode.view.setContentOffset(CGPoint(x: UIScreen.main.bounds.width / 3 * 3, y: 0), animated: false)
        } else {
            self.scrollNode.view.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        }
        self.scrollViewDidScroll(self.scrollNode.view)
    }
}

//MARK: Button Actions
extension MainViewController {
    @objc private func dayButtonTapped(sender: ASButtonNode) {
        if sender == workdayButton {
                self.scrollNode.view.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        } else if sender == saturdayButton {
                self.scrollNode.view.setContentOffset(CGPoint(x: UIScreen.main.bounds.width / 3 * 3, y: 0), animated: true)
        } else if sender == sundayButton {
                self.scrollNode.view.setContentOffset(CGPoint(x: UIScreen.main.bounds.width / 3 * 6, y: 0), animated: true)
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
            if let popoverController = actionSheet.popoverPresentationController {
                popoverController.sourceView = self.view //to set the source of your alert
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0) // you can set this as per your requirement.
                popoverController.permittedArrowDirections = [] //to hide the arrow of any particular direction
            }
            if #available(iOS 13.0, *), Theme.current.mode != .auto {
                actionSheet.view.overrideUserInterfaceStyle = Theme.current.mode == .dark ? .dark : .light
            }
            present(actionSheet, animated: true, completion: nil)
        }
    }
}

//MARK: Init UI Elements
extension MainViewController {
    private func initCollectionNode() -> ASCollectionNode {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = UIScreen.main.bounds.width * 0.03
        flowLayout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: UIScreen.main.bounds.height * 0.07 + 10, right: 0)
        
        let collectionNode = ASCollectionNode(collectionViewLayout: flowLayout)
        collectionNode.delegate = self
        collectionNode.dataSource = self
        collectionNode.showsVerticalScrollIndicator = false
        return collectionNode
    }
    
    private func initDaysButtonsLayout(width: CGFloat, height: CGFloat) -> ASLayoutSpec {
        self.workdayButton.style.preferredLayoutSize = ASLayoutSizeMake(ASDimensionMake(width / 3), ASDimensionMake(height * 0.07))
        self.saturdayButton.style.preferredLayoutSize = ASLayoutSizeMake(ASDimensionMake(width / 3), ASDimensionMake(height * 0.07))
        self.sundayButton.style.preferredLayoutSize = ASLayoutSizeMake(ASDimensionMake(width / 3), ASDimensionMake(height * 0.07))
        self.separatorNode.style.preferredLayoutSize = ASLayoutSizeMake(ASDimensionMake(width / 3), ASDimensionMake(3))
        
        let horizontalStack = ASStackLayoutSpec.horizontal()
        horizontalStack.children = [self.workdayButton, self.saturdayButton, self.sundayButton]
        
        let verticalStack = ASStackLayoutSpec.vertical()
        verticalStack.child = self.separatorNode
        verticalStack.verticalAlignment = .bottom
        
        let overlay = ASOverlayLayoutSpec(child: horizontalStack, overlay: verticalStack)
        
        return overlay
    }
    
    private func initEmptyScreenLayout() -> ASLayoutSpec {
        let stack = ASStackLayoutSpec.vertical()
        stack.spacing = UIScreen.main.bounds.height * 0.05
        stack.horizontalAlignment = .middle
        stack.children = [self.messageLabelNode, self.logoImageNode]
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0), child: stack)
    }
}

//MARK: Layout
extension MainViewController {
    private func layout() {
        let emptyScreenStack = self.initEmptyScreenLayout()
        let buttonsStack = self.initDaysButtonsLayout(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        containerNode.layoutSpecBlock = { node, constrainedSize in
            self.workDayBusesCollectionNode.style.preferredLayoutSize = ASLayoutSizeMake(ASDimensionMake(constrainedSize.max.width), ASDimensionMake(constrainedSize.max.height))
            self.saturdayBusesCollectionNode.style.preferredLayoutSize = ASLayoutSizeMake(ASDimensionMake(constrainedSize.max.width), ASDimensionMake(constrainedSize.max.height))
            self.sundayBusesCollectionNode.style.preferredLayoutSize = ASLayoutSizeMake(ASDimensionMake(constrainedSize.max.width), ASDimensionMake(constrainedSize.max.height))
            
            let stack = ASStackLayoutSpec.vertical()
            stack.children = self.mainViewModel.favorites.isEmpty ? [buttonsStack, emptyScreenStack, self.scrollNode] : [buttonsStack, self.scrollNode]
            self.scrollNode.isHidden = self.mainViewModel.favorites.isEmpty

            let addButtonStack = ASStackLayoutSpec.vertical()
            addButtonStack.verticalAlignment = .bottom
            addButtonStack.horizontalAlignment = .right
            addButtonStack.child = self.addButton
            
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
    
    private func colorAppearance() {
        self.containerNode.backgroundColor = Theme.current.color(.backgroundColor)
        self.scrollNode.backgroundColor = Theme.current.color(.backgroundColor)
        self.workDayBusesCollectionNode.backgroundColor = Theme.current.color(.backgroundColor)
        self.saturdayBusesCollectionNode.backgroundColor = Theme.current.color(.backgroundColor)
        self.sundayBusesCollectionNode.backgroundColor = Theme.current.color(.backgroundColor)
        self.separatorNode.backgroundColor = Theme.current.color(.dayIndicatorColor)
        self.messageLabelNode.attributedText = self.node.attributed(text: "Click the \"+\" button to add buses".localized(), color: Theme.current.color(.mainScreenTextColor), font: Fonts.muliRegular17)
        self.dayButtonAppearance(dayButton: workdayButton, title: "Work day".localized())
        self.dayButtonAppearance(dayButton: saturdayButton, title: "Saturday".localized())
        self.dayButtonAppearance(dayButton: sundayButton, title: "Sunday".localized())
        
        self.addButton.backgroundColor = Theme.current.color(.addButtonBackgroundColor)
        self.addButton.layer.shadowColor = Theme.current.color(.shadowColor).cgColor
        
        if Theme.current.mode == .dark {
            self.logoImageNode.image = UIImage(named: "logo-white")
            self.logoImageNode.alpha = 0.75
            self.addButton.setImage(UIImage(named: "plus-white"), for: .normal)
            self.addButton.alpha = 0.75
        } else {
            self.logoImageNode.image = UIImage(named: "logo")
            self.addButton.setImage(UIImage(named: "plus"), for: .normal)
        }
    }
    
    private func appearance() {
        self.workDayBusesCollectionNode.view.tag = 0
        self.saturdayBusesCollectionNode.view.tag = 1
        self.sundayBusesCollectionNode.view.tag = 2
        
        self.addButtonAppereance()
        
        self.scrollNode.view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: UIScreen.main.bounds.width * 3)
        self.scrollNode.view.isPagingEnabled = true
        self.scrollNode.view.showsHorizontalScrollIndicator = false
        self.scrollNode.view.delegate = self
       
        self.messageLabelNode.truncationMode = .byWordWrapping
        self.messageLabelNode.maximumNumberOfLines = 2
        self.messageLabelNode.style.preferredLayoutSize = ASLayoutSizeMake(ASDimensionMake(UIScreen.main.bounds.width * 0.7), ASDimensionAuto)
        
        self.logoImageNode.contentMode = .scaleAspectFit
        self.logoImageNode.style.preferredLayoutSize = ASLayoutSizeMake(ASDimensionMake(UIScreen.main.bounds.width * 0.5), ASDimensionAuto)
    }
    
    private func addButtonAppereance() {
        self.addButton.style.preferredSize = CGSize(width: 60, height: 60)
        self.addButton.cornerRadius = 30
        self.addButton.layer.shadowOffset = CGSize(width: 6, height: 6)
        self.addButton.layer.shadowRadius = 24
        self.addButton.layer.shadowOpacity = 1
        self.addButton.layer.masksToBounds = false
        self.addButton.contentHorizontalAlignment = .middle
        self.addButton.contentVerticalAlignment = .center
        self.addButton.addTarget(self, action: #selector(addButtonTapped(sender:)), forControlEvents: .touchUpInside)
    }
    
    private func dayButtonAppearance(dayButton: ASButtonNode, title: String) {
        dayButton.backgroundColor = Theme.current.color(.navigationBackgroundColor)
        dayButton.setAttributedTitle(self.node.attributed(text: title, color: Theme.current.color(.navigationTintColor), font: Fonts.muliRegular15), for: .normal)
        dayButton.addTarget(self, action: #selector(dayButtonTapped(sender:)), forControlEvents: .touchUpInside)
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
        return EmptyBusCellNode()
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
        showInternetAlert(title: message, message: "") { (_) -> (Void) in
            self.mainViewModel.getData()
        }
    }
}

//MARK: Scrolling between scrollView pages
extension MainViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView != self.scrollNode.view { return }
        self.separatorNode.position.x = scrollView.contentOffset.x/3 + (self.separatorNode.calculatedSize.width / 2)
    }
}
