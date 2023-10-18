//
//  ProjectOutlineViewController.swift
//  Argon
//
//  Created by Vincent Coetzee on 16/09/2023.
//

import Cocoa
import UniformTypeIdentifiers
import Path

class ProjectHierarchyViewController: NSViewController,Dependent
    {
    public let dependentKey = DependentSet.nextDependentKey
    
    @IBOutlet weak var outlineView: NSOutlineView!
    
    public var sourceViewController: ProjectSourceViewController!
    
    public var projectModel: ValueHolder = ValueHolder(value: nil)
        {
        willSet
            {
            self.projectModel.removeDependent(self)
            }
        didSet
            {
            self.projectModel.addDependent(self)
            }
        }
            
    public var selectedNodeModel: ValueHolder = ValueHolder(value: nil)
        {
        willSet
            {
            self.selectedNodeModel.removeDependent(self)
            }
        didSet
            {
            self.selectedNodeModel.addDependent(self)
            }
        }

    override func viewDidLoad()
        {
        super.viewDidLoad()
        self.initOutlineView()
        }
        
//    public func saveContents()
//        {
//        (self.projectModel.value as? SourceProjectNode)?.saveContents()
//        }

    private func initOutlineView()
        {
        let cellFont = StyleTheme.shared.font(for: .fontDefault)
        let rowHeight = cellFont.lineHeight + 2 + 2
        self.outlineView.rowHeight = rowHeight
        self.outlineView.backgroundColor = StyleTheme.shared.color(for: .colorOutlinerBackground)
        self.outlineView.rowSizeStyle = .custom
        self.outlineView.intercellSpacing = NSSize(width: 0, height: 0)
        self.outlineView.target = self
        self.outlineView.style = .plain
        self.outlineView.columnAutoresizingStyle = .lastColumnOnlyAutoresizingStyle
        self.outlineView.delegate = self
        self.outlineView.dataSource = self
        self.outlineView.reloadData()
        self.outlineView.font = StyleTheme.shared.font(for: .fontDefault)
        self.outlineView.indentationPerLevel = 20
        self.outlineView.indentationMarkerFollowsCell = true
        self.outlineView.menu?.delegate = self
        }
        
    public func update(aspect: String,with: Any?,from: Model)
        {
        if from.dependentKey == self.projectModel.dependentKey && self.projectModel.value.isNotNil
            {
            self.outlineView.reloadData()
            return
            }
        if from.dependentKey == self.selectedNodeModel.dependentKey
            {
            if self.selectedNodeModel.value.isNotNil
                {
                self.outlineView.menu = (self.selectedNodeModel.value! as! IDENode).actionSet.hierarchyActionMenu
                }
            return
            }
        }
        
    @objc public func handleMenuItem(_ menuItem: NSMenuItem) -> Bool
        {
        switch(menuItem.identifier!.rawValue)
            {
            case("importFile"):
                self.importFile()
                return(true)
            case("newFolder"):
                self.onNewFolder(nil)
                return(true)
            case("newArgonFile"):
                self.onNewArgonFile(nil)
                return(true)
            case("newVisualDesignFile"):
                self.onNewVisualDesign(nil)
                return(true)
            case("delete"):
                self.onDeleteNode(nil)
                return(true)
            default:
                return(false)
            }
        }
        
    @objc public func validateMenuItem(_ menuItem: NSMenuItem) -> Bool
        {
        switch(menuItem.identifier!.rawValue)
            {
            case("importFile"):
                return((self.selectedNodeModel.value as? IDECompositeNode).isNotNil)
            case("newFolder"):
                return((self.selectedNodeModel.value as? IDECompositeNode).isNotNil)
            case("newArgonFile"):
                return((self.selectedNodeModel.value as? IDECompositeNode).isNotNil)
            case("newVisualDesignFile"):
                return((self.selectedNodeModel.value as? IDECompositeNode).isNotNil)
            case("delete"):
                return(self.selectedNodeModel.value.isNotNil)
            default:
                return(false)
            }
        }
    }
    

extension ProjectHierarchyViewController: NSMenuDelegate
    {
    public func menuNeedsUpdate(_ menu: NSMenu)
        {
        menu.autoenablesItems = true
        menu.item(withTitle: "New Folder")?.action = #selector(self.handleMenuItem)
        menu.item(withTitle: "New Argon File")?.action = #selector(self.handleMenuItem)
        menu.item(withTitle: "Delete")?.action = #selector(self.handleMenuItem)
        let row = self.outlineView.clickedRow
        guard row != -1 else
            {
            return
            }
        for menuItem in menu.items
            {
            menuItem.target = self
            }
        let item = self.outlineView.item(atRow: row) as! IDENode
        let menuItem = menu.item(withTitle: "Import...")!
        menuItem.isEnabled = item.isCompositeNode
        menuItem.target = self
        menuItem.action = #selector(self.handleMenuItem)
        }
    }
        
extension ProjectHierarchyViewController: NSOutlineViewDelegate
    {
    @MainActor public func outlineViewSelectionDidChange(_ notification: Notification)
        {
        let row = self.outlineView.selectedRow
        let item:IDENode? = row == -1 ? nil : self.outlineView.item(atRow: row) as? IDENode
        self.selectedNodeModel.value = item
        self.sourceViewController.editedNode = item
        }
        
    public func outlineView(_ outlineView: NSOutlineView, shouldEdit tableColumn: NSTableColumn?, item: Any) -> Bool
        {
        return(false)
        }
        
    @objc func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int
        {
        if item.isNil
            {
            return(1)
            }
        let element = item as! IDENode
        return(element.childCount)
        }
        
    @objc func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView?
        {
        let view = ProjectViewCell(frame: .zero)
        view.node = item as? IDENode
        view.textPane.target = self
        view.textPane.action = #selector(self.projectElementTitleChanged)
        return(view)
        }
        
    @objc public func projectElementTitleChanged(_ sender: Any?)
        {
        let rowIndex = self.outlineView.selectedRow
        guard rowIndex != -1 else
            {
            return
            }
        let element = self.outlineView.item(atRow: rowIndex) as! IDENode
        if let string = (sender as? NSTextField)?.stringValue
            {
            element.setName(string)
            self.outlineView.reloadItem(element)
            }
        if element.isProjectNode
            {
            self.projectModel.shake(aspect: "title")
            }
        }
    }
    
extension ProjectHierarchyViewController: NSOutlineViewDataSource
    {
    @objc func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any
        {
        if item.isNil
            {
            return(self.projectModel.value!)
            }
        let element = (item as! IDENode)
        return(element.child(atIndex: index)!)
        }

    @objc func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool
        {
        let element = (item as! IDENode)
        return(element.isExpandable)
        }
    }

extension ProjectHierarchyViewController
    {
    @IBAction public func onNewVisualDesign(_ sender: Any?)
        {
        }
        
    @IBAction public func onNewArgonFile(_ sender: Any?)
        {
        let row = self.outlineView.clickedRow
        guard row != -1 else
            {
            return
            }
        let node = self.outlineView.item(atRow: row) as! IDENode
        if node.isCompositeNode
            {
            let name = Argon.nextIndex(named: "Untitled") + ".argon"
            let path = node.path.join(name)
            let file = IDESourceFileNode(name: name,path: path)
            file.setIsNewFile(true)
            file.setSource(Repository.initialSourceForNewSourceFile)
            node.addNode(file)
            self.outlineView.reloadItem(node,reloadChildren: true)
            self.outlineView.expandItem(node,expandChildren: true)
            let row = self.outlineView.row(forItem: file)
            let indexSet = IndexSet(integer: row)
            self.outlineView.selectRowIndexes(indexSet, byExtendingSelection: false)
            self.selectedNodeModel.value = file
            }
        else
            {
            NSSound.beep()
            }
        }
        
    @IBAction public func onNewFolder(_ sender: Any?)
        {
        let row = self.outlineView.clickedRow
        guard row != -1 else
            {
            return
            }
        let element = self.outlineView.item(atRow: row) as! IDENode
        if element.isCompositeNode
            {
            let path = element.path.join("Folder")
            let folder = IDEFolderNode(name: "Folder",path: path)
            element.addNode(folder)
            self.outlineView.reloadItem(element,reloadChildren: true)
            self.outlineView.expandItem(element,expandChildren: true)
            let row = self.outlineView.row(forItem: folder)
            let indexSet = IndexSet(integer: row)
            self.outlineView.selectRowIndexes(indexSet, byExtendingSelection: false)
            self.selectedNodeModel.value = folder
            }
        else
            {
            NSSound.beep()
            }
        }
        
    @IBAction public func onDeleteNode(_ sender: Any?)
        {
        // use an nsalert to warn user then delete element
        }
        
    @objc func importFile()
        {
        let selectedRow = self.outlineView.selectedRow
        guard selectedRow != -1 else
            {
            NSSound.beep()
            return
            }
        let selectedNode = self.outlineView.item(atRow: selectedRow) as! IDENode
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
        panel.allowedContentTypes = [.argonSourceFileType]
        if panel.runModal() == .OK
            {
            for url in panel.urls
                {
                let path = Path(url: url)!
                if let source = try? String(contentsOf: path)
                    {
                    let name = path.lastPathComponentSansExtension
                    let newNode = IDESourceFileNode(name: name, path: path,source: source)
                    newNode.setIsNewFile(false)
                    newNode.expandedSource = newNode.source
                    selectedNode.addNode(newNode)
                    let row = self.outlineView.row(forItem: newNode)
                    let indexSet = IndexSet(integer: row)
                    self.outlineView.selectRowIndexes(indexSet, byExtendingSelection: false)
                    self.selectedNodeModel.value = newNode
                    }
                }
            selectedNode.sortNodes()
            self.outlineView.reloadItem(selectedNode)
            }
        }
    }
