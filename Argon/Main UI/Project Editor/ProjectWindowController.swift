//
//  ProjectWindowController.swift
//  Argon
//
//  Created by Vincent Coetzee on 16/09/2023.
//

import AppKit

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
    
    private var editorState = ProjectEditorState(rawValue: 0)
    @IBOutlet weak var mainMenu: NSMenu!
    
    
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
        self.hierarchyViewController.sourceViewController = self.sourceViewController
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
        
    @IBAction func handleMenuEvent(_ sender: Any?)
        {
        guard let menuItem = sender as? NSMenuItem else
            {
            return
            }
        if self.hierarchyViewController.handleMenuItem(menuItem)
            {
            return
            }
        if self.sourceViewController.handleMenuItem(menuItem)
            {
            return
            }
        if self.inspectorViewController.handleMenuItem(menuItem)
            {
            return
            }
        }
    }
    
extension ProjectWindowController: NSMenuItemValidation
    {
    func validateMenuItem(_ menuItem: NSMenuItem) -> Bool
        {
        switch(menuItem.identifier!.rawValue)
            {
            case("buildProject"):
                return(true)
            case("runProject"):
                return(true)
            case("debugProject"):
                return(true)
            case("cleanProject"):
                return(true)
            default:
                break
            }
        if self.hierarchyViewController.validateMenuItem(menuItem)
            {
            return(true)
            }
        if self.sourceViewController.validateMenuItem(menuItem)
            {
            return(true)
            }
        return(self.inspectorViewController.validateMenuItem(menuItem))
        }
    }
    
// MARK: Application Specific Event Handlers

extension ProjectWindowController
    {
    @IBAction public func onBuildClicked(_ sender: Any?)
        {
        guard let sourceFiles = (self.projectModel.value as? IDEProjectNode)?.allSourceFiles else
            {
            return
            }
        let compiler = ArgonCompiler.build(nodes: sourceFiles)
        guard let node = self.selectedNodeModel.value as? IDENode,node.isSourceFileNode else
            {
            return
            }
//        self.sourceViewController.resetCompilerIssues(newIssues: node.compilerIssues)
//        let count = compiler.compilerIssueCount
//        self.issueCountIconLabelView.iconTintColorElement = count > 0 ? .colorIssue : .colorToolbarText
//        self.issueCountIconLabelView.text = count > 0 ? "\(count) issues" : ""
//        self.issueCountIconLabelView.textColorElement  = count > 0 ? .colorIssue : .colorToolbarText
        }
        
    @IBAction public func onToggleIssuesClicked(_ sender: Any?)
        {
        if self.editorState.contains(.kShowIssues)
            {
            self.replace(menuItemTitled: "Hide Issues",with: "Show Issues")
            self.editorState.remove(.kShowIssues)
//            self.sourceViewController.toggleCompilerIssues(on: true)
            }
        else
            {
            self.replace(menuItemTitled: "Show Issues",with: "Hide Issues")
            self.editorState.insert(.kShowIssues)
//            self.sourceViewController.toggleCompilerIssues(on: false)
            }
        }
        
    @IBAction public func onToggleTypesClicked(_ sender: Any?)
        {
        if self.editorState.contains(.kShowTypes)
            {
            self.replace(menuItemTitled: "Hide Inferred Types",with: "Show Inferred Types")
            self.editorState.remove(.kShowTypes)
//            self.sourceViewController.toggleInferredTypes(on: true)
            }
        else
            {
            self.replace(menuItemTitled: "Show Inferred Types",with: "Hide Inferred Types")
            self.editorState.insert(.kShowTypes)
//            self.sourceViewController.toggleInferredTypes(on: false)
            }
        }
        
    private func replace(menuItemTitled oldTitle: String,with newTitle: String)
        {
        if let menuItem = NSApplication.shared.mainMenu?.firstMenuItem(withTitle: oldTitle)
            {
            menuItem.title = newTitle
            }
        }
        
    @IBAction public func onToggleComments(_ sender: Any?)
        {
//        guard !self.sourceViewController.selectionIsEmpty() else
//            {
//            NSSound.beep()
//            return
//            }
//        self.sourceViewController.toggleComments()
        }
    }


extension NSMenu
    {
    public func firstMenuItem(withTitle aTitle: String) -> NSMenuItem?
        {
        for item in self.items
            {
            if aTitle == item.title
                {
                return(item)
                }
            if let anItem = item.firstMenuItem(withTitle: aTitle)
                {
                return(anItem)
                }
            }
        return(nil)
        }
    }

extension NSMenuItem
    {
    func firstMenuItem(withTitle aTitle: String) -> NSMenuItem?
        {
        return(nil)
        }
    }
