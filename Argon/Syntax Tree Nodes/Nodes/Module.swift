//
//  Module.swift
//  Argon
//
//  Created by Vincent Coetzee on 27/01/2023.
//

import Foundation

public class Module: CompositeSyntaxTreeNode
    {
    public var hasMainMethod: Bool
        {
        self.mainMethod.isNotNil
        }
        
    public var mainMethod: MethodType?
        {
        for entry in self.symbolEntries.values
            {
            for method in entry.methods
                {
                if method.name == "main"
                    {
                    return(method)
                    }
                }
            }
        return(nil)
        }
        
    public override var module: Module
        {
        self
        }
        
    public override var isModule: Bool
        {
        true
        }
        
    public override var nodeType: NodeType
        {
        return(.module)
        }
        
    public override var parentModules: Modules
        {
        self.parent.parentModules.appending(self)
        }
        
    public class func parseModuleDependency(using parser: ArgonParser) -> ModuleNode?
        {
        parser.nextToken()
        guard parser.token.isIdentifier else
            {
            return(nil)
            }
//        let name = parser.token.identifier.description
        parser.nextToken()
//        while !parser.token.isImport && !parser.token.isEnd
        fatalError()
        }
        
    public class override func parse(using parser: ArgonParser)
        {
        let location = parser.token.location
        parser.nextToken()
        let module = self.parseForModule(using: parser,location: location)
        parser.pushCurrentScope(module)
        defer
            {
            parser.popCurrentScope()
            }
        self.parseModuleContents(using: parser,into: module)
        }
        
    private class func parseForModule(using parser: ArgonParser,location: Location) -> Module
        {
        if let lastToken = parser.expect(tokenType: .identifier,error: .moduleNameExpected)
            {
            let moduleName = lastToken.identifier.lastPart
            if let node = parser.lookupNode(atName: moduleName)
                {
                if node.isModule
                    {
                    return(node as! Module)
                    }
                else
                    {
                    parser.lodgeError(code: .identifierAlreadyDefined,location: location)
                    return(Module(name: Argon.nextIndex(named: "MODULE_")))
                    }
                }
            else
                {
                let module = Module(name: moduleName)
                parser.addNode(module)
                if lastToken.identifier.isCompoundIdentifier
                    {
                    parser.lodgeError(code: .moduleNameExpected,location: location)
                    }
                return(module)
                }
            }
        else
            {
            return(Module(name: Argon.nextIndex(named: "MODULE_")))
            }
        }
        
    private class func parseModuleContents(using parser: ArgonParser,into module: Module)
        {
        let location = parser.token.location
        module.location = location
        if parser.expect(tokenType: .leftBrace, error: .leftBraceExpected).isNotNil
            {
            while !parser.token.isRightBrace
                {
                switch(parser.token.tokenType)
                    {
                    case(.LET):
                        LetStatement.parse(using: parser)
                    case(.CONSTANT):
                        Constant.parse(using: parser)
                    case(.CLASS):
                        ClassType.parse(using: parser)
                    case(.METHOD):
                        MethodType.parse(using: parser)
                    case(.TYPE):
                        AliasedType.parse(using: parser)
                    case(.MODULE):
                        Module.parse(using: parser)
                    case(.FUNCTION):
                        FunctionType.parse(using: parser)
                    case(.ENUMERATION):
                        EnumerationType.parse(using: parser)
                    default:
                        parser.lodgeError(code: .moduleEntryExpected,location: location)
                    }
                }
            }
        }
    //
    //
    // When visiting a regular module we visit
    // both the node of the entry and the methods
    // of the entry. In the case of an ArgonModule
    // accept does nothing because system classes and
    // methods do not need to be visited. In the case
    // of a RootModule only the nodes are visited
    // because there should not be any methods in the
    // RootModule.
    //
    public override func accept(visitor: Visitor)
        {
        visitor.enter(module: self)
        for entry in self.symbolEntries.values
            {
            entry.node?.accept(visitor: visitor)
            for method in entry.methods
                {
                method.accept(visitor: visitor)
                }
            }
        visitor.exit(module: self)
        }
        
    public func validateMethodUniqueness(semanticChecker: ArgonSemanticChecker)
        {
        let methods = self.symbolEntries.values.flatMap{$0.methods}
        for method in methods
            {
            for innerMethod in methods.removing(method)
                {
                if innerMethod.signature == method.signature
                    {
                    semanticChecker.lodgeError(code: .methodWithDuplicateSignature, location: method.location!,message: "Duplicate method '\(method.name)' with signature \(method.signature)")
                    }
                }
            }
        for module in self.symbolEntries.values.compactMap({$0.node as? Module})
            {
            module.validateMethodUniqueness(semanticChecker: semanticChecker)
            }
        }
    }

public typealias Modules = Array<Module>
