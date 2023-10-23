//
//  ProjectElement.swift
//  Argon
//
//  Created by Vincent Coetzee on 18/02/2023.
//

import AppKit
import Path

public enum IDENodeType
    {
    case node
    case compositeNode
    case fileNode
    case folderNode
    case projectNode
    case visualDesignNode
    case visualInterfaceNode
    }
    
public class IDENode: NSObject,NSCoding,Comparable,Dependent
    {
    public static func < (lhs: IDENode, rhs: IDENode) -> Bool
        {
        lhs.name < rhs.name
        }
        
    public var nodeType: IDENodeType
        {
        .node
        }
        
    public var hasUnsavedChanges: Bool
        {
        false
        }
    
    public var actionSet: BrowserActionSet
        {
        BrowserActionSet(withEnabled: .deleteAction)
        }
        
    public var filename: String
        {
        self.name
        }
        
    public var sourceKey: Int
        {
        self.path.polynomialRollingHash
        }

    public var compilerIssues: CompilerIssues
        {
        fatalError("compilerIssues sent to SourceNode and should not have been.")
        }
        
    public var isSourceFileNode: Bool
        {
        false
        }
        
    public var isFolderNode: Bool
        {
        false
        }
        
    public var isCompositeNode: Bool
        {
        false
        }
        
    public var isExpandable: Bool
        {
        false
        }
        
    public var isProjectNode: Bool
        {
        false
        }
        
    public var childCount: Int
        {
        return(0)
        }
        
    public var projectViewImage: NSImage
        {
        fatalError()
        }

    public var pathToProject: Array<IDENode>
        {
        var someNodes: Array<IDENode> = [self]
        someNodes.append(contentsOf: self.parent?.pathToProject ?? [])
        return(someNodes)
        }
        
    public var allNodes: Array<IDENode>
        {
        []
        }

    public var title: String
        {
        self.name
        }
        
    public var fileWrapper: (String,FileWrapper)
        {
        fatalError()
        }
        
    public var dependentKey = DependentSet.nextDependentKey
    
    public private(set) var name: String
    public private(set) var path: Path
    public private(set) var nodeKey: Int = 0
    public private(set) weak var parent: IDENode?
    public private(set) var isNewFile = false
    public private(set) var sourceItemState: IDESourceItemState = IDESourceItemState(rawValue: 0)
    
    public init(name: String,path: Path)
        {
        self.name = name
        self.path = path
        self.nodeKey = Argon.nextIndex
        self.sourceItemState = IDESourceItemState.kAdded
        }
        
    public required init?(coder: NSCoder)
        {
        self.parent = coder.decodeObject(forKey: "parent") as? IDENode
        self.name = coder.decodeObject(forKey: "name") as! String
        self.path = coder.decodePath(forKey: "path")!
        self.nodeKey = coder.decodeInteger(forKey: "nodeKey")
        self.sourceItemState = IDESourceItemState(rawValue: UInt8(coder.decodeInteger(forKey: "sourceItemState")))
        }
        
    public func encode(with coder: NSCoder)
        {
        coder.encode(self.parent,forKey: "parent")
        coder.encode(self.name,forKey: "name")
        coder.encode(self.path,forKey: "path")
        coder.encode(self.nodeKey,forKey: "nodeKey")
        coder.encode(self.sourceItemState.rawValue,forKey: "sourceItemState")
        }
    
    public func clearUnsavedChanges()
        {
        }
        
    public func setIsNewFile(_ boolean: Bool)
        {
        self.isNewFile = boolean
        }
        
    public func setParent(_ parent: IDENode)
        {
        self.parent = parent
        }
        
    public func setName(_ name: String)
        {
        self.name = name
        }
        
    public func update(aspect: String,with: Any?,from: Model)
        {
        if aspect == "source"
            {
            self.setSource(with as! String)
            }
        }
        
//    public func saveContents()
//        {
//        }
        
    public func setSource(_ string: String)
        {
        fatalError("setSource called on SourceNode and should not be.")
        }
        
    public func child(atIndex: Int) -> IDENode?
        {
        return(nil)
        }
        
    public func addNode( _ element: IDENode)
        {
        }
        
    public func sortNodes()
        {
        }
        
    public func setTokens(_ tokens: Tokens)
        {
        }
        
    public func visit(visitor: Visitor)
        {
        }
        
    public func installEditor(in view: NSView)
        {
        }
        
    public func configureEditor(in controller: ProjectSourceViewController)
        {
        }
        
    public func removeChildNode(_ node: IDENode)
        {
        fatalError("This should not happen.")
        }
        
    public func removeFromParentNode()
        {
        self.parent?.removeChildNode(self)
        }
    }

public typealias IDENodes = Array<IDENode>
