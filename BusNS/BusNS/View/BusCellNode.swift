//
//  BusCellNode.swift
//  BusNS
//
//  Created by Ena Vorkapic on 11/13/19.
//  Copyright © 2019 Crystal Pigeon. All rights reserved.
//

import AsyncDisplayKit

final class BusCellNode: ASCellNode {
    
    private var bus: Bus
    private var titleStack = ASLayoutSpec()
    private var directionsStack = ASLayoutSpec()
    private var cellWidth = UIScreen.main.bounds.width * 0.9
    private var separatorFullWidth = (UIScreen.main.bounds.width * 0.9) - 20
    private var separatorHalfWidth = ((UIScreen.main.bounds.width * 0.9) - 20) / 2 - 10
    public var isOpened = false {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    public init(bus: Bus) {
        self.bus = bus
        super.init()
        self.automaticallyManagesSubnodes = true
        self.createTitleStack()
        self.createDirectionsStack()
    }
    
    override func didLoad() {
        self.layer.shadowColor = Theme.current.color(.shadowColor).cgColor
        self.layer.shadowOffset = CGSize(width: 6, height: 6)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 5
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = false
        self.selectionStyle = .none
        self.backgroundColor = Theme.current.color(.busCell_backgroundColor)
    }
    
    //MARK: Layout
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let mainStack = ASStackLayoutSpec.vertical()
        mainStack.children = [titleStack, directionsStack, createSchedulesStack(),createCommentsStack()]
        mainStack.spacing = 10
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10), child: mainStack)
    }
    
    //MARK: Create stacks
    private func createTitleStack() {
        let titleText = ASTextNode()
        titleText.attributedText = self.attributed(text: bus.name, color: Theme.current.color(.busCell_lineTextColor), font: Fonts.muliRegular15, alignment: .left)
        titleText.style.preferredLayoutSize = ASLayoutSizeMake(ASDimensionMake(UIScreen.main.bounds.width * 0.7), ASDimensionAuto)
        titleText.pointSizeScaleFactors = [0.9,0.85,0.8,0.75,0.7,0.65,0.6,0.5]
        
        let titleStack = ASStackLayoutSpec.horizontal()
        titleStack.children = [createNumberCircleNode(),titleText]
        titleStack.verticalAlignment = .center
        titleStack.spacing = 10
        self.titleStack = titleStack
    }
    
    private func createDirectionsStack() {
        if let line = bus.line {
            self.directionsStack = createDirection(line, separatorWidth: separatorFullWidth)
        } else if let lineA = bus.lineA, let lineB = bus.lineB {
            let directionsStack = ASStackLayoutSpec.horizontal()
            directionsStack.children = [createDirection(lineA, separatorWidth: separatorHalfWidth),createDirection(lineB, separatorWidth: separatorHalfWidth)]
            directionsStack.spacing = 20
            directionsStack.horizontalAlignment = .left
            self.directionsStack = directionsStack
        }
    }
    
    private func createDirection(_ text: String, separatorWidth: CGFloat) -> ASLayoutSpec {
        let stack = ASStackLayoutSpec.vertical()
        
        let directionTextNode = ASTextNode()
        directionTextNode.attributedText = self.attributed(text: text, color: Theme.current.color(.busCell_lineTextColor), font: Fonts.muliRegular12, alignment: .left)
        directionTextNode.style.preferredLayoutSize = ASLayoutSizeMake(ASDimensionMake(separatorWidth), ASDimensionAuto)
        directionTextNode.pointSizeScaleFactors = [0.9,0.85,0.8,0.75,0.7,0.65,0.6,0.5]
        
        let separatorNode = ASDisplayNode()
        separatorNode.backgroundColor = Theme.current.color(.busCell_separatorColor)
        separatorNode.style.preferredSize = CGSize(width: UIScreen.main.bounds.width * 0.15, height: 1)
        
        stack.children = [directionTextNode,separatorNode]
        stack.spacing = 2
        stack.horizontalAlignment = .left
        return stack
    }
    
    private func createSchedulesStack() -> ASLayoutSpec {
        if bus.schedule != nil {
            if !self.isOpened {
                return createSchedule(bus.getOneWayScheduleBy3Hours(), width: separatorFullWidth)
            } else {
                return createSchedule(bus.getOneWayScheduleByHour(), width: separatorFullWidth)
            }
        } else if bus.scheduleA != nil,  bus.scheduleB != nil {
            let schedulesStack = ASStackLayoutSpec.horizontal()
            if !self.isOpened {
                let schA = bus.getScheduleABy3Hours()
                let schB = bus.getScheduleBBy3Hours()
                schedulesStack.children = [
                    createSchedule(schA, width: separatorHalfWidth),
                    createSchedule(schB, width: separatorHalfWidth)
                ]
            } else {
                let schA = bus.getScheduleAByHour()
                let schB = bus.getScheduleBByHour()
                schedulesStack.children = [
                    createSchedule(schA, width: separatorHalfWidth),
                    createSchedule(schB, width: separatorHalfWidth)
                ]
            }
            schedulesStack.spacing = 20
            return schedulesStack
        }
        return ASStackLayoutSpec.vertical()
    }
    
    private func createSchedule(_ text: [String], width: CGFloat) -> ASLayoutSpec {
        let scheduleStack = ASStackLayoutSpec.vertical()
        var textNodes = [ASTextNode]()
        for hour in text {
            let textNode = ASTextNode()
            if DateManager.instance.getHour() == hour.split(separator: ":")[0] {
                let mut = NSMutableAttributedString()
                mut.append(self.attributed(text: String(hour.split(separator: ":")[0] + ":"), color: Theme.current.color(.busCell_currentHourColor), font: Fonts.muliSemiBold12, alignment: .left))
                mut.append(self.attributed(text: String(hour.split(separator: ":")[1]), color: Theme.current.color(.busCell_scheduleTextColor), font: Fonts.muliRegular12, alignment: .left))
                textNode.attributedText = mut
            } else {
                let mut = NSMutableAttributedString()
                mut.append(self.attributed(text: String(hour.split(separator: ":")[0] + ":"), color: Theme.current.color(.busCell_scheduleTextColor), font: Fonts.muliSemiBold12, alignment: .left))
                mut.append(self.attributed(text: String(hour.split(separator: ":")[1]), color:Theme.current.color(.busCell_scheduleTextColor), font: Fonts.muliRegular12, alignment: .left))
                textNode.attributedText = mut
            }
            textNodes.append(textNode)
        }
        scheduleStack.children = textNodes
        scheduleStack.spacing = 5
        scheduleStack.horizontalAlignment = .left
        scheduleStack.style.preferredLayoutSize = ASLayoutSizeMake(ASDimensionMake(width), ASDimensionAuto)
        return scheduleStack
    }
    
    private func createCommentsStack() -> ASLayoutSpec {
        let commentsStack = ASStackLayoutSpec.vertical()
        let comment = ASTextNode()
        comment.attributedText = self.attributed(text: bus.extras, color: Theme.current.color(.busCell_extrasColor), font: Fonts.muliRegular10, alignment: .left)
        comment.style.preferredLayoutSize = ASLayoutSizeMake(ASDimensionMake(self.separatorFullWidth), ASDimensionAuto)
        commentsStack.child = comment
        return commentsStack
    }
    
    //MARK: Create elements
    private func createNumberCircleNode() -> ASDisplayNode {
        let circleNode = ASDisplayNode()
        circleNode.backgroundColor = Theme.current.color(.busCell_numberBackgroundColor)
        circleNode.automaticallyManagesSubnodes = true
        circleNode.style.preferredSize = CGSize(width: 26, height: 26)
        circleNode.cornerRadius = 13
        
        let numberTextNode = ASTextNode()
        numberTextNode.attributedText = self.attributed(text: bus.number, color: Theme.current.color(.busCell_numberTextColor), font: Fonts.muliRegular10)
        
        circleNode.layoutSpecBlock = { node, constrainedSize in
            let stack = ASStackLayoutSpec.vertical()
            stack.child = numberTextNode
            stack.verticalAlignment = .center
            stack.horizontalAlignment = .middle
            return stack
        }
        return circleNode
    }
}
