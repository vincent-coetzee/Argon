//
//  SymbolTable.swift
//  Argon
//
//  Created by Vincent Coetzee on 11/01/2023.
//

import Foundation

public typealias SymbolDictionary = Dictionary<String,SyntaxTreeNode>

public protocol Scope: AnyObject
    {
    var rootModule: RootModule { get }
    var argonModule: ArgonModule { get }
    func addNode(_ symbol: SyntaxTreeNode)
    func lookupMethods(atName: String) -> Methods
    func lookupNode(atName: String) -> SyntaxTreeNode?
    func lookupMethods(atIdentifier: Identifier) -> Methods
    func lookupNode(atIdentifier: Identifier) -> SyntaxTreeNode?
    }
    
public extension Scope
    {
    var argonModule: ArgonModule
        {
        self.rootModule.argonModule
        }
    }
