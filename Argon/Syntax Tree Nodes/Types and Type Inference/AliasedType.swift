//
//  AliasType.swift
//  Argon
//
//  Created by Vincent Coetzee on 06/07/2023.
//

import Foundation

public class AliasedType: StructuredType
    {
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
            parser.lodgeIssue(code: .isExpected,location: location)
            }
        else
            {
            parser.nextToken()
            }
        let type = parser.parseType()
        let alias = AliasedType(name: name.lastPart, baseType: type)
        parser.currentScope.addNode(alias)
        }
    }
    
public typealias AliasedTypes = Array<AliasedType>
