//
//  CompositeProjectElement.swift
//  Argon
//
//  Created by Vincent Coetzee on 18/02/2023.
//

import Foundation
import Path

public class IDECompositeNode: IDENode
    {
    public var nodes: Array<IDENode>
    
    public override var nodeType: IDENodeType
        {
        .compositeNode
        }
        
    public override var fileWrapper: (String,FileWrapper)
        {
        let allWrappers = self.nodes.map{$0.fileWrapper}
        var wrappers = Dictionary<String,FileWrapper>()
        for (name,wrapper) in allWrappers
            {
            wrappers[name] = wrapper
            }
        return((self.name,FileWrapper(directoryWithFileWrappers: wrappers)))
        }
        
    public override var allNodes: Array<IDENode>
        {
        var someElements = Array<IDENode>()
        for element in self.nodes
            {
            someElements.append(element)
            someElements.append(contentsOf: element.allNodes)
            }
        someElements.append(self)
        return(someElements)
        }
        
    public override var actionSet: BrowserActionSet
        {
        super.actionSet.enabling(.newFileAction,.newFolderAction,.importAction)
        }
        
    public override var isCompositeNode: Bool
        {
        true
        }
        
    public override var childCount: Int
        {
        self.nodes.count
        }
    
    public override var isExpandable: Bool
        {
        !self.nodes.isEmpty
        }
        
    public override init(name: String,path: Path)
        {
        self.nodes = []
        super.init(name: name,path: path)
        }
        
    public required init?(coder: NSCoder)
        {
        self.nodes = coder.decodeObject(forKey: "nodes") as! Array<IDENode>
        super.init(coder: coder)
        }
        
    public override func encode(with coder: NSCoder)
        {
        coder.encode(self.nodes,forKey: "nodes")
        super.encode(with: coder)
        }
        
    public override func child(atIndex: Int) -> IDENode?
        {
        if atIndex < 0 || atIndex >= nodes.count
            {
            return(nil)
            }
        return(nodes[atIndex])
        }
        
//    public override func saveContents()
//        {
//        for node in self.nodes
//            {
//            node.saveContents()
//            }
//        }
        
    public override func addNode( _ element: IDENode)
        {
        self.nodes.append(element)
        element.setParent(self)
        }
        
    public override func sortNodes()
        {
        for node in self.nodes
            {
            node.sortNodes()
            }
        self.nodes = self.nodes.sorted()
        }
    }