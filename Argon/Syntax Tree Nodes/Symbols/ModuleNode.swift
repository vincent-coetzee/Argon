//
//  ModuleNode.swift
//  Argon
//
//  Created by Vincent Coetzee on 16/07/2023.
//

import Foundation

//
//
// These classes are used in dependency analysis when
// loading dependent and independent modules.
//
//
public class ModuleEdge
    {
    private let from: ModuleNode
    private let to: ModuleNode
    
    init(from: ModuleNode,to: ModuleNode)
        {
        self.from = from
        self.to = to
        }
    }
    
public typealias ModuleEdges = Array<ModuleEdge>
    
public class ModuleNode
    {
    private let name: String
    private var edges = ModuleEdges()
    
    init(name: String)
        {
        self.name = name
        }
        
    func addEdge(_ edge: ModuleEdge)
        {
        self.edges.append(edge)
        }
    }
