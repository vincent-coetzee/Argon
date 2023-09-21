//
//  CompositeProjectElement.swift
//  Argon
//
//  Created by Vincent Coetzee on 18/02/2023.
//

import Foundation
import Path

public class SourceCompositeNode: SourceNode
    {
    public var nodes: Array<SourceNode>
    
    public override var allNodes: Array<SourceNode>
        {
        var someElements = Array<SourceNode>()
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
        self.nodes = coder.decodeObject(forKey: "nodes") as! Array<SourceNode>
        super.init(coder: coder)
        }
        
    public override func encode(with coder: NSCoder)
        {
        coder.encode(self.nodes,forKey: "nodes")
        super.encode(with: coder)
        }
        
    public override func child(atIndex: Int) -> SourceNode?
        {
        if atIndex < 0 || atIndex >= nodes.count
            {
            return(nil)
            }
        return(nodes[atIndex])
        }
        
    public override func addNode( _ element: SourceNode)
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
