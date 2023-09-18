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
    public var sharedNodeHolder: ValueHolder!
    public var sharedProjectHolder: ValueHolder!
    
    override func viewDidLoad()
        {
        super.viewDidLoad()
        // Do view setup here.
        }
    }
