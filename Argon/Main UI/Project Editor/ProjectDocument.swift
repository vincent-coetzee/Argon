//
//  Document.swift
//  Argon
//
//  Created by Vincent Coetzee on 2022/11/05.
//

import Cocoa

class ProjectDocument: NSDocument
    {
    private let projectModel = ValueHolder(value: IDEProjectNode(name: "Untitled",path: .homePath(withFileNamed: "Untitled.argonp")))
    private let selectedNodeModel = ValueHolder(value: nil)
    
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
        let windowController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("ProjectWindowController")) as! ProjectWindowController
        self.addWindowController(windowController)
        windowController.initWindowController(projectModel: self.projectModel, selectedNodeModel: self.selectedNodeModel)
        }
        
    override func fileWrapper(ofType typeName: String) throws -> FileWrapper
        {
        guard let project = self.projectModel.value as? IDEProjectNode else
            {
            fatalError()
            }
        return(project.containerFileWrapper)
        }
        
//    public override func save(_ sender: Any?)
//        {
//        super.save(sender)
//        }
        
    public override nonisolated func read(from fileWrapper: FileWrapper, ofType typeName: String) throws
        {
        guard fileWrapper.isDirectory,let wrappers = fileWrapper.fileWrappers else
            {
            throw(CompilerError(code: .couldNotReadFile, message: "The project \(fileWrapper.filename!) could not be read."))
            }
        guard let dataWrapper = wrappers[Argon.projectStateFilename] else
            {
            throw(CompilerError(code: .fileDataIsCorrupt, message: "The project \(fileWrapper.filename!) is corrupt and can not be read."))
            }
        guard let data = dataWrapper.regularFileContents,let unarchiver = try? NSKeyedUnarchiver(forReadingFrom: data) else
            {
            throw(CompilerError(code: .fileDataIsCorrupt, message: "The file at \(dataWrapper.filename!) is corrupt amd can not be read."))
            }
        unarchiver.requiresSecureCoding = false
        guard let project = unarchiver.decodeObject(of: IDEProjectNode.self, forKey: NSKeyedArchiveRootObjectKey) else
            {
            throw(CompilerError(code: .fileDataIsCorrupt, message: "The project \(dataWrapper.filename!) is corrupt amd can not be read."))
            }
        self.projectModel.value = project
        }
    
//    override func write(to url: URL,ofType: String) throws
//        {
//        var path = url.path
//        if !path.hasSuffix(".argonp")
//            {
//            path += ".argonp"
//            }
//        if let data = try? NSKeyedArchiver.archivedData(withRootObject: self.projectModel.value!, requiringSecureCoding: false)
//            {
//            if (try? data.write(to: url)).isNil
//                {
//                throw(CompilerIssue(code: .couldNotWriteFile, message: "Unable to write to the file \(url.path)."))
//                }
//            }
//        for controller in self.windowControllers
//            {
//            (controller as? ProjectWindowController)?.saveContents()
//            }
//        }
        
//    override func read(from url: URL,ofType: String) throws
//        {
//        do
//            {
//            guard url.path.hasSuffix(".argonp") else
//                {
//                throw(CompilerIssue(code: .invalidFileType, message: "Argon can only open projects with a .argonp file extension."))
//                }
//            guard let data = try? Data(contentsOf: url) else
//                {
//                throw(CompilerIssue(code: .couldNotReadFile, message: "Argon can not read the file \(url.path)."))
//                }
//            guard let unarchiver = try? NSKeyedUnarchiver(forReadingFrom: data) else
//                {
//                throw(CompilerIssue(code: .fileDataIsCorrupt, message: "The file at \(url.path) is corrupt."))
//                }
//            unarchiver.requiresSecureCoding = false
//            let aProject = unarchiver.decodeObject(of: SourceProjectNode.self, forKey: NSKeyedArchiveRootObjectKey)
//            guard let aProject = aProject else
//                {
//                throw(CompilerIssue(code: .fileDataIsCorrupt, message: "The file at \(url.path) is corrupt."))
//                }
//            self.projectModel.value = aProject
//            }
//        catch let error
//            {
//            Swift.print(error)
//            }
//        }
    }

