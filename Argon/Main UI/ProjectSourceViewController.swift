//
//  ProjectSourceViewController.swift
//  Argon
//
//  Created by Vincent Coetzee on 16/09/2023.
//

import Cocoa

class ProjectSourceViewController: NSViewController
    {
    public var sharedNodeHolder: ValueHolder!
    public var sharedProjectHolder: ValueHolder!
    
    @IBOutlet weak var sourceView: SourceCodeEditingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}
