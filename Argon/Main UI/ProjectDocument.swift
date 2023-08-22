//
//  Document.swift
//  Argon
//
//  Created by Vincent Coetzee on 2022/11/05.
//

import Cocoa

class ProjectDocument: NSDocument
    {
    private var projectState: ProjectState!
    private var project: SourceProjectNode?
    
    override init()
        {
        super.init()
        // Add your subclass-specific initialization here.
        }

    override class var autosavesInPlace: Bool
        {
        return true
        }

    override func makeWindowControllers()
        {
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        let windowController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("ProjectWindowController")) as! NSWindowController
        if let contentViewController = windowController.contentViewController as? ProjectViewController
            {
            contentViewController.windowWasCreated(window: windowController.window!)
            if let project = self.project
                {
                contentViewController.project = project
//                windowController.window?.setFrame(self.projectState.windowFrame,display: true,animate: true)
                }
            }
        self.addWindowController(windowController)
        }

    override func write(to url: URL,ofType: String) throws
        {
        var path = url.path
        if !path.hasSuffix(".argonp")
            {
            path += ".argonp"
            }
        let viewController = self.windowControllers[0].contentViewController as! ProjectViewController
        var state = viewController.projectState
        state.windowFrame = viewController.view.window!.frame
        if let data = try? NSKeyedArchiver.archivedData(withRootObject: state.project, requiringSecureCoding: false)
            {
            if (try? data.write(to: url)).isNil
                {
                throw(CompilerIssue(code: .couldNotWriteFile, message: "Unable to write to the file \(url.path)."))
                }
            }
        }
        
    override func read(from url: URL,ofType: String) throws
        {
        do
            {
            guard url.path.hasSuffix(".argonp") else
                {
                throw(CompilerIssue(code: .invalidFileType, message: "Argon can only open projects with a .argonp file extension."))
                }
            guard let data = try? Data(contentsOf: url) else
                {
                throw(CompilerIssue(code: .couldNotReadFile, message: "Argon can not read the file \(url.path)."))
                }
            guard let unarchiver = try? NSKeyedUnarchiver(forReadingFrom: data) else
                {
                throw(CompilerIssue(code: .fileDataIsCorrupt, message: "The file at \(url.path) is corrupt."))
                }
            unarchiver.requiresSecureCoding = false
            let aProject = unarchiver.decodeObject(of: SourceProjectNode.self, forKey: NSKeyedArchiveRootObjectKey)
            guard let aProject = aProject else
                {
                throw(CompilerIssue(code: .fileDataIsCorrupt, message: "The file at \(url.path) is corrupt."))
                }
            self.project = aProject
            }
        catch let error
            {
            Swift.print(error)
            }
        }
    }

