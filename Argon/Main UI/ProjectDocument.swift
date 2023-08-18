//
//  Document.swift
//  Argon
//
//  Created by Vincent Coetzee on 2022/11/05.
//

import Cocoa

class ProjectDocument: NSDocument
    {
    private var project: SourceProjectNode? = nil
    private var outlinerWidth: CGFloat = 0
    
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
            if let node = self.project
                {
                contentViewController.project = node
                contentViewController.outlinerWidth = self.outlinerWidth
                }
            contentViewController.windowWasCreated(window: windowController.window!)
            }
        self.addWindowController(windowController)
        }

    override func write(to url: URL,ofType: String) throws
        {
        var path = url.path
        if !path.hasSuffix(".argp")
            {
            path += ".argp"
            }
        let aURL = URL(fileURLWithPath: path)
        let viewController = self.windowControllers[0].contentViewController as! ProjectViewController
        var state = ProjectState(project: viewController.project,outlinerWidth: viewController.outlinerWidth)
        if let data = try? NSKeyedArchiver.archivedData(withRootObject: state, requiringSecureCoding: false)
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
            guard url.path.hasSuffix(".argp") else
                {
                throw(CompilerIssue(code: .invalidFileType, message: "Argon can only open projects with a .argp file extension."))
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
            let state = unarchiver.decodeObject(of: ProjectState.self, forKey: NSKeyedArchiveRootObjectKey)
            guard let state = state else
                {
                throw(CompilerIssue(code: .fileDataIsCorrupt, message: "The file at \(url.path) is corrupt."))
                }
            self.project = state.project
            self.outlinerWidth = state.outlinerWidth
            }
        catch let error
            {
            Swift.print(error)
            }
        }
    }

