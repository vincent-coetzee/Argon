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
    private var _project = SourceProjectNode(name: "Project",path: Path(Path.root))
    
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
    
extension ProjectViewController: NSToolbarItemValidation
    {
    func validateToolbarItem(_ item: NSToolbarItem) -> Bool
        {
        let row = self.outliner.selectedRow
        switch(item.itemIdentifier.rawValue)
            {
            case("compile"):
                guard row != -1 else
                    {
                    return(false)
                    }
                let selectedItem = self.outliner.item(atRow: row) as! SourceNode
                if selectedItem.isSourceFileNode
                    {
                    return(true)
                    }
                return(false)
            default:
                return(true)
            }
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
        }
        
    @IBAction public func onCompileClicked(_ sender: Any?)
        {
        print("halt")
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
    
