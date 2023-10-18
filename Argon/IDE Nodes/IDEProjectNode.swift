//
//  Project.swift
//  Argon
//
//  Created by Vincent Coetzee on 06/01/2023.
//

import AppKit
import Path

public class IDEProjectNode: IDECompositeNode
    {
    public override var nodeType: IDENodeType
        {
        .projectNode
        }
        
    public var containerFileWrapper: FileWrapper
        {
        let allWrappers = self.nodes.map{$0.fileWrapper}
        var wrappers = Dictionary<String,FileWrapper>()
        for (name,wrapper) in allWrappers
            {
            wrappers[name] = wrapper
            }
        if let data = try? NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
            {
            wrappers[Argon.projectStateFilename] = FileWrapper(regularFileWithContents: data)
            return(FileWrapper(directoryWithFileWrappers: wrappers))
            }
        fatalError()
        }
        
    public override var pathToProject: Array<IDENode>
        {
        [self]
        }
        
    public var moduleSearchPaths = Paths()
    public var buildPath:Path?
    
    public override var actionSet: BrowserActionSet
        {
        super.actionSet.enabling(.loadAction,.saveAction,.cleanAction,.runAction,.buildAction,.debugAction)
        }
        
    public override var projectViewImage: NSImage
        {
        NSImage(named: "IconProject")!
        }
        
    public override init(name: String,path: Path)
        {
        super.init(name: name,path: path)
        }
        
    public required init?(coder: NSCoder)
        {
        self.moduleSearchPaths = coder.decodePaths(forKey: "moduleSearchPaths")
        self.buildPath = coder.decodePath(forKey: "buildPath")
        super.init(coder: coder)
        }
        
    public override func encode(with coder: NSCoder)
        {
        coder.encode(self.moduleSearchPaths,forKey: "moduleSearchPaths")
        coder.encode(self.buildPath,forKey: "buildPath")
        super.encode(with: coder)
        }
        
    public var allSourceFiles: Array<IDESourceFileNode>
        {
        return(self.allNodes.filter({$0.isSourceFileNode}).map({$0 as! IDESourceFileNode}))
        }
        
    public override var isProjectNode: Bool
        {
        true
        }
    }

