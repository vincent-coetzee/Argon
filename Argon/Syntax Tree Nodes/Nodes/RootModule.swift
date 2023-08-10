//
//  RootModule.swift
//  Argon
//
//  Created by Vincent Coetzee on 28/01/2023.
//

import Foundation

public class RootModule: Module
    {
    public static var rootModule: RootModule
        {
        Self._rootModule!
        }
        
    private static var _rootModule: RootModule?
        
    private var _argonModule: ArgonModule!
    
    public override var identifier: Identifier
        {
        Identifier(parts: [Identifier.IdentifierPart.root])
        }
        
    public override var module: Module
        {
        self
        }
        
    public override var rootModule: RootModule
        {
        self
        }
        
    public override var argonModule: ArgonModule
        {
        self._argonModule
        }
    
    public override func lookupNode(atName name: String) -> SyntaxTreeNode?
        {
        if let node = self.symbolTable.lookupNode(atName: name)
            {
            return(node)
            }
        return(self._argonModule.lookupNode(atName: name))
        }
        
    public func flush()
        {
        self.symbolTable.flush()
        self.symbolTable = SymbolTable()
        self.symbolTable.addNode(self.argonModule)
        }
        
    public override func lookupMethods(atName name: String) -> Methods
        {
        return(self._argonModule.lookupMethods(atName: name))
        }
        
    public static func resetRootModule()
        {
        self._rootModule = nil
        }
        
    @discardableResult
    public static func newRootModule() -> RootModule
        {
        if self._rootModule.isNil
            {
            let rootModule = RootModule(name: "")
            let module = ArgonModule.shared
            rootModule.setParent(nil)
            rootModule._argonModule = module
            rootModule.addNode(module)
            self._rootModule = rootModule
            module.initializeSystemMethods()
            return(rootModule)
            }
        else
            {
            return(self._rootModule!)
            }
        }
    }
