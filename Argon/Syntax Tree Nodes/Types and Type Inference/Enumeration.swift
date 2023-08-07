//
//  Enumeration.swift
//  Argon
//
//  Created by Vincent Coetzee on 27/01/2023.
//

import Foundation

public class Enumeration: StructuredType
    {
    public override var valueBox: ValueBox
        {
        .enumeration(self)
        }
        
    public override var nodeType: NodeType
        {
        return(.enumeration)
        }
        
    public override class func parse(using parser: ArgonParser)
        {
        let location = parser.token.location
        parser.nextToken()
        var baseType: TypeNode?
        let name = parser.parseIdentifier(errorCode: .identifierExpected).lastPart
        let enumeration = Enumeration(name: name)
        if parser.token.isScope
            {
            parser.nextToken()
            baseType = parser.parseType()
            if !baseType!.inherits(from: ArgonModule.shared.enumerationBaseType)
                {
                parser.lodgeIssue(code: .mustInheritFromEnumerationBase,location: location)
                }
            enumeration.setRawType(baseType!)
            }
        parser.parseBraces
            {
            while parser.token.isSymbolValue && !parser.token.isRightBrace
                {
                let localLocation = parser.token.location
                let caseSymbol = parser.token.symbolValue
                var types = TypeNodes()
                var instanceValue: ValueBox = .none
                var isDefault = false
                parser.nextToken()
                if parser.token.isLeftParenthesis
                    {
                    parser.parseParentheses
                        {
                        while parser.token.isIdentifier && !parser.token.isRightParenthesis
                            {
                            types.append(parser.parseType())
                            parser.parseComma()
                            }
                        }
                    }
                if parser.token.isAssign
                    {
                    parser.nextToken()
                    if !parser.token.isInstanceOfEnumerationBase
                        {
                        parser.lodgeIssue(code: .instanceOfEnumerationBaseExpected,location: localLocation)
                        }
                    else
                        {
                        instanceValue = parser.token.valueBox
                        parser.nextToken()
                        }
                    }
                if parser.token.isDefault
                    {
                    parser.nextToken()
                    isDefault = true
                    }
                let someCase = EnumerationCase(name: caseSymbol, associatedTypes: types,instanceValue:  instanceValue)
                enumeration.addCase(someCase)
                if isDefault
                    {
                    enumeration.setDefaultCase(someCase)
                    }
                }
            }
        }
        
    public private(set) var cases: EnumerationCases = []
    public private(set) var defaultCase: EnumerationCase?
    public private(set) var rawType: TypeNode?
    
    public init(name: String)
        {
        super.init(name: name)
        }
        
    public init(name: String,cases: EnumerationCases,rawType: TypeNode? = nil)
        {
        self.cases = cases
        self.rawType = rawType
        super.init(name: name)
        }
        
    public required init(coder: NSCoder)
        {
        self.cases = coder.decodeObject(forKey: "cases") as! EnumerationCases
        self.defaultCase = coder.decodeObject(forKey: "defaultCase") as? EnumerationCase
        self.rawType = coder.decodeObject(forKey: "rawType") as? TypeNode
        super.init(coder: coder)
        }
        
    public override func encode(with coder: NSCoder)
        {
        coder.encode(self.cases,forKey: "cases")
        coder.encode(self.defaultCase,forKey: "defaultCase")
        coder.encode(self.rawType,forKey: "rawType")
        super.encode(with: coder)
        }
        
    public func addCase(_ someCase: EnumerationCase)
        {
        self.cases.append(someCase)
        }
        
    public func setRawType(_ type: TypeNode)
        {
        self.rawType = type
        }
        
    public func setDefaultCase(_ someCase: EnumerationCase)
        {
        self.defaultCase = someCase
        }
        
    public override var isEnumeration: Bool
        {
        true
        }
        
    public func `case`(atSymbol symbol: Argon.Symbol) -> EnumerationCase?
        {
        for aCase in self.cases
            {
            if aCase.name == symbol
                {
                return(aCase)
                }
            }
        return(nil)
        }
        
    public override func dump(indent: String)
        {
        print("\(indent)Enumeration(\(self.name))")
        }
    }

public typealias EnumerationTypes = Array<Enumeration>
