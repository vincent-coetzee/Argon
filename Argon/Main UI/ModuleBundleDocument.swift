//
//  ModuleDocument.swift
//  Argon
//
//  Created by Vincent Coetzee on 19/07/2023.
//

import Cocoa

class ModuleBundleDocument: NSDocument
    {
    private var moduleBundle: ModuleBundle!
    
    override func makeWindowControllers()
        {
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        let windowController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("ModuleBundleWindowController")) as! NSWindowController
        if let contentViewController = windowController.contentViewController as? ModuleBundleViewController,let node = self.moduleBundle
            {
            contentViewController.moduleBundle = node
            }
        self.addWindowController(windowController)
        }

    override func windowControllerDidLoadNib(_ aController: NSWindowController)
        {
        super.windowControllerDidLoadNib(aController)
        // Add any code here that needs to be executed once the windowController has loaded the document's window.
        }

        
    public override func fileWrapper(ofType typeName: String) throws -> FileWrapper
        {
        fatalError()
        }
        
    public override func read(from fileWrapper: FileWrapper, ofType typeName: String) throws
        {
        }

    override class var autosavesInPlace: Bool
        {
        return true
        }
    }
