//
//  Project.swift
//  Argon
//
//  Created by Vincent Coetzee on 06/01/2023.
//

import Cocoa
import Path

public class SourceProjectNode: SourceCompositeNode
    {
    public override var pathToProject: Array<SourceNode>
        {
        [self]
        }
        
    public var moduleSearchPaths = Paths()
    public var buildPath:Path?
    
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
        
    public var allSourceFiles: Array<SourceFileNode>
        {
        return(self.allNodes.filter({$0.isSourceFileNode}).map({$0 as! SourceFileNode}))
        }
        
    public override var isProjectNode: Bool
        {
        true
        }
    }

