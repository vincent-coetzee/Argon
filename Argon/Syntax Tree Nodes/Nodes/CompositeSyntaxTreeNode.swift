//
//  CompositeSymbol.swift
//  Argon
//
//  Created by Vincent Coetzee on 27/01/2023.
//

import Foundation
    
public class CompositeSyntaxTreeNode: SyntaxTreeNode
    {
    internal var symbolTable = SymbolTable()
    
    public override func addNode(_ symbol: SyntaxTreeNode)
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
        var methods = self.parent!.lookupMethods(atName: name)
        methods.append(contentsOf: self.symbolTable.lookupMethods(atName: name))
        if !methods.isEmpty
            {
            return(methods)
            }
        return(Methods())
        }
        
    public override func dump(indent: String)
        {
        fatalError()
        }
    }
