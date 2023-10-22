//
//  ProjectInspectorViewController.swift
//  Argon
//
//  Created by Vincent Coetzee on 16/09/2023.
//

import Cocoa

class ProjectInspectorViewController: NSViewController
    {
    private weak var issueView: NSTableView!
    private weak var classView: NSOutlineView!
    @IBOutlet weak var inspectorView: ProjectInspectorView!
    @IBOutlet weak var outlineView: NSOutlineView!
    public var projectModel: ValueHolder!
    public var selectedNodeModel: ValueHolder!
    
    public var rootModule: RootModule?
        {
        didSet
            {
            self.outlineView.reloadData()
            }
        }
   
    override func viewDidLoad()
        {
        super.viewDidLoad()
        self.initOutlineView()
        }
        
    public func handleMenuItem(_ menuItem: NSMenuItem) -> Bool
        {
        return(false)
        }
        
    public func validateMenuItem(_ menuItem: NSMenuItem) -> Bool
        {
        return(false)
        }
        
    private func initOutlineView()
        {
        let cellFont = StyleTheme.shared.font(for: .fontOutliner)
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
        self.outlineView.font = StyleTheme.shared.font(for: .fontOutliner)
        self.outlineView.indentationPerLevel = 20
        self.outlineView.indentationMarkerFollowsCell = true
//        self.outlineView.menu?.delegate = self
        }
    }

extension ProjectInspectorViewController: NSOutlineViewDataSource
    {
    @objc func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any
        {
        if item.isNil
            {
            return(self.rootModule!)
            }
        let element = (item as! Symbol)
        return(element.children[index])
        }

    @objc func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool
        {
        let element = (item as! Symbol)
        return(element.children.count > 0)
        }
    }

extension ProjectInspectorViewController: NSOutlineViewDelegate
    {
    @MainActor public func outlineViewSelectionDidChange(_ notification: Notification)
        {
//        let row = self.outlineView.selectedRow
//        let item:IDENode? = row == -1 ? nil : self.outlineView.item(atRow: row) as? IDENode
//        self.selectedNodeModel.value = item
//        self.sourceViewController.editedNode = item
        }
        
    public func outlineView(_ outlineView: NSOutlineView, shouldEdit tableColumn: NSTableColumn?, item: Any) -> Bool
        {
        return(false)
        }
        
    @objc func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int
        {
        if item.isNil
            {
            if self.rootModule.isNil
                {
                return(0)
                }
            return(1)
            }
        let element = item as! Symbol
        return(element.children.count)
        }
        
    @objc func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView?
        {
        let view = SymbolViewCell(frame: .zero)
        let symbol = item as! Symbol
        symbol.configure(nodeView: view)
        return(view)
        }
    }
