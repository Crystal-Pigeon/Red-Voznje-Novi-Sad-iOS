//
//  BusCell.swift
//  BusNS
//
//  Created by Marko Popić on 10/28/21.
//  Copyright © 2021 Crystal Pigeon. All rights reserved.
//

import AsyncDisplayKit
import UIKit

class BusCell: ASCellNode {
    
    //MARK: - UI elements
    private let numberNode = ASTextNode()
    private let nameNode = ASTextNode()
    private let lineANode = ASTextNode()
    private let lineBNode = ASTextNode()
    private let scheduleANode = ASTextNode()
    private let scheduleBNode = ASTextNode()
    private let extrasNode = ASTextNode()
    private let dividerA = ASDisplayNode()
    private let dividerB = ASDisplayNode()
    
    //MARK: - Sizes
    let numberSize: CGFloat = 28
    
    //MARK: - Properties
    let bus: Bus
    var isOpened = false {
        didSet {
            self.schedules()
            self.setNeedsLayout()
        }
    }
    
    //MARK: - Init
    init(bus: Bus) {
        self.bus = bus
        super.init()
        self.automaticallyManagesSubnodes = true
    }
    
    override func didLoad() {
        super.didLoad()
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 4, height: 4)
        self.layer.shadowOpacity = 0.25
        self.layer.shadowRadius = 5
        self.layer.cornerRadius = 5
        self.selectionStyle = .none
        self.backgroundColor = .cardBackground
        self.setupUI()
    }
    
    
    //MARK: - Setup
    private func setupUI() {
        self.numberNode.attributedText = NSAttributedString(bus.number, color: .white, font: .muliRegular12, alignment: .center)
        self.numberNode.textContainerInset = UIEdgeInsets(top: 6, left: 2, bottom: 2, right: 2)
        self.numberNode.layer.cornerRadius = self.numberSize / 2
        self.numberNode.layer.masksToBounds = true
        self.numberNode.backgroundColor = .primary
        
        self.nameNode.attributedText = NSAttributedString(bus.name, color: .primaryText, font: .muliSemiBold15)
        self.nameNode.style.flexGrow = 10
        self.nameNode.style.flexShrink = 10
        
        self.lineANode.attributedText = NSAttributedString(bus.lineA ?? bus.line ?? "", color: .primaryText, font: .muliRegular12)
        self.lineANode.style.flexGrow = 10
        self.lineANode.style.flexShrink = 10
        
        self.lineBNode.attributedText = NSAttributedString(bus.lineB ?? "", color: .primaryText, font: .muliRegular12)
        self.lineBNode.style.flexGrow = 10
        self.lineBNode.style.flexShrink = 10
        
        self.extrasNode.attributedText = NSAttributedString(bus.formatedExtras(), color: .secondaryText, font: .muliRegular12)
        self.extrasNode.style.flexGrow = 10
        self.extrasNode.style.flexShrink = 10
        
        self.dividerA.backgroundColor = .secondaryText
        self.dividerB.backgroundColor = .secondaryText
        
        self.schedules()
    }
    
    private func schedules() {
        if bus.isOneWay {
            self.setupSchedule(textNode: self.scheduleANode, timetable: self.isOpened ? self.bus.getOneWayScheduleByHour() : self.bus.getOneWayScheduleBy3Hours())
        } else {
            self.setupSchedule(textNode: self.scheduleANode, timetable: self.isOpened ? self.bus.getScheduleAByHour() : self.bus.getScheduleABy3Hours())
        }
        self.setupSchedule(textNode: self.scheduleBNode, timetable: self.isOpened ? self.bus.getScheduleBByHour() : self.bus.getScheduleBBy3Hours())
    }
    
    private func setupSchedule(textNode: ASTextNode, timetable: [String]) {
        let schedule = NSMutableAttributedString()
        for time in timetable {
            let hour = time.components(separatedBy: ":")[0]
            let times = time.components(separatedBy: ":")[1]
            schedule.append(NSAttributedString(hour, color: Date.currentHour == hour ? .secondary : .primaryText, font: .muliSemiBold12)
                            + NSAttributedString(" :\(times)\n", color: .primaryText, font: .muliRegular12))
        }
        textNode.attributedText = schedule
        textNode.style.flexGrow = 10
        textNode.style.flexShrink = 10
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        self.numberNode.style.width = ASDimensionMake(self.numberSize)
        self.numberNode.style.height = ASDimensionMake(self.numberSize)
        self.dividerA.style.height = ASDimensionMake(1)
        self.dividerA.style.width = ASDimensionMake(80)
        self.dividerB.style.height = ASDimensionMake(1)
        self.dividerB.style.width = ASDimensionMake(80)
        
        let titleStack = ASStackLayoutSpec.horizontal()
        titleStack.children = [self.numberNode, self.nameNode]
        titleStack.spacing = 7
        titleStack.alignItems = .center
        titleStack.style.flexGrow = 10
        
        let sideAStack = ASStackLayoutSpec.vertical()
        sideAStack.children = [self.lineANode, self.dividerA, self.scheduleANode]
        sideAStack.spacing = 7
        sideAStack.style.flexGrow = 10
        sideAStack.style.flexShrink = 10
        
        let sideBStack = ASStackLayoutSpec.vertical()
        sideBStack.children = [self.lineBNode, self.dividerB, self.scheduleBNode]
        sideBStack.spacing = 7
        sideBStack.style.flexGrow = 10
        sideBStack.style.flexShrink = 10
        
        let timetableStack = ASStackLayoutSpec.horizontal()
        timetableStack.children = self.bus.isOneWay ? [sideAStack] : [sideAStack, sideBStack]
        timetableStack.spacing = 7
        timetableStack.alignItems = .start
        timetableStack.style.flexGrow = 10
        
        let stack = ASStackLayoutSpec.vertical()
        stack.children = self.isOpened ? [titleStack, timetableStack, self.extrasNode] : [titleStack, timetableStack]
        stack.spacing = 7
        stack.style.width = ASDimensionMake("90%")
        
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8), child: stack)
    }
}
