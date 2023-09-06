//
//  AliasType.swift
//  Argon
//
//  Created by Vincent Coetzee on 06/07/2023.
//

import Foundation

public class AliasedType: StructuredType
    {
    public override var description: String
        {
        self.baseType.name
        }
        
    public override var baseType: TypeNode
        {
        self._baseType.baseType
        }
        
    public override var isGenericType: Bool
        {
        self.baseType.isGenericType
        }
        
    public override var genericTypes: TypeNodes
        {
        self.baseType.genericTypes
        }
        
    private let _baseType: TypeNode
    
    public init(name: String,baseType: TypeNode)
        {
        self._baseType = baseType
        super.init(name: name,generics: [])
        }
        
    public required init(coder: NSCoder)
        {
        self._baseType = coder.decodeObject(forKey: "_baseType") as! TypeNode
        super.init(coder: coder)
        }
        
    public override func encode(with coder: NSCoder)
        {
        coder.encode(self._baseType,forKey: "_baseType")
        super.encode(with: coder)
        }
        
    public override class func parse(using parser: ArgonParser)
        {
        let location = parser.token.location
        parser.nextToken()
        let name = parser.parseIdentifier(errorCode: .identifierExpected)
        if !parser.token.isIs
            {
            parser.lodgeError(code: .isExpected,location: location)
            }
        else
            {
            parser.nextToken()
            }
        let type = parser.parseType()
        type.location = location
        if parser.token.isLeftParenthesis
            {
            var lowerBound: ValueBox = .none
            var upperBound: ValueBox = .none
            parser.parseParentheses
                {
                if parser.token.isIntegerValue
                    {
                    lowerBound = .integer(parser.token.integerValue)
                    parser.nextToken()
                    }
                else if parser.token.isIdentifier
                    {
                    lowerBound = .identifier(parser.token.identifier)
                    parser.nextToken()
                    }
                else
                    {
                    parser.lodgeError(code: .integerOrIdentifierExpected,location: location)
                    }
                if !parser.token.isRangeOperator
                    {
                    parser.lodgeError(code: .rangeOperatorExpected,location: location)
                    }
                else
                    {
                    parser.nextToken()
                    }
                if lowerBound.isInteger
                    {
                    if !parser.token.isIntegerValue
                        {
                        parser.lodgeError(code: .integerUpperBoundExpectedAfterIntegerLowerBound,location: location)
                        }
                    else
                        {
                        upperBound = .integer(parser.token.integerValue)
                        parser.nextToken()
                        }
                    }
                else if lowerBound.isIdentifier
                    {
                    if !parser.token.isIdentifier
                        {
                        parser.lodgeError(code: .identifierUpperBoundExpectedAfterIdentifierLowerBound,location: location)
                        }
                    else
                        {
                        upperBound = .identifier(parser.token.identifier)
                        parser.nextToken()
                        }
                    }
                else
                    {
                    parser.lodgeError(code: .integerOrIdentifierExpected,location: location)
                    }
                }
            let subType = SubType(name: name.lastPart,baseType: type,lowerBound: lowerBound,upperBound: upperBound)
            subType.location = location
            parser.currentScope.addNode(subType)
            return
            }
        let alias = AliasedType(name: name.lastPart, baseType: type)
        alias.location = location
        parser.currentScope.addNode(alias)
        }
        
    public override func accept(visitor: Visitor)
        {
        visitor.visit(aliasedType: self)
        }
        
    public override func inherits(from someClass: ClassType) -> Bool
        {
        self.baseType.inherits(from: someClass)
        }
    }
    
public typealias AliasedTypes = Array<AliasedType>
