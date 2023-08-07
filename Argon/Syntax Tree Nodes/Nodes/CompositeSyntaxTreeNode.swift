//
//  CompositeSymbol.swift
//  Argon
//
//  Created by Vincent Coetzee on 27/01/2023.
//

import Foundation
    
public class CompositeSyntaxTreeNode: SyntaxTreeNode,Scope
    {
    internal let symbolTable = SymbolTable()
    
    public func addNode(_ symbol: SyntaxTreeNode)
        {
        self.symbolTable.addNode(symbol)
        symbol.setParent(self)
        NodeChangeSet.currentChangeSet.insert(symbol)
        }
        
    public override func lookupNode(atName name: String) -> SyntaxTreeNode?
        {
        if let node = self.symbolTable.lookupNode(atName: name)
            {
            return(node)
            }
        return(self.parent?.lookupNode(atName: name))
        }
        
    public override func lookupMethods(atName name: String) -> Methods
        {
        let methods = self.symbolTable.lookupMethods(atName: name)
        if !methods.isEmpty
            {
            return(methods)
            }
        if self.parent.isNil
            {
            return(Methods())
            }
        return(self.parent!.lookupMethods(atName: name))
        }
        
    public override func dump(indent: String)
        {
        fatalError()
        }
    }
