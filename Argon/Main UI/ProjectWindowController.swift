//
//  ProjectWindowController.swift
//  Argon
//
//  Created by Vincent Coetzee on 16/09/2023.
//

import Cocoa

internal class ProjectWindowController: NSWindowController,Dependent
    {
    public let dependentKey = DependentSet.nextDependentKey
    
    private var projectModel: ValueHolder!
    private var selectedNodeModel: ValueHolder!
    
    @IBOutlet weak var splitViewController: NSSplitViewController!
    @IBOutlet weak var hierarchyViewController: ProjectHierarchyViewController!
    @IBOutlet weak var sourceViewController: ProjectSourceViewController!
    @IBOutlet weak var inspectorViewController: ProjectInspectorViewController!
    
    private let leftSidebarController = LeftSidebarButtonController()
    private var pathControl: PathControl?
    private var pathControlWidthConstraint: NSLayoutConstraint!
    private var issueCountIconLabelView: IconLabelView!
    private var leftSidebarState = ToggleState.expanded
    private var rightSidebarState = ToggleState.expanded
    
    public func initWindowController(projectModel: ValueHolder,selectedNodeModel: ValueHolder)
        {
        self.projectModel = projectModel
        self.selectedNodeModel = selectedNodeModel
        projectModel.addDependent(self)
        selectedNodeModel.addDependent(self)
        self.initControllers()
        self.configureWindow()
        }
        
    override func windowDidLoad()
        {
        super.windowDidLoad()
        }
        
    private func initControllers()
        {
        self.splitViewController = self.window?.contentViewController as? NSSplitViewController
        self.hierarchyViewController = self.splitViewController?.splitViewItems.first?.viewController as? ProjectHierarchyViewController
        self.sourceViewController = self.splitViewController?.splitViewItems.second?.viewController as? ProjectSourceViewController
        self.inspectorViewController = self.splitViewController?.splitViewItems.last?.viewController as? ProjectInspectorViewController
        self.leftSidebarController.target = self
        self.window!.addTitlebarAccessoryViewController(self.leftSidebarController)
        self.issueCountIconLabelView = self.leftSidebarController.issueCountIconLabelView
        self.leftSidebarController.selectedNodeModel = self.selectedNodeModel
        self.hierarchyViewController.selectedNodeModel = self.selectedNodeModel
        self.sourceViewController.selectedNodeModel = self.selectedNodeModel
        self.inspectorViewController.selectedNodeModel = self.selectedNodeModel
        self.hierarchyViewController.projectModel = self.projectModel
        self.sourceViewController.projectModel = self.projectModel
        self.inspectorViewController.projectModel = self.projectModel
        let controller = LowerTitleController()
        controller.selectedNodeModel = self.selectedNodeModel
        self.window!.addTitlebarAccessoryViewController(controller)
        controller.setViewHeight(22)
        }
        
    private func configureWindow()
        {
        NotificationCenter.default.addObserver(self, selector: #selector(self.windowFrameDidChange), name: NSWindow.didResizeNotification, object: window)
        self.window!.titleVisibility = .hidden
        let width = self.splitViewController.splitView.frame.size.width
        var size = width * 2.0 / 11.0
        self.splitViewController.splitView.setPosition(size, ofDividerAt: 0)
        size += width * 6.0 / 11.0
        self.splitViewController.splitView.setPosition(size, ofDividerAt: 1)
        self.window!.toolbar = nil
        self.resizeLeftAccessoryView()
        }
        
//    public func saveContents()
//        {
//        self.hierarchyViewController.saveContents()
//        self.sourceViewController.saveContents()
//        self.inspectorViewController.saveContents()
//        }
        
    public func update(aspect: String,with: Any?,from: Model)
        {
        }
        
    public func setLeftSidebarAction(enabled: Bool)
        {
//        self.leftSidebarController.isEnabled = enabled
        }
        
    public func setRightSidebarAction(enabled: Bool)
        {
//        self.leftSidebarController.isEnabled = enabled
        }
        
    @objc public func windowFrameDidChange(_ notification: Notification)
        {
        self.resizeLeftAccessoryView()
        }
        
    private func resizeLeftAccessoryView()
        {
        let windowWidth = self.window!.frame.size.width
        self.leftSidebarController.setViewWidth(windowWidth - 80)
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

extension ProjectWindowController: NSToolbarItemValidation
    {
    @objc func validateToolbarItem(_ item: NSToolbarItem) -> Bool
        {
        let node = self.selectedNodeModel.value as? SourceNode
        if node.isNil
            {
            return(BrowserActionSet.default.isActionEnabled(label: item.itemIdentifier.rawValue))
            }
        else
            {
            return(node!.actionSet.isActionEnabled(label: item.itemIdentifier.rawValue))
            }
        }
    }
    
// MARK: Application Specific Event Handlers

extension ProjectWindowController
    {
    @IBAction public func onBuildClicked(_ sender: Any?)
        {
        guard let sourceFiles = (self.projectModel.value as? SourceProjectNode)?.allSourceFiles else
            {
            return
            }
        let compiler = ArgonCompiler.build(nodes: sourceFiles)
        guard let node = self.selectedNodeModel.value as? SourceNode,node.isSourceFileNode else
            {
            return
            }
        self.sourceViewController.resetCompilerIssues(newIssues: node.compilerIssues)
        let count = compiler.compilerIssueCount
        self.issueCountIconLabelView.iconTintColorElement = count > 0 ? .colorIssue : .colorToolbarText
        self.issueCountIconLabelView.text = count > 0 ? "\(count) issues" : ""
        self.issueCountIconLabelView.textColorElement  = count > 0 ? .colorIssue : .colorToolbarText
        }
        
    @IBAction public func onShowIssuesClicked(_ sender: Any?)
        {
        let item = sender as! NSToolbarItem
        item.image = NSImage(systemSymbolName: "eye.slash", accessibilityDescription: "")
        item.toolTip = "Hide all compiler issues"
        item.label = "Hide"
        item.action = #selector(self.onHideIssuesClicked)
        self.sourceViewController.showAllCompilerIssues()
        }
        
    @IBAction public func onHideIssuesClicked(_ sender: Any?)
        {
        let item = sender as! NSToolbarItem
        item.image = NSImage(systemSymbolName: "eye", accessibilityDescription: "")
        item.toolTip = "Show all compiler issues"
        item.label = "Show"
        item.action = #selector(self.onShowIssuesClicked)
        self.sourceViewController.hideAllCompilerIssues()
        }
    }
