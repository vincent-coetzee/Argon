//
//  MethodType.swift
//  Argon
//
//  Created by Vincent Coetzee on 21/09/2023.
//

import Foundation

public enum OperatorNotation
    {
    case prefix
    case infix
    case postfix
    }
    
public class MethodType: InvokableType
    {
    public var signature: MethodSignature
        {
        MethodSignature(name: self.name,parameterTypes: parameters.map{$0.symbolType},returnType: returnType)
        }
        
    public override class func parse(using parser: ArgonParser)
        {
        let location = parser.token.location
        let name = parser.parseIdentifier(errorCode: .identifierExpected).lastPart
        var parameters = Parameters()
        parser.parseParentheses
            {
            while !parser.token.isEnd && !parser.token.isRightParenthesis
                {
                parser.parseComma()
                parameters.append(parser.parseParameter())
                }
            }
        let block = Block()
        block.location = location
        for parameter in parameters
            {
            block.addLocal(parameter)
            }
        var returnType: ArgonType?
        if parser.token.isRightArrow
            {
            parser.nextToken()
            returnType = parser.parseType()
            }
        Block.parseBlockInner(block: block, using: parser)
        let method = MethodType(name: name)
        method.location = location
        method.setParameters(parameters)
        method.setBlock(block)
        method.setReturnType(returnType)
        parser.currentScope.addSymbol(method)
        }
        
    public override var description: String
        {
        let returnName = self.returnType.name
        let parameterName = self.parameters.map{$0.description}.joined(separator: ",")
        return("\(self.name)(\(parameterName)) -> \(returnName)")
        }
        
    public private(set) var block = Block()
    public var operatorNotation: OperatorNotation = .infix
    public var isOperator = false
    
    public override var isMethod: Bool
        {
        return(true)
        }
        
    public override var valueBox: ValueBox
        {
        .method(self)
        }
        
    public override init(name: String)
        {
        super.init(name: name)
        }
        
    public required init(coder: NSCoder)
        {
        self.block = coder.decodeObject(forKey: "block") as! Block
        self.operatorNotation = coder.decodeOperatorNotation(forKey: "operatorNotation")
        self.isOperator = coder.decodeBool(forKey: "isOperator")
        super.init(coder: coder)
        }
        
    public override func encode(with coder: NSCoder)
        {
        coder.encode(self.block,forKey: "block")
        coder.encode(self.operatorNotation,forKey: "operatorNotation")
        coder.encode(self.isOperator,forKey: "isOperator")
        super.encode(with: coder)
        }

    public func setBlock(_ block: Block)
        {
        self.block = block
        block.setContainer(self)
        }
        
    public override func accept(visitor: Visitor)
        {
        visitor.enter(method: self)
        visitor.visit(block: self.block)
        visitor.exit(method: self)
        }
        
    public override var astLabel: String
        {
        "MethodType \(self.name) \(self.signature.description)"
        }
        
    public override var astChildSymbols: Symbols
        {
        []
        }
    }

public typealias Methods = Array<MethodType>

extension Methods
    {
    public init(_ method: MethodType)
        {
        self.init()
        self.append(method)
        }
        
    public func accept(visitor: Visitor)
        {
        for method in self
            {
            method.accept(visitor: visitor)
            }
        }
    
    public func appending(contentsOf methods: Methods?) -> Self
        {
        guard let methods = methods else
            {
            return(self)
            }
        var newMethods = self
        for method in methods
            {
            newMethods.append(method)
            }
        return(newMethods)
        }
    }

extension NSCoder
    {
    public func encode(_ notation: OperatorNotation,forKey key: String)
        {
        switch(notation)
            {
            case .infix:
                self.encode(0,forKey: key + "notation")
            case .prefix:
                self.encode(1,forKey: key + "notation")
            case .postfix:
                self.encode(2,forKey: key + "notation")
            }
        }
        
    public func decodeOperatorNotation(forKey key: String) -> OperatorNotation
        {
        switch(self.decodeInteger(forKey: key + "notation"))
            {
            case(0):
                return(.infix)
            case(1):
                return(.prefix)
            case(2):
                return(.postfix)
            default:
                fatalError("This should never happen.")
            }
        }
    }
