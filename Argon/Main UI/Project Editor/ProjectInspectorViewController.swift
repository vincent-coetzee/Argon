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
    
    override func viewDidLoad()
        {
        super.viewDidLoad()
        }
        
    public func handleMenuItem(_ menuItem: NSMenuItem) -> Bool
        {
        return(false)
        }
        
    public func validateMenuItem(_ menuItem: NSMenuItem) -> Bool
        {
        return(false)
        }
    }
