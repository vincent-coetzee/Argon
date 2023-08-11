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
    @IBOutlet weak var leftView: NSView!
    @IBOutlet weak var centreView: NSView!
    @IBOutlet weak var rightView: NSView!
    
    private var _project = SourceProjectNode(name: "Project",path: Path(Path.root))
    private var leftSidebarState = ToggleState.expanded
    private var rightSidebarState = ToggleState.expanded
    private var pathControl: NSPathControl!
    private var leftSidebarController: LeftSidebarButtonController!
    private var rightSidebarController: RightSidebarButtonController!
    
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
        
    private var selectedSourceNode: SourceNode?
    
    override func viewDidLoad()
        {
        super.viewDidLoad()
        self.initSourceView()
        self.initOutliner()
        self.representedObject = self.project
        }
        
    public func windowWasCreated(window: NSWindow)
        {
//        let controller = TitlebarPathControlAccessoryViewControler()
//        window.addTitlebarAccessoryViewController(controller)
//        controller.pathControl.wantsLayer = true
//        controller.pathControl.layer!.backgroundColor = NSColor.red.cgColor
//        self.pathControlController = controller
//        controller.pathControl.font = SourceTheme.default.font(for: .fontDefault)
//        controller.pathControl.backgroundColor = SourceTheme.default.color(for: .colorBarBackground)
//        controller.pathControl.pathItems = []
//        controller.rightOffset = 20
//        self.updatePathControl(from: self.project)
        self.toolbar = window.toolbar
        self.toolbar.delegate = self
        self.toolbar.insertItem(withItemIdentifier: NSToolbarItem.Identifier("pathControl"), at: 0)

        self.leftSidebarController = LeftSidebarButtonController()
        self.leftSidebarController.target = self
        window.addTitlebarAccessoryViewController(self.leftSidebarController)
        self.rightSidebarController = RightSidebarButtonController()
        self.rightSidebarController.target = self
        window.addTitlebarAccessoryViewController(self.rightSidebarController)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.rightViewFrameDidChange), name: NSView.frameDidChangeNotification, object: self.rightView)
        NotificationCenter.default.addObserver(self, selector: #selector(self.leftViewFrameDidChange), name: NSView.frameDidChangeNotification, object: self.leftView)
        window.titleVisibility = .hidden
        }
        
    @objc public func leftViewFrameDidChange(_ notification: Notification)
        {
        let frame = self.leftView.frame
        self.leftSidebarController.rightOffset = frame.maxX
        }
        
    public func toolbar(_ toolbar: NSToolbar,itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier,willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem?
        {
        let toolbarItem = NSToolbarItem(itemIdentifier: NSToolbarItem.Identifier(rawValue: "pathControl"))
        toolbarItem.label = ""
        toolbarItem.paletteLabel = ""
        toolbarItem.target = self
        // Set the right attribute, depending on if we were given an image or a view.
        let view = NSPathControl()
        toolbarItem.view = view
        view.wantsLayer = true
        view.layer!.borderWidth = 1
        view.layer!.borderColor = SourceTheme.default.color(for: .colorProjectControls).cgColor
        view.layer!.cornerRadius = SourceTheme.default.metric(for: .metricControlCornerRadius)
        self.pathControl = view
        toolbarItem.view?.translatesAutoresizingMaskIntoConstraints = false
        let heightConstraint = NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30)
        view.addConstraint(heightConstraint)
        heightConstraint.isActive = true
        let widthConstraint = NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 400)
        view.addConstraint(widthConstraint)
        widthConstraint.isActive = true
        self.updatePathControl(from: self.project)
        toolbarItem.isNavigational = true
        self.toolbar.centeredItemIdentifiers = [NSToolbarItem.Identifier("build")]
        self.toolbar.centeredItemIdentifiers = [NSToolbarItem.Identifier("parse")]
        self.toolbar.centeredItemIdentifiers = [NSToolbarItem.Identifier("run")]
        self.toolbar.centeredItemIdentifiers = [NSToolbarItem.Identifier("debug")]
        self.toolbar.centeredItemIdentifiers = [NSToolbarItem.Identifier("clean")]
        return(toolbarItem)
        }
        
    private func initSourceView()
        {
        self.sourceView.textViewDelegate = self
        self.sourceView.textFocusDelegate = self
        self.sourceView.autoresizingMask = [.width]
        }
        
    private func initOutliner()
        {
        self.outliner.backgroundColor = SourceTheme.default.color(for: .colorOutlineBackground)
        self.outliner.rowSizeStyle = .custom
        self.outliner.intercellSpacing = NSSize(width: 0, height: 4)
        self.outliner.doubleAction = #selector(self.onOutlinerClicked)
        self.outliner.target = self
        self.outliner.style = .plain
        self.outliner.columnAutoresizingStyle = .lastColumnOnlyAutoresizingStyle
        self.outliner.register(NSNib(nibNamed: "ProjectViewCell", bundle: nil), forIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ProjectViewCell"))
        self.outliner.delegate = self
        self.outliner.dataSource = self
        self.outliner.reloadData()
        self.outliner.font = SourceTheme.default.font(for: .fontDefault)
        self.outliner.indentationPerLevel = 15
        self.outliner.indentationMarkerFollowsCell = true
        self.outliner.intercellSpacing = NSSize(width: 5,height: 0)
        NotificationCenter.default.addObserver(self, selector: #selector(self.outlinerSelectionChanged), name: NSOutlineView.selectionDidChangeNotification, object: self.outliner)
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
            pathControlItem.attributedTitle = NSAttributedString(string: anItem.name,attributes: [.font: SourceTheme.default.font(for: .fontDefault),.foregroundColor: SourceTheme.default.color(for: .colorDefault)])
            pathControlItem.image = anItem.projectViewImage.image(withTintColor: SourceTheme.default.color(for: .colorTint))
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
                let amount = self.leftView.frame.width
                self.leftSidebarState = self.leftSidebarState.toggledState(amount)
                self.splitView.setPosition(0, ofDividerAt: 0)
                }
            else
                {
                self.splitView.setPosition(self.leftSidebarState.amount,ofDividerAt: 0)
                self.leftSidebarState = self.leftSidebarState.toggledState()
                }
            }
        }
        
    @objc public func onToggleRightSidebar(_ sender: Any?)
        {
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
        
    @IBAction public func onOutlinerClicked(_ sender: Any?)
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
            let path = node.path.join("Untitled.argon")
            let file = SourceFileNode(name: "Untitled.argon",path: path)
            file.source = Repository.initialSource
            self.sourceView.string = file.source
            node.addNode(file)
            self.outliner.reloadItem(node,reloadChildren: true)
            self.outliner.expandItem(node,expandChildren: true)
            let _ = ArgonScanner(source: file.source,sourceKey: 0)
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
        self.selectedSourceNode = sourceNode
        if sourceNode.isSourceFileNode
            {
            let sourceFileNode = sourceNode as! SourceFileNode
            let source = sourceFileNode.source
            self.sourceView.string = source
            self.sourceView.tokens = ArgonScanner(source: sourceFileNode.expandedSource, sourceKey: sourceFileNode.sourceKey).allTokens()
            }
        self.view.window?.title = sourceNode.title
        }
    }
    
extension ProjectViewController: NSToolbarDelegate
    {
    }

extension ProjectViewController: NSToolbarItemValidation
    {
    func validateToolbarItem(_ item: NSToolbarItem) -> Bool
        {
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
    
extension ProjectViewController
    {
    @objc func outlinerSelectionChanged(_ notification: Notification)
        {
        let row = self.outliner.selectedRow
        guard row != -1 else
            {
            return
            }
        let item = self.outliner.item(atRow: row) as! SourceNode
        if item.isSourceFileNode
            {
            let node = item as! SourceFileNode
            node.tokens = ArgonScanner(source: node.source, sourceKey: node.sourceKey).allTokens()
            self.sourceView.string = node.source
            self.sourceView.tokens = node.tokens
            }
        self.updatePathControl(from: item)
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
    @MainActor func outlineViewSelectionDidChange(_ notification: Notification)
        {
        let row = self.outliner.selectedRow
        guard row != -1 else
            {
            return
            }
        let item = self.outliner.item(atRow: row) as! SourceNode
        self.setSelected(sourceNode: item)
        }
        
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
        ArgonCompiler.build(nodes: self._project.allSourceFiles)
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
    }
    
