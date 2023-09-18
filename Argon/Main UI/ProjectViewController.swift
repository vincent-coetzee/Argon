//
//  ViewController.swift
//  Argon
//
//  Created by Vincent Coetzee on 2022/11/05.
//

import Cocoa
import AppKit
import Path
import UniformTypeIdentifiers

class ProjectViewController: NSViewController,TextFocusDelegate,NSTextViewDelegate
    {
    @IBOutlet weak var outliner: NSOutlineView!
    @IBOutlet weak var sourceView:SourceCodeEditingView!
    @IBOutlet weak var toolbar: NSToolbar!
    @IBOutlet weak var splitView: NSSplitView!
//    @IBOutlet weak var leftView: NSView!
//    @IBOutlet weak var centerView: NSView!
//    @IBOutlet weak var rightView: NSView!
    
    private var _project = SourceProjectNode(name: "Project",path: Path(Path.root))
    private var leftSidebarState = ToggleState.expanded
    private var rightSidebarState = ToggleState.expanded
    private var pathControl: NSPathControl!
    private var leftSidebarController: LeftSidebarButtonController!
    private var rightSidebarController: RightSidebarButtonController!
    private var pathControlWidthConstraint: NSLayoutConstraint!
    private var selectedSourceNode: SourceNode!
    private var issueCountIconLabelView: IconLabelView!
    private var stateWasRestored = false
    private var isCollapsingLeftSidebar = false
    
    private static let outlinerViewIndex = 0
    private static let sourceViewIndex = 1
    private static let rightViewIndex = 2
    
    public var projectState: ProjectState
        {
        get
            {
            return(ProjectState(project: self.project, leftViewFrame: .zero, centerViewFrame: .zero,rightViewFrame: .zero))
            }
        set
            {
            self.splitView.setPosition(newValue.leftViewFrame.size.width, ofDividerAt: Self.outlinerViewIndex)
            self.splitView.setPosition(newValue.centerViewFrame.size.width, ofDividerAt: Self.sourceViewIndex)
            self.splitView.setPosition(newValue.rightViewFrame.size.width, ofDividerAt: Self.rightViewIndex)
            self.project = newValue.project
            self.stateWasRestored = true
            }
        }
        
    public var project: SourceProjectNode
        {
        get
            {
            return(_project)
            }
        set
            {
            self._project = newValue
            self.outliner.reloadData()
            }
        }
        
    override func viewDidLoad()
        {
        super.viewDidLoad()
        self.initSourceView()
        self.initOutliner()
        self.initSplitView()
        self.representedObject = self.project
        }
        
    private func initSplitView()
        {
        self.splitView.delegate = self
        self.splitView.setHoldingPriority(NSLayoutConstraint.Priority(rawValue: 199), forSubviewAt: 1)
        }
        
    public func windowWasCreated(window: NSWindow)
        {
        self.toolbar = window.toolbar
        self.toolbar.delegate = self
        self.toolbar.insertItem(withItemIdentifier: NSToolbarItem.Identifier("issueControl"), at: 0)
        self.toolbar.insertItem(withItemIdentifier: NSToolbarItem.Identifier("pathControl"), at: 0)
        self.leftSidebarController = LeftSidebarButtonController()
        self.leftSidebarController.target = self
        window.addTitlebarAccessoryViewController(self.leftSidebarController)
        self.rightSidebarController = RightSidebarButtonController()
        self.rightSidebarController.target = self
        window.addTitlebarAccessoryViewController(self.rightSidebarController)
        NotificationCenter.default.addObserver(self, selector: #selector(self.windowFrameDidChange), name: NSWindow.didResizeNotification, object: window)
        window.titleVisibility = .hidden
        if !self.stateWasRestored
            {
            let frame = window.frame
            let leftWidth = frame.size.width / 4.0
            let centerWidth = leftWidth * 2.0
            self.splitView.setPosition(leftWidth, ofDividerAt: 0)
            self.splitView.setPosition(centerWidth + leftWidth,ofDividerAt: 1)
            }
        }
        
    @objc public func windowFrameDidChange(_ notification: Notification)
        {
        let window = notification.object as! NSWindow
        let toolbar = window.toolbar!
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
        self.pathControl.removeConstraint(self.pathControlWidthConstraint)
        let widthConstraint = NSLayoutConstraint(item: self.pathControl!, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: self.pathControlWidth)
        self.pathControl.addConstraint(widthConstraint)
        self.pathControlWidthConstraint = widthConstraint
        widthConstraint.isActive = true
        }
        
    private var pathControlWidth: CGFloat
        {
        let toolbar = self.view.window!.toolbar!
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
        let frame = self.view.window!.frame
        let width = frame.size.width - toolbarWidth
        return(width)
        }
 
    public func toolbar(_ toolbar: NSToolbar,itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier,willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem?
        {
        if itemIdentifier == NSToolbarItem.Identifier("pathControl")
            {
            let toolbarItem = NSToolbarItem(itemIdentifier: NSToolbarItem.Identifier(rawValue: "pathControl"))
            toolbarItem.label = ""
            toolbarItem.paletteLabel = ""
            toolbarItem.target = self
            let view = NSPathControl()
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
            self.updatePathControl(from: self.project)
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
        
    private func initSourceView()
        {
        self.sourceView.textViewDelegate = self
        self.sourceView.textFocusDelegate = self
        self.sourceView.autoresizingMask = [.width]
        self.sourceView.sourceEditorDelegate = self
        }
        
    private func initOutliner()
        {
        let cellFont = StyleTheme.shared.font(for: .fontDefault)
        let rowHeight = cellFont.lineHeight + 4 + 4
        self.outliner.rowHeight = rowHeight
        self.outliner.backgroundColor = StyleTheme.shared.color(for: .colorOutlineBackground)
        self.outliner.rowSizeStyle = .custom
        self.outliner.intercellSpacing = NSSize(width: 0, height: 4)
        self.outliner.doubleAction = #selector(self.onOutlinerDoubleClicked)
        self.outliner.target = self
        self.outliner.style = .plain
        self.outliner.columnAutoresizingStyle = .lastColumnOnlyAutoresizingStyle
        self.outliner.register(NSNib(nibNamed: "ProjectViewCell", bundle: nil), forIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ProjectViewCell"))
        self.outliner.delegate = self
        self.outliner.dataSource = self
        self.outliner.reloadData()
        self.outliner.font = StyleTheme.shared.font(for: .fontDefault)
        self.outliner.indentationPerLevel = 15
        self.outliner.indentationMarkerFollowsCell = true
        self.outliner.intercellSpacing = NSSize(width: 5,height: 0)
        }
        
    private func updatePathControl(from node: SourceNode?)
        {
        guard node.isNotNil else
            {
            self.pathControl.pathItems = []
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
        self.pathControl.pathItems = items
        }
        
    @objc public func onToggleLeftSidebar(_ sender: Any?)
        {
        NSAnimationContext.runAnimationGroup
            {
            context in
            context.allowsImplicitAnimation = true
            context.duration = 0.75
            if self.leftSidebarState.isExpanded
                {
                self.isCollapsingLeftSidebar = true
                let amount = self.outliner.bounds.width
                self.leftSidebarState = self.leftSidebarState.toggledState(amount)
                self.splitView.setPosition(0, ofDividerAt: 0)
                }
            else
                {
                self.isCollapsingLeftSidebar = false
                self.splitView.setPosition(self.leftSidebarState.amount,ofDividerAt: 0)
                self.leftSidebarState = self.leftSidebarState.toggledState()
                }
            }
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
        
    @IBAction public func textDidGainFocus(_ textView: NSTextView)
        {
        }
        
    @IBAction public func textDidLoseFocus(_ textView: NSTextView)
        {
        }
        
    @IBAction public func textDidEndEditing(_ notification: Notification)
        {
        }
        
    @IBAction public func textDidBeginEditing(_ notification: Notification)
        {
        }
        
    @IBAction public func onNewArgonFile(_ sender: Any?)
        {
        let row = self.outliner.clickedRow
        guard row != -1 else
            {
            return
            }
        let node = self.outliner.item(atRow: row) as! SourceNode
        if node.isCompositeNode
            {
            let name = Argon.nextIndex(named: "Untitled") + ".argon"
            let path = node.path.join(name)
            let file = SourceFileNode(name: name,path: path)
            file.setIsNewFile(true)
            file.setSource(Repository.initialSource)
            self.sourceView.string = file.source
            node.addNode(file)
            self.outliner.reloadItem(node,reloadChildren: true)
            self.outliner.expandItem(node,expandChildren: true)
            let _ = ArgonScanner(source: file.source)
            let row = self.outliner.row(forItem: file)
            let indexSet = IndexSet(integer: row)
            self.outliner.selectRowIndexes(indexSet, byExtendingSelection: false)
            self.sourceView.tokens = file.tokens
            }
        else
            {
            NSSound.beep()
            }
        }
        
    @IBAction public func onNewFolder(_ sender: Any?)
        {
        let row = self.outliner.clickedRow
        guard row != -1 else
            {
            return
            }
        let element = self.outliner.item(atRow: row) as! SourceNode
        if element.isCompositeNode
            {
            let path = element.path.join("Folder")
            let folder = SourceFolderNode(name: "Folder",path: path)
            element.addNode(folder)
            self.outliner.reloadItem(element,reloadChildren: true)
            self.outliner.expandItem(element,expandChildren: true)
            }
        else
            {
            NSSound.beep()
            }
        }
        
    @IBAction public func onDeleteElement(_ sender: Any?)
        {
        // use an nsalert to warn user then delete element
        }
        
    private func setSelected(sourceNode: SourceNode)
        {
        if self.selectedSourceNode.isNotNil
            {
            self.sourceView.removeDependent(self.selectedSourceNode)
            }
        self.selectedSourceNode = sourceNode
        self.sourceView.addDependent(sourceNode)
        if sourceNode.isSourceFileNode
            {
            let sourceFileNode = sourceNode as! SourceFileNode
            self.sourceView.string = sourceFileNode.expandedSource
            self.sourceView.tokens = ArgonScanner(source: sourceFileNode.expandedSource).allTokens()
            }
        }
    }
    
extension ProjectViewController: NSSplitViewDelegate
    {
    @objc func splitView(_ splitView: NSSplitView, constrainMinCoordinate proposedMinimumPosition: CGFloat, ofSubviewAt dividerIndex: Int) -> CGFloat
        {
        let maximumRowWidth = self.isCollapsingLeftSidebar ? 0 : self.outliner.widthOfWidestVisibleRow
        return(max(proposedMinimumPosition,maximumRowWidth))
        }
    }
    
extension ProjectViewController: NSToolbarDelegate
    {
    }

extension ProjectViewController: NSToolbarItemValidation
    {
    func validateToolbarItem(_ item: NSToolbarItem) -> Bool
        {
        if item.itemIdentifier == NSToolbarItem.Identifier(rawValue: "show")
            {
            if let node = self.selectedSourceNode,node.isSourceFileNode
                {
                return(true)
                }
            return(false)
            }
        return(true)
        }
    }

extension ProjectViewController: NSMenuItemValidation
    {
    func validateMenuItem(_ menuItem: NSMenuItem) -> Bool
        {
        let selectedRow = self.outliner.selectedRow
        guard selectedRow != -1 else
            {
            return(false)
            }
        if menuItem.title == "Delete"
            {
            return(true)
            }
        let selectedItem = self.outliner.item(atRow: selectedRow) as! SourceNode
        if selectedItem.isCompositeNode
            {
            return(true)
            }
        return(false)
        }
    }

extension ProjectViewController: NSMenuDelegate
    {
    public func menuNeedsUpdate(_ menu: NSMenu)
        {
        menu.autoenablesItems = true
        menu.item(withTitle: "New Folder")?.action = #selector(self.onNewFolder)
        menu.item(withTitle: "New Argon File")?.action = #selector(self.onNewArgonFile)
        menu.item(withTitle: "Delete")?.action = #selector(self.onDeleteElement)
        let row = self.outliner.clickedRow
        guard row != -1 else
            {
            return
            }
        for menuItem in menu.items
            {
            menuItem.target = self
            }
        let item = self.outliner.item(atRow: row) as! SourceNode
        menu.item(withTitle: "Import...")?.isEnabled = item.isCompositeNode
        }
    }
    
extension ProjectViewController: NSOutlineViewDataSource
    {
    @objc func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any
        {
        if item.isNil
            {
            return(self._project)
            }
        let element = (item as! SourceNode)
        return(element.child(atIndex: index)!)
        }

    @objc func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool
        {
        let element = (item as! SourceNode)
        return(element.isExpandable)
        }
    }
    
extension ProjectViewController: NSOutlineViewDelegate
    {
//    @MainActor public func outlineViewSelectionDidChange(_ notification: Notification)
//        {
//        let row = self.outliner.selectedRow
//        guard row != -1 else
//            {
//            return
//            }
//        let item = self.outliner.item(atRow: row) as! SourceNode
//        self.setSelected(sourceNode: item)
//        self.updatePathControl(from: item)
//        }
        
    public func outlineView(_ outlineView: NSOutlineView, shouldEdit tableColumn: NSTableColumn?, item: Any) -> Bool
        {
        return(true)
        }
        
    @objc func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int
        {
        if item.isNil
            {
            return(1)
            }
        let element = item as! SourceNode
        return(element.childCount)
        }
        
    @objc func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView?
        {
        if let view = self.outliner.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ProjectViewCell"), owner: nil) as? ProjectViewCell
            {
            view.node = item as? SourceNode
            view.textField?.target = self
            view.textField?.action = #selector(projectElementTitleChanged)
            return(view)
            }
        return(nil)
        }
        
    @objc public func projectElementTitleChanged(_ sender: Any?)
        {
        let rowIndex = self.outliner.selectedRow
        guard rowIndex != -1 else
            {
            return
            }
        let element = self.outliner.item(atRow: rowIndex) as! SourceNode
        if let string = (sender as? NSTextField)?.stringValue
            {
            element.setName(string)
            self.outliner.reloadItem(element)
            }
        }
    }

extension ProjectViewController: SourceEditorDelegate
    {
    func sourceEditorKeyPressed(_ editor: NSTextView)
        {
        
        }
    
    func sourceEditor(_ editor: NSTextView, changedLine: Int, offset: Int)
        {
        }
    
    func sourceEditor(_ editor: NSTextView,changedSource string: String,tokens: Tokens)
        {
        self.selectedSourceNode.setSource(string)
        self.selectedSourceNode.setTokens(tokens)
        }
    }
    
extension ProjectViewController
    {
    @IBAction public func onImportFileClicked(_ sender: Any?)
        {
        let selectedRow = self.outliner.selectedRow
        guard selectedRow != -1 else
            {
            NSSound.beep()
            return
            }
        let selectedNode = self.outliner.item(atRow: selectedRow) as! SourceNode
        guard selectedNode.isCompositeNode else
            {
            NSSound.beep()
            return
            }
        let panel = NSOpenPanel()
        panel.canChooseFiles = true
        panel.canChooseDirectories = false
        panel.allowsMultipleSelection = true
        panel.title = "Select files for import"
        panel.allowedContentTypes = [UTType("com.macsemantics.argon.source")!]
        if panel.runModal() == .OK
            {
            for url in panel.urls
                {
                let path = Path(url: url)!
                if let source = try? String(contentsOf: path)
                    {
                    let name = path.lastPathComponentSansExtension
                    let newNode = SourceFileNode(name: name, path: path,source: source)
                    newNode.setIsNewFile(false)
                    newNode.expandedSource = newNode.source
                    selectedNode.addNode(newNode)
                    }
                }
            selectedNode.sortNodes()
            self.outliner.reloadItem(selectedNode)
            }
        }
        
    @IBAction public func onBuildClicked(_ sender: Any?)
        {
        let compiler = ArgonCompiler.build(nodes: self._project.allSourceFiles)
        guard let node = self.selectedSourceNode,node.isSourceFileNode else
            {
            return
            }
        self.sourceView.resetCompilerIssues(newIssues: node.compilerIssues)
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
        self.sourceView.showAllCompilerIssues()
        }
        
    @IBAction public func onHideIssuesClicked(_ sender: Any?)
        {
        let item = sender as! NSToolbarItem
        item.image = NSImage(systemSymbolName: "eye", accessibilityDescription: "")
        item.toolTip = "Show all compiler issues"
        item.label = "Show"
        item.action = #selector(self.onShowIssuesClicked)
        self.sourceView.hideAllCompilerIssues()
        }
        
    @IBAction public func onLoadClicked(_ sender: Any?)
        {
        }
        
    @IBAction public func onSaveClicked(_ sender: Any?)
        {
        }
        
    @IBAction public func onParseClicked(_ sender: Any?)
        {
        ArgonCompiler.parse(nodes: self._project.allSourceFiles)
        }
        
    @IBAction public func onRunClicked(_ sender: Any?)
        {
        }
        
    @IBAction public func onCleanClicked(_ sender: Any?)
        {
        }
        
    @IBAction public func onDebugClicked(_ sender: Any?)
        {
        }
        
    @IBAction public func onOutlinerDoubleClicked(_ sender: Any?)
        {
        }
    }
    
