//
//  ProjectWindowController.swift
//  Argon
//
//  Created by Vincent Coetzee on 16/09/2023.
//

import Cocoa

class ProjectWindowController: NSWindowController,Dependent
    {
    public var project: SourceProjectNode?
        {
        didSet
            {
            if self.project.isNotNil
                {
                self.sharedProjectHolder.value = self.project!
                }
            }
        }
        
    public let dependentKey = DependentSet.nextDependentKey
    public var sharedNodeHolder: ValueHolder!
    public var sharedProjectHolder: ValueHolder!
    
    @IBOutlet weak var splitViewController: NSSplitViewController!
    @IBOutlet weak var hierarchyViewController: ProjectHierarchyViewController!
    @IBOutlet weak var sourceViewController: ProjectSourceViewController!
    @IBOutlet weak var inspectorViewController: ProjectInspectorViewController!
    
    private let leftSidebarController = LeftSidebarButtonController()
    private let rightSidebarController = RightSidebarButtonController()
    private var pathControl: PathControl?
    private var pathControlWidthConstraint: NSLayoutConstraint!
    private var issueCountIconLabelView: IconLabelView!
    private var leftSidebarState = ToggleState.expanded
    private var rightSidebarState = ToggleState.expanded
    
    override func windowDidLoad()
        {
        super.windowDidLoad()
        self.initSharedValueHolders()
        self.initControllers()
        self.configureWindow()
        }
        
    private func initSharedValueHolders()
        {
        self.sharedNodeHolder = ValueHolder(value: nil)
        self.sharedProjectHolder = ValueHolder(value: nil)
        self.sharedNodeHolder.addDependent(self)
        self.sharedProjectHolder.addDependent(self)
        }
        
    private func initControllers()
        {
        self.splitViewController = self.window?.contentViewController as? NSSplitViewController
        self.hierarchyViewController = self.splitViewController?.splitViewItems.first?.viewController as? ProjectHierarchyViewController
        self.sourceViewController = self.splitViewController?.splitViewItems.second?.viewController as? ProjectSourceViewController
        self.inspectorViewController = self.splitViewController?.splitViewItems.last?.viewController as? ProjectInspectorViewController
        self.leftSidebarController.target = self
        self.window!.addTitlebarAccessoryViewController(self.leftSidebarController)
        self.rightSidebarController.target = self
        self.window!.addTitlebarAccessoryViewController(self.rightSidebarController)
        self.hierarchyViewController.sharedNodeHolder = self.sharedNodeHolder
        self.sourceViewController.sharedNodeHolder = self.sharedNodeHolder
        self.inspectorViewController.sharedNodeHolder = self.sharedNodeHolder
        self.hierarchyViewController.sharedProjectHolder = self.sharedProjectHolder
        self.sourceViewController.sharedProjectHolder = self.sharedProjectHolder
        self.inspectorViewController.sharedProjectHolder = self.sharedProjectHolder
        }
        
    private func configureWindow()
        {
        let toolbar = self.window!.toolbar!
        toolbar.delegate = self
        toolbar.insertItem(withItemIdentifier: NSToolbarItem.Identifier("issueControl"), at: 0)
        toolbar.insertItem(withItemIdentifier: NSToolbarItem.Identifier("pathControl"), at: 0)
        NotificationCenter.default.addObserver(self, selector: #selector(self.windowFrameDidChange), name: NSWindow.didResizeNotification, object: window)
        self.window!.titleVisibility = .hidden
//        if !self.stateWasRestored
//            {
//            let frame = window.frame
//            let leftWidth = frame.size.width / 4.0
//            let centerWidth = leftWidth * 2.0
//            self.splitView.setPosition(leftWidth, ofDividerAt: 0)
//            self.splitView.setPosition(centerWidth + leftWidth,ofDividerAt: 1)
//            }
        }
        
    public func update(aspect: String,with: Any?,from: Model)
        {
        if from.dependentKey == self.sharedNodeHolder.dependentKey
            {
            guard let node = self.sharedNodeHolder.value as? SourceNode else
                {
                return
                }
            self.updatePathControl(from: node)
            return
            }
        }
        
    @objc public func windowFrameDidChange(_ notification: Notification)
        {
        let toolbar = self.window!.toolbar!
        var toolbarWidth = CGFloat(0)
        for item in toolbar.items
            {
            if item.itemIdentifier == NSToolbarItem.Identifier("issueControl")
                {
                toolbarWidth += item.view!.frame.size.width + CGFloat(8)
                }
            else if item.itemIdentifier != NSToolbarItem.Identifier("pathControl")
                {
                toolbarWidth += CGFloat(20 + 8)
                }
            }
        self.resizePathControl()
        }
        
    private func resizePathControl()
        {
        if let control = self.pathControl
            {
            control.removeConstraint(self.pathControlWidthConstraint)
            let widthConstraint = NSLayoutConstraint(item: control, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: self.pathControlWidth)
            control.addConstraint(widthConstraint)
            self.pathControlWidthConstraint = widthConstraint
            widthConstraint.isActive = true
            }
        }
        
    private var pathControlWidth: CGFloat
        {
        let toolbar = self.window!.toolbar!
        var toolbarWidth = CGFloat(0)
        for item in toolbar.items
            {
            if item.itemIdentifier == NSToolbarItem.Identifier("issueControl")
                {
                toolbarWidth += item.view!.frame.size.width + CGFloat(20)
                }
            else if item.itemIdentifier != NSToolbarItem.Identifier("pathControl")
                {
                toolbarWidth += CGFloat(36 + 14)
                }
            }
        let frame = self.window!.frame
        let width = frame.size.width - toolbarWidth
        return(width)
        }
        
    private func updatePathControl(from node: SourceNode?)
        {
        guard node.isNotNil else
            {
            self.pathControl?.pathItems = []
            return
            }
        var items = Array<NSPathControlItem>()
        for anItem in node!.pathToProject.reversed()
            {
            let pathControlItem = NSPathControlItem()
            pathControlItem.attributedTitle = NSAttributedString(string: anItem.name,attributes: [.font: StyleTheme.shared.font(for: .fontDefault),.foregroundColor: StyleTheme.shared.color(for: .colorDefault)])
            pathControlItem.image = anItem.projectViewImage.image(withTintColor: StyleTheme.shared.color(for: .colorDefault))
            items.append(pathControlItem)
            }
        self.pathControl?.pathItems = items
        }
 
    public func toolbar(_ toolbar: NSToolbar,itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier,willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem?
        {
        if itemIdentifier == NSToolbarItem.Identifier("pathControl")
            {
            let toolbarItem = NSToolbarItem(itemIdentifier: NSToolbarItem.Identifier(rawValue: "pathControl"))
            toolbarItem.label = ""
            toolbarItem.paletteLabel = ""
            toolbarItem.target = self
            let view = PathControl()
            toolbarItem.view = view
            view.wantsLayer = true
            view.layer!.cornerRadius = StyleTheme.shared.metric(for: .metricControlCornerRadius)
            view.layer!.backgroundColor = StyleTheme.shared.color(for: .colorToolbarBackground).cgColor
            self.pathControl = view
            toolbarItem.view?.translatesAutoresizingMaskIntoConstraints = false
            let heightConstraint = NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20)
            view.addConstraint(heightConstraint)
            heightConstraint.isActive = true
            let widthConstraint = NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: self.pathControlWidth)
            view.addConstraint(widthConstraint)
            self.pathControlWidthConstraint = widthConstraint
            widthConstraint.isActive = true
//            self.updatePathControl(from: self.project)
            toolbarItem.isNavigational = true
            return(toolbarItem)
            }
        else if itemIdentifier == NSToolbarItem.Identifier("issueControl")
            {
            let toolbarItem = NSToolbarItem(itemIdentifier: NSToolbarItem.Identifier(rawValue: "issueControl"))
            toolbarItem.label = ""
            toolbarItem.paletteLabel = ""
            toolbarItem.target = self
            let view = IconLabelView(image: NSImage(systemSymbolName: "exclamationmark.triangle", accessibilityDescription: "")!, imageEdge: .left, text: "0 issues",padding: NSSize(width:2,height: 2))
            self.issueCountIconLabelView = view
            view.imageTintElement = .colorIssue
            view.textColorElement = .colorToolbarText
            toolbarItem.view = view
            toolbarItem.view?.translatesAutoresizingMaskIntoConstraints = false
            let heightConstraint = NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20)
            view.addConstraint(heightConstraint)
            heightConstraint.isActive = true
            let widthConstraint = NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 60)
            view.addConstraint(widthConstraint)
            self.pathControlWidthConstraint = widthConstraint
            widthConstraint.isActive = true
            return(toolbarItem)
            }
        return(nil)
        }
        
    @objc public func onToggleLeftSidebar(_ sender: Any?)
        {
//        NSAnimationContext.runAnimationGroup
//            {
//            context in
//            context.allowsImplicitAnimation = true
//            context.duration = 0.75
//            if self.leftSidebarState.isExpanded
//                {
//                let amount = self.hierarchyViewController.view.bounds.width
//                self.leftSidebarState = self.leftSidebarState.toggledState(amount)
//                self.splitView.setPosition(0, ofDividerAt: 0)
//                }
//            else
//                {
//                self.splitView.setPosition(self.leftSidebarState.amount,ofDividerAt: 0)
//                self.leftSidebarState = self.leftSidebarState.toggledState()
//                }
//            }
        }
        
    @objc public func onToggleRightSidebar(_ sender: Any?)
        {
//        NSAnimationContext.runAnimationGroup
//            {
//            context in
//            context.allowsImplicitAnimation = true
//            context.duration = 0.75
//            if self.rightSidebarState.isExpanded
//                {
//                let amount = self.rightView.bounds.width
//                self.rightSidebarState = self.rightSidebarState.toggledState(amount)
//                let offset = self.splitView.bounds.size.width
//                self.splitView.setPosition(offset, ofDividerAt: 1)
//                }
//            else
//                {
//                let offset = self.splitView.bounds.size.width - self.rightSidebarState.amount
//                self.splitView.setPosition(offset,ofDividerAt: 1)
//                self.rightSidebarState = self.rightSidebarState.toggledState()
//                }
//            }
        }
    }


extension ProjectWindowController: NSToolbarDelegate
    {
    }
