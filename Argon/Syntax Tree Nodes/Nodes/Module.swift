//
//  Module.swift
//  Argon
//
//  Created by Vincent Coetzee on 27/01/2023.
//

import Foundation

public class Module: CompositeSyntaxTreeNode
    {
    public override var encoding: String
        {
        let encodedName = self.parentModules.map{$0.name.base64Hash}.joined(separator: "")
        return("v\(encodedName)_")
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
        (self.parent.isNil ? Modules() : self.parent!.parentModules).appending(self)
        }
        
    public class func parseModuleDependency(using parser: ArgonParser) -> ModuleNode?
        {
        parser.nextToken()
        guard parser.token.isIdentifier else
            {
            return(nil)
            }
        let name = parser.token.identifier.description
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
                    parser.lodgeIssue(code: .identifierAlreadyDefined,location: location)
                    return(Module(name: Argon.nextIndex(named: "MODULE_")))
                    }
                }
            else
                {
                let module = Module(name: moduleName)
                parser.addNode(module)
                if lastToken.identifier.isCompoundIdentifier
                    {
                    parser.lodgeIssue(code: .moduleNameExpected,location: location)
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
                        parser.lodgeIssue(code: .moduleEntryExpected,location: location)
                    }
                }
            }
        }
        
    public override func accept(visitor: Visitor)
        {
        super.accept(visitor: visitor)
        visitor.enter(module: self)
        for entry in self.symbolEntries.values
            {
            if let node = entry.node
                {
                node.accept(visitor: visitor)
                }
            for method in entry.methods
                {
                method.accept(visitor: visitor)
                }
            }
        visitor.exit(module: self)
        }
    }

public typealias Modules = Array<Module>


