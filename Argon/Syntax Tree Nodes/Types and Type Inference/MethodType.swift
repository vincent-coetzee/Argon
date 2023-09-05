//
//  Method.swift
//  Argon
//
//  Created by Vincent Coetzee on 05/07/2023.
//

import Foundation

public class MethodType: CallableTypeNode
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
        let method = MethodType(name: name)
        method.setParameters(parameters)
        method.setBlock(block)
        method.setReturnType(returnType)
        parser.currentScope.addNode(method)
        }
        
    public override var encoding: String
        {
        let inners = self.parameters.map{$0.type.encoding}.joined(separator: "_")
        let returnTypeString = self.returnType.isNil ? ArgonModule.shared.voidType.encoding : self.returnType!.encoding
        return("c\(self.name)_\(inners)_\(returnTypeString)_")
        }
        
    public override var description: String
        {
        let returnName = self.returnType?.name ?? "Void"
        let parameterName = self.parameters.map{$0.description}.joined(separator: ",")
        return("\(self.name)(\(parameterName)) -> \(returnName)")
        }
        
    public private(set) var block = Block()
    
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
        super.init(coder: coder)
        }
        
    public override func encode(with coder: NSCoder)
        {
        coder.encode(self.block,forKey: "block")
        super.encode(with: coder)
        }

    public func setBlock(_ block: Block)
        {
        self.block = block
        block.setParent(self)
        }
    }

public typealias Methods = Array<MethodType>

extension Methods
    {
    public func accept(visitor: Visitor)
        {
        for method in self
            {
            method.accept(visitor: visitor)
            }
        }
    
    public func appending(_ methods: Methods) -> Self
        {
        var newMethods = Methods()
        for method in methods
            {
            newMethods.append(method)
            }
        return(newMethods)
        }
    }
