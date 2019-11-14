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
    public var currentLines: [Line] = []
    private var busesCollectionNode: ASCollectionNode!
    public let bus: Bus
    private var mainViewModel = MainViewModel()
    
    init() {
        self.bus = Bus(id: "52", number: "52", name: "VETERNIK", lineA: "Polasci za  VETERNIK", lineB: "Polasci iz  VETERNIK", line: nil, day: "R", scheduleA: ["15":["15", "35"], "16":["15", "35LIR"], "17":["15", "35"], "18":["15SP", "35"], "19":["15", "35"], "20":["15LI", "35SP"]], scheduleB: ["15":["15", "35"], "16":["15IL", "35"], "17":["15", "35"], "18":["15", "35SP"], "19":["15", "35"], "20":["15", "35"]], schedule: nil, extras: "IL=IZ LIRA, LIR=ZA LIR, SP=SAOBRACA SAMO PETKOM")
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = UIScreen.main.bounds.width * 0.05
        flowLayout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        self.busesCollectionNode = ASCollectionNode(collectionViewLayout: flowLayout)
        
        self.containerNode = ASDisplayNode()
        super.init(node: containerNode)
        self.containerNode.automaticallyManagesSubnodes = true
        self.title = "Bus NS".localized()
        self.containerNode.backgroundColor = Theme.current.color(.backgroundColor)
        self.busesCollectionNode.delegate = self
        self.busesCollectionNode.dataSource = self
        mainViewModel.observer = self
        mainViewModel.getData()
        layout()
        appearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func dayButtonTapped(sender: ASButtonNode) {
        if sender == workdayButton {
            UIView.animate(withDuration: 0.3) {
                self.separatorNode.position.x = 0 + (UIScreen.main.bounds.width / 6)
            }
        } else if sender == saturdayButton {
            UIView.animate(withDuration: 0.3) {
                self.separatorNode.position.x = UIScreen.main.bounds.width / 3 + (UIScreen.main.bounds.width / 6)
            }
        } else if sender == sundayButton {
            UIView.animate(withDuration: 0.3) {
                self.separatorNode.position.x = UIScreen.main.bounds.width / 3 * 2 + (UIScreen.main.bounds.width / 6)
            }
        }
    }
    
    @objc private func addButtonTapped(sender: ASButtonNode) {
        guard let navigationController = self.navigationController else { return }
        navigationController.pushViewController(AddLinesViewController(), animated: true)
    }
}

//MARK: Layout
extension MainViewController {
    
    private func layout() {
        containerNode.layoutSpecBlock = { node, constrainedSize in
            let emptyScreenStack = self.initEmptyScreenLayout()
            let buttonsStack = self.initDaysButtonsLayout(width: constrainedSize.max.width, height: constrainedSize.max.height)
            
            self.messageLabelNode.style.preferredLayoutSize = ASLayoutSizeMake(ASDimensionMake(constrainedSize.max.width * 0.7), ASDimensionAuto)
            
            self.busesCollectionNode.style.preferredLayoutSize = ASLayoutSizeMake(ASDimensionMake(constrainedSize.max.width), ASDimensionMake(constrainedSize.max.height - buttonsStack.style.preferredSize.height - constrainedSize.max.height * 0.07))
            
            self.logoImageNode.style.preferredLayoutSize = ASLayoutSizeMake(ASDimensionMake(constrainedSize.max.width * 0.5), ASDimensionAuto)
            
            let stack = ASStackLayoutSpec.vertical()
            stack.children = !self.currentLines.isEmpty ? [buttonsStack, emptyScreenStack] : [buttonsStack, self.busesCollectionNode]
            
            let addButton = self.addButtonAppereance()
            let addButtonStack = ASStackLayoutSpec.vertical()
            addButtonStack.verticalAlignment = .bottom
            addButtonStack.horizontalAlignment = .right
            addButtonStack.child = addButton
            
            let insetSpec = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20), child: addButtonStack)
            
            return ASBackgroundLayoutSpec(child: insetSpec, background: stack)
        }
    }
    
    private func appearance() {
        self.separatorNode.backgroundColor = Theme.current.color(.dayIndicatorColor)
        self.messageLabelNode.attributedText = self.node.attributed(text: "Click the \"+\" button to add buses".localized(), color: Theme.current.color(.shadowColor), font: Fonts.muliRegular17)
        self.messageLabelNode.truncationMode = .byWordWrapping
        self.messageLabelNode.maximumNumberOfLines = 2
        
        self.logoImageNode.image = UIImage(named: "logo")
        self.logoImageNode.contentMode = .scaleAspectFit
        
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
        
        daysContainterNode.layoutSpecBlock = { node, constrainedSize in
            self.workdayButton.style.preferredLayoutSize = ASLayoutSizeMake(ASDimensionMake(width / 3), ASDimensionMake(height * 0.07))
            self.saturdayButton.style.preferredLayoutSize = ASLayoutSizeMake(ASDimensionMake(width / 3), ASDimensionMake(height * 0.07))
            self.sundayButton.style.preferredLayoutSize = ASLayoutSizeMake(ASDimensionMake(width / 3), ASDimensionMake(height * 0.07))
            
            let horizontalStack = ASStackLayoutSpec.horizontal()
            horizontalStack.children = [self.workdayButton, self.saturdayButton, self.sundayButton]
            
            self.separatorNode.style.preferredLayoutSize = ASLayoutSizeMake(ASDimensionMake(width / 3), ASDimensionMake(3))
            
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
        button.style.preferredSize = CGSize(width: 48, height: 48)
        button.cornerRadius = 24
        button.layer.shadowOffset = CGSize(width: 6, height: 6)
        button.layer.shadowColor = Theme.current.color(.shadowColor).cgColor
        button.layer.shadowRadius = 24
        button.layer.shadowOpacity = 1
        button.layer.masksToBounds = false
        button.backgroundColor = Theme.current.color(.addButtonBackgroundColor)
        button.setImage(UIImage(named: "plus"), for: .normal)
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
        return 3
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeForItemAt indexPath: IndexPath) -> ASCellNode {
        let cell = BusCellNode(bus: self.bus)
        cell.style.preferredLayoutSize = ASLayoutSizeMake(ASDimensionMake(UIScreen.main.bounds.width * 0.9), ASDimensionAuto)
        return cell
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionNode.nodeForItem(at: indexPath) as? BusCellNode {
            cell.isOpened = !cell.isOpened
        }
    }
}

extension MainViewController: MainObserver {
    func refreshUI() {

    }
    func showError(message: String) {
        self.showAlert(title: "", message: message, duration: 2)
    }
}
