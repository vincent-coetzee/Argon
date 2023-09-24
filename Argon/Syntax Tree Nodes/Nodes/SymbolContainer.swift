//
//  SymbolHolder.swift
//  Argon
//
//  Created by Vincent Coetzee on 24/09/2023.
//

import Foundation

public protocol Context
    {
    var rootModule: RootModule { get }
    var argonModule: ArgonModule { get }
    var symbolTable: SymbolTable? { get }
    func addNode(_ node: SyntaxTreeNode)
    func lookupNode(atName: String) -> SyntaxTreeNode?
    func lookupMethods(atName: String) -> Methods
    func lookupNode(atIdentifier: Identifier) -> SyntaxTreeNode?
    func lookupMethods(atIdentifier: Identifier) -> Methods
    }
    
extension Context
    {
//    public func addNode(_ node: SyntaxTreeNode)
//        {
//        self.symbolTable?.addSymbol(node)
//        }
        
    public func addSymbol(_ node: SyntaxTreeNode)
        {
        self.symbolTable?.addSymbol(node)
        }
        
    public func lookupNode(atName: String) -> SyntaxTreeNode?
        {
        self.symbolTable?.lookupSymbol(atName: atName)
        }
        
    public func lookupNode(atIdentifier: Identifier) -> SyntaxTreeNode?
        {
        self.symbolTable?.lookupSymbol(atIdentifier: atIdentifier)
        }
        
    public func lookupSymbol(atName: String) -> SyntaxTreeNode?
        {
        self.symbolTable?.lookupSymbol(atName: atName)
        }
        
    public func lookupMethods(atName: String) -> Methods
        {
        self.symbolTable?.lookupMethods(atName: atName)  ?? Methods()
        }
        
    public func lookupMethods(atIdentifier: Identifier) -> Methods
        {
        self.symbolTable?.lookupMethods(atIdentifier: atIdentifier) ?? Methods()
        }
    }
    
