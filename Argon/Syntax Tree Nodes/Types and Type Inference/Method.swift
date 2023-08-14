//
//  Method.swift
//  Argon
//
//  Created by Vincent Coetzee on 05/07/2023.
//

import Foundation

public class Method: CallableTypeNode
    {
    public var signature: MethodSignature
        {
        MethodSignature(name: self.name,parameterTypes: parameters.map{$0.type},returnType: returnType)
        }
        
    public override class func parse(using parser: ArgonParser)
        {
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
        for parameter in parameters
            {
            block.addLocal(parameter)
            }
        var returnType: TypeNode?
        if parser.token.isRightArrow
            {
            parser.nextToken()
            returnType = parser.parseType()
            }
        Block.parseBlockInner(block: block, using: parser)
        let method = Method(name: name)
        method.setParameters(parameters)
        method.setBlock(block)
        method.setReturnType(returnType)
        parser.currentScope.addNode(method)
        }
        
    public private(set) var parameters = Parameters()
    public private(set) var returnType: TypeNode?
    public private(set) var block = Block()
    
    public override var isMethod: Bool
        {
        return(true)
        }
        
    public override var valueBox: ValueBox
        {
        .method(self)
        }
        
    public init(name: String)
        {
        super.init(name: name)
        }
        
    public required init(coder: NSCoder)
        {
        self.parameters = coder.decodeObject(forKey: "parameters") as! Parameters
        self.returnType = coder.decodeObject(forKey: "returnType") as? TypeNode
        self.block = coder.decodeObject(forKey: "block") as! Block
        super.init(coder: coder)
        }
        
    public override func encode(with coder: NSCoder)
        {
        coder.encode(self.parameters,forKey: "parameters")
        coder.encode(self.returnType,forKey: "returnType")
        coder.encode(self.block,forKey: "block")
        super.encode(with: coder)
        }
        
    public func setParameters(_ parameters: Parameters)
        {
        self.parameters = parameters
        }
        
    public func setBlock(_ block: Block)
        {
        self.block = block
        }
        
    public func setReturnType(_ returnType: TypeNode?)
        {
        self.returnType = returnType
        }
        
    public func addParameter(_ parameter: Parameter)
        {
        self.parameters.append(parameter)
        }
    }

public typealias Methods = Array<Method>

extension Methods
    {
    public func accept(visitor: Visitor)
        {
        for method in self
            {
            method.accept(visitor: visitor)
            }
        }
    }
