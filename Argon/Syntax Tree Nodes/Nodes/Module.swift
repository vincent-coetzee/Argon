//
//  Module.swift
//  Argon
//
//  Created by Vincent Coetzee on 27/01/2023.
//

import Foundation

public class Module: CompositeSyntaxTreeNode
    {
    public override var isModule: Bool
        {
        true
        }

    public override var nodeType: NodeType
        {
        return(.module)
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
        if let lastToken = parser.expect(tokenType: .identifier,error: .identifierExpected)
            {
            let moduleName = lastToken.identifier
            if let node = parser.lookupNode(atIdentifier: moduleName),node.isModule
                {
                parser.pushCurrentScope(node)
                if parser.isDeclaring
                    {
                    parser.addNode(node as! Self)
                    }
                }
            else
                {
                let module = Module(identifier: moduleName)
                if lastToken.identifier.isCompoundIdentifier
                    {
                    parser.lodgeIssue(phase: .declaration,code: .singleIdentifierExpected,location: location)
                    }
                else
                    {
                    parser.pushCurrentScope(module)
                    defer
                        {
                        parser.popCurrentScope()
                        }
                    self.parseModuleContents(using: parser,into: module)
                    }
                parser.addNode(module)
                }
            }
        else
            {
            let module = Module(name: "Bad Module")
            parser.lodgeIssue(phase: .declaration,code: .identifierExpected,location: location)
            if parser.isDeclaring
                {
                parser.addNode(module)
                }
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
                    case(.CLASS):
                        ClassType.parse(using: parser)
                    case(.METHOD):
                        Method.parse(using: parser)
                    case(.TYPE):
                        AliasedType.parse(using: parser)
                    case(.MODULE):
                        Module.parse(using: parser)
                    case(.FUNCTION):
                        Function.parse(using: parser)
                    case(.ENUMERATION):
                        EnumerationType.parse(using: parser)
                    default:
                        parser.lodgeIssue(phase: .declaration,code: .moduleEntryExpected,location: location)
                    }
                }
            }
        }
        
    public override func addNode(_ symbol: SyntaxTreeNode)
        {
        self.containedNodes.append(symbol)
        symbol.setParent(self)
        symbol.setModule(self)
        }
    }

