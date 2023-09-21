//
//  RootModule.swift
//  Argon
//
//  Created by Vincent Coetzee on 28/01/2023.
//

import Foundation

//
//
// The RootModule, of whihc there is only one in the system,
// is the top Module in any Module inheritance chain. Modules
// inherit the symbols defined in the Modules that contain them.
// If the compiler is looking for a symbol if it can not find it in the
// the current Module it will search up the Module chain until it finds the symbol
// or it hits the RootModule. The RootModule will then search the ArgonModule and
// if the symbol still can not be found in the ArgonModule the search will terminate and
// return "nil" to indicate the symbol is not defined in the Module mesh.
//
//
public class RootModule: Module
    {
//    public static var shared: RootModule
//        {
//        Self._rootModule!
//        }
//        
    public override var argonModule: ArgonModule
        {
        self._argonModule
        }
        
    private static var _rootModule: RootModule?
        
    public var _argonModule: ArgonModule!
    private var globallyInitialisedNodes = SyntaxTreeNodes()
    
    public init(name: String)
        {
        let someModule = ArgonModule(name: "Argon")
        super.init(name: name,parent: someModule)
        self._argonModule = someModule
        }
        
    public required init(coder: NSCoder)
        {
        self._argonModule = ArgonModule(name: "Argon")
        super.init(coder: coder)
        self.setParent(self._argonModule)
        }
        
    public override var isRootModule: Bool
        {
        true
        }

    public override var identifier: Identifier
        {
        Identifier(parts: [Identifier.IdentifierPart.root])
        }
        
    public override var module: Module
        {
        self
        }

    public override var parentModules: Modules
        {
        Modules()
        }
        
    public override var rootModule: RootModule
        {
        self
        }
//    
//    public override func lookupNode(atName someName: String) -> SyntaxTreeNode?
//        {
//        }
        
    public func flush()
        {
        self.symbolTable.flush()
        }
        
    public override func lookupMethods(atName name: String) -> Methods
        {
        return(self.argonModule.lookupMethods(atName: name))
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
//            let module = ArgonModule.shared
//            rootModule.setParent(nil)
//            rootModule._argonModule = module
//            rootModule.addNode(module)
//            self._rootModule = rootModule
            rootModule.argonModule.initializeSystemMetaclasses()
            rootModule.argonModule.initializeSystemMethods()
            return(rootModule)
            }
        else
            {
            return(self._rootModule!)
            }
        }
        
    public func addGloballyInitialisedNode(_ node: SyntaxTreeNode)
        {
        self.globallyInitialisedNodes.append(node)
        }
        
    public override func accept(visitor: Visitor)
        {
        visitor.enter(rootModule: self)
        for entry in self.symbolEntries.values
            {
            entry.node?.accept(visitor: visitor)
            }
        visitor.exit(rootModule: self)
        }
    }
