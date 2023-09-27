//
//  Enumeration.swift
//  Argon
//
//  Created by Vincent Coetzee on 27/01/2023.
//

import Foundation

public class EnumerationType: StructuredType
    {
    public override var valueBox: ValueBox
        {
        .enumeration(self)
        }
        
//    public override var nodeType: NodeType
//        {
//        return(.enumeration)
//        }
        
    public override var symbolType: ArgonType
        {
        get
            {
            ArgonType.enumerationType
            }
        set
            {
            }
        }
        
    public override var typeHash: Int
        {
        self.hash
        }
        
    public var cases: EnumerationCases
        {
        self.symbols.values.compactMap{$0 as? EnumerationCase}
        }
        
    public override var hash: Int
        {
        var hasher = Hasher()
        hasher.combine("ENUMERATION")
        hasher.combine(self.identifier)
        for aType in self.genericTypes
            {
            hasher.combine(aType)
            }
        return(hasher.finalize())
        }
        
    public override class func parse(using parser: ArgonParser)
        {
        let location = parser.token.location
        parser.nextToken()
        var baseType: ArgonType?
        let name = parser.parseIdentifier(errorCode: .identifierExpected).lastPart
        let enumeration = EnumerationType(name: name)
        parser.currentScope.addSymbol(enumeration.typeConstructor())
        enumeration.location = location
        // TODO: Check here for brockets and parse type parameters if you find them and remember to add them to the constructor
        if parser.token.isScope
            {
            parser.nextToken()
            baseType = parser.parseType()
            if !baseType!.inherits(from: ArgonModule.shared.discreteType)
                {
                parser.lodgeError(code: .mustInheritFromDiscreteType,location: location)
                }
            enumeration.setRawType(baseType!)
            }
        parser.parseBraces
            {
            while parser.token.isAtomValue && !parser.token.isRightBrace
                {
                let localLocation = parser.token.location
                let caseSymbol = parser.token.atomValue
                var types = ArgonTypes()
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
                    let type = parser.parseType()
                    if !type.inherits(from: ArgonModule.shared.discreteType)
                        {
                        parser.lodgeError(code: .instanceOfDiscreteTypeExpected,location: localLocation)
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
                let someCase = EnumerationCase(name: caseSymbol,enumeration: enumeration,associatedTypes: types,instanceValue:  instanceValue)
                someCase.location = localLocation
                enumeration.addCase(someCase)
                if isDefault
                    {
                    enumeration.setDefaultCase(someCase)
                    }
                }
            }
        parser.currentScope.addSymbol(enumeration)
        }
        
    public private(set) var defaultCase: EnumerationCase?
    public private(set) var rawType: ArgonType?
    private var symbols = SymbolDictionary()
    
    public init(name: String)
        {
        super.init(name: name)
        }
        
    public init(name: String,rawType: ArgonType? = nil)
        {
        self.rawType = rawType
        super.init(name: name)
        }
        
    public required init(coder: NSCoder)
        {
        self.symbols = coder.decodeObject(forKey: "symbols") as! SymbolDictionary
        self.defaultCase = coder.decodeObject(forKey: "defaultCase") as? EnumerationCase
        self.rawType = coder.decodeObject(forKey: "rawType") as? ArgonType
        super.init(coder: coder)
        }
        
    public required init(name: String,genericTypes: ArgonTypes)
        {
        super.init(name: name,genericTypes: genericTypes)
        }
        
    public override func encode(with coder: NSCoder)
        {
        coder.encode(self.symbols,forKey: "symbols")
        coder.encode(self.cases,forKey: "cases")
        coder.encode(self.defaultCase,forKey: "defaultCase")
        coder.encode(self.rawType,forKey: "rawType")
        super.encode(with: coder)
        }
        
    public func setCases(_ cases: Array<EnumerationCase>)
        {
        for aCase in cases
            {
            self.addSymbol(aCase)
            }
        }
        
    public func addCase(_ someCase: EnumerationCase)
        {
        self.addSymbol(someCase)
        }
        
    public func setRawType(_ type: ArgonType)
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
        
    public func `case`(atAtom atom: Argon.Atom) -> EnumerationCase?
        {
        self.lookupSymbol(atName: atom) as? EnumerationCase
        }
        
    public override func dump(indent: String)
        {
        print("\(indent)Enumeration(\(self.name))")
        }
        
    public override func addSymbol(_ symbol: Symbol)
        {
        self.symbols[symbol.name] = symbol
        symbol.setContainer(self)
        }
        
    public override func lookupSymbol(atName: String) -> Symbol?
        {
        if let node = self.symbols[atName]
            {
            return(node)
            }
        return(self.container?.lookupSymbol(atName: atName))
        }
        
    public override func lookupMethods(atName name: String) -> Methods
        {
        self.container?.lookupMethods(atName: name) ?? Methods()
        }
        
    public override func accept(visitor: Visitor)
        {
        for symbol in self.symbols.values
            {
            symbol.accept(visitor: visitor)
            }
        }
        
    @discardableResult
    public func setAssociatedTypes(forAtom: String,_ types: ArgonType...) -> Self
        {
        if let someCase = self.case(atAtom: forAtom)
            {
            someCase.associatedTypes = types
            }
        return(self)
        }
        
    public override func typeConstructor() -> ArgonType
        {
        return(TypeConstructor(name: self.name,constructedType: .enumeration(self)))
        }
        
    public override func clone() -> Self
        {
        let someClass = EnumerationType(name: self.name,rawType: self.rawType)
        var newSymbols = SymbolDictionary()
        for (key,symbol) in self.symbols
            {
            newSymbols[key] = symbol
            }
        someClass.symbols = newSymbols
        return(someClass as! Self)
        }
    }

public typealias EnumerationTypes = Array<EnumerationType>
