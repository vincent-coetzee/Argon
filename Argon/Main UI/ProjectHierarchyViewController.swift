//
//  ProjectOutlineViewController.swift
//  Argon
//
//  Created by Vincent Coetzee on 16/09/2023.
//

import Cocoa

class ProjectHierarchyViewController: NSViewController,Dependent
    {
    public let dependentKey = DependentSet.nextDependentKey
    
    @IBOutlet weak var outlineView: NSOutlineView!
    
    public var sharedProjectHolder: ValueHolder!
        {
        willSet
            {
            self.sharedProjectHolder?.removeDependent(self)
            }
        didSet
            {
            self.sharedProjectHolder?.addDependent(self)
            }
        }
            
    public var sharedNodeHolder: ValueHolder!
        {
        willSet
            {
            self.sharedNodeHolder?.removeDependent(self)
            }
        didSet
            {
            self.sharedNodeHolder?.addDependent(self)
            }
        }

    override func viewDidLoad()
        {
        super.viewDidLoad()
        self.initOutlineView()
        }
        
    private func initOutlineView()
        {
        let cellFont = StyleTheme.shared.font(for: .fontDefault)
        let rowHeight = cellFont.lineHeight + 4 + 4
        self.outlineView.rowHeight = rowHeight
        self.outlineView.backgroundColor = StyleTheme.shared.color(for: .colorOutlineBackground)
        self.outlineView.rowSizeStyle = .custom
        self.outlineView.intercellSpacing = NSSize(width: 0, height: 4)
//        self.outlineView.doubleAction = #selector(self.onOutlineViewDoubleClicked)
        self.outlineView.target = self
        self.outlineView.style = .plain
        self.outlineView.columnAutoresizingStyle = .lastColumnOnlyAutoresizingStyle
        self.outlineView.register(NSNib(nibNamed: "ProjectViewCell", bundle: nil), forIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ProjectViewCell"))
        self.outlineView.delegate = self
        self.outlineView.dataSource = self
        self.outlineView.reloadData()
        self.outlineView.font = StyleTheme.shared.font(for: .fontDefault)
        self.outlineView.indentationPerLevel = 15
        self.outlineView.indentationMarkerFollowsCell = true
        self.outlineView.intercellSpacing = NSSize(width: 5,height: 0)
        }
        
    public func update(aspect: String,with: Any?,from: Model)
        {
        if from.dependentKey == self.sharedProjectHolder.dependentKey && self.sharedProjectHolder.value.isNotNil
            {
            self.outlineView.reloadData()
            return
            }
        }
    }
        
extension ProjectHierarchyViewController: NSOutlineViewDelegate
    {
    @MainActor public func outlineViewSelectionDidChange(_ notification: Notification)
        {
        let row = self.outlineView.selectedRow
        let item:SourceNode? = row == -1 ? nil : self.outlineView.item(atRow: row) as? SourceNode
        self.sharedNodeHolder.retractInterest(of: self)
            {
            self.sharedNodeHolder.value = item
            }
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
        if let view = self.outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ProjectViewCell"), owner: nil) as? ProjectViewCell
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
        let rowIndex = self.outlineView.selectedRow
        guard rowIndex != -1 else
            {
            return
            }
        let element = self.outlineView.item(atRow: rowIndex) as! SourceNode
        if let string = (sender as? NSTextField)?.stringValue
            {
            element.setName(string)
            self.outlineView.reloadItem(element)
            }
        }
    }
    
extension ProjectHierarchyViewController: NSOutlineViewDataSource
    {
    @objc func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any
        {
        if item.isNil
            {
            return(self.sharedProjectHolder.value!)
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
