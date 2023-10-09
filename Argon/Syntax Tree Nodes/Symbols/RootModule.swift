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
public class RootModule: ModuleType
    {
    public static func reset()
        {
        Self.shared = RootModule(argonModule: ArgonModule.shared)
        }
        
    public private(set) static var shared: RootModule!
    
    public override var argonModule: ArgonModule
        {
        self.container as! ArgonModule
        }

    private var globallyInitialisedNodes = Symbols()
    
    public init(argonModule: ArgonModule)
        {
        super.init(name: "")
        Self.shared = self
        self.setContainer(argonModule)
        }
        
    public static func initializeRootModule(argonModule: ArgonModule)
        {
        let rootModule = RootModule(argonModule: argonModule)
        Self.shared = rootModule
        }
        
    public required init(coder: NSCoder)
        {
        super.init(coder: coder)
        }
        
    public required init(name: String,genericTypes: ArgonTypes)
        {
        super.init(name: name)
        self.setGenericTypes(genericTypes)
        }
        
    public override var isRootModule: Bool
        {
        true
        }

    public override var identifier: Identifier
        {
        Identifier.rootIdentifier
        }
        
    public override var module: ModuleType
        {
        self
        }
        
    public override var rootModule: RootModule
        {
        self
        }
        
    public override var parentModules: Modules
        {
        Modules()
        }
        
//    @discardableResult
//    public static func newRootModule() -> RootModule
//        {
//        if self._rootModule.isNil
//            {
//            let rootModule = RootModule()
////            let module = ArgonModule.shared
////            rootModule.setParent(nil)
////            rootModule._argonModule = module
////            rootModule.addNode(module)
////            self._rootModule = rootModule
//            rootModule.argonModule.initializeSystemMetaclasses()
//            rootModule.argonModule.initializeSystemMethods()
//            return(rootModule)
//            }
//        else
//            {
//            return(self._rootModule!)
//            }
//        }
        
    public func addGloballyInitialisedSymbol(_ node: Symbol)
        {
        self.globallyInitialisedNodes.append(node)
        }
        
    public override func accept(visitor: Visitor)
        {
        visitor.enter(rootModule: self)
        for symbol in self.symbols
            {
            symbol.accept(visitor: visitor)
            }
        visitor.exit(rootModule: self)
        }
    }
