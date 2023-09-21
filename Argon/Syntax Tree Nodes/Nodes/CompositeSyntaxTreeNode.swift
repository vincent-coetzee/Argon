//
//  CompositeSymbol.swift
//  Argon
//
//  Created by Vincent Coetzee on 27/01/2023.
//

import Foundation

public class CompositeSyntaxTreeNode: SyntaxTreeNode
    {
    private var symbolTable: SymbolTable!
    
    init(name: String,parent: SyntaxTreeNode? = nil)
        {
        super.init(name: name)
        self.symbolTable = SymbolTable(parent: self)
        }
        
    public required init(coder: NSCoder)
        {
        self.symbolTable = coder.decodeObject(forKey: "symbolTable") as? SymbolTable
        super.init(coder: coder)
        }
        
    public override func addNode(_ symbol: SyntaxTreeNode)
        {
        self.symbolTable.addNode(symbol)
        symbol.setParent(self)
        }
        
    public override func lookupNode(atName someName: String) -> SyntaxTreeNode?
        {
        self.symbolTable.lookupNode(atName: someName)
        }
        
    public override func lookupMethods(atName someName: String) -> Methods
        {
        self.symbolTable.lookupMethods(atName: someName)
        }
        
    public override func accept(visitor: Visitor)
        {
        self.symbolTable.forEach
            {
            (symbol:SyntaxTreeNode) in
            symbol.accept(visitor: visitor)
            }
        }
        
    public func flush()
        {
        self.symbolTable.flush()
        }
        
    public override func dump(indent: String)
        {
        fatalError()
        }
    }
