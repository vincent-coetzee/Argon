//
//  Class.swift
//  Argon
//
//  Created by Vincent Coetzee on 27/01/2023.
//

import Foundation

public struct ClassFlags: OptionSet
    {
    public static let abstract = ClassFlags(rawValue: 1 << 0)
    public static let primitive = ClassFlags(rawValue: 1 << 1)
    public static let structured = ClassFlags(rawValue: 1 << 2)
    public static let constructor = ClassFlags(rawValue: 1 << 3)
    public static let root = ClassFlags(rawValue: 1 << 4)
    
    public var rawValue: Int
    
    public init(rawValue: Int)
        {
        self.rawValue = rawValue
        }
    }
    
public class ClassType: StructuredType
    {
    public override var styleElement: StyleElement
        {
        .colorClass
        }
        
    public override var isMakeable: Bool
        {
        true
        }
        
    public var isAbstract: Bool
        {
        self.classFlags.contains(.abstract)
        }
        
    public override var isClassType: Bool
        {
        true
        }
        
    public override var elementTypes: ArgonTypes
        {
        self.slots.map{ $0.symbolType }
        }
        
    public var classFlags = ClassFlags(rawValue: 0)
    private var poolVariables = Dictionary<String,Variable>()
    private var symbols = SymbolDictionary()
    private var superclasses = ArgonTypes()
    
    public init(name: String,slots: Slots = [],superclasses: ClassTypes = [],genericTypes: ArgonTypes = ArgonTypes())
        {
        self.superclasses = superclasses
        super.init(name: name)
        self.setGenericTypes(genericTypes)
        self.setSlots(slots)
        }
        
    public init(name: String)
        {
        super.init(name: name)
        }
        
    public required init(coder: NSCoder)
        {
        self.classFlags = ClassFlags(rawValue: coder.decodeInteger(forKey: "classFlags"))
        self.superclasses = coder.decodeObject(forKey: "superclasses") as! ClassTypes
        self.symbols = coder.decodeObject(forKey: "symbols") as! SymbolDictionary
        super.init(coder: coder)
        }
        
    public override func encode(with coder: NSCoder)
        {
        coder.encode(self.classFlags.rawValue,forKey: "classFlags")
        coder.encode(self.symbols,forKey: "symbols")
        coder.encode(self.superclasses,forKey: "superclasses")
        super.encode(with: coder)
        }
        
    public override var typeHash: Int
        {
        self.hash
        }
        
    public override var hash: Int
        {
        var hasher = Hasher()
        hasher.combine("CLASS")
        hasher.combine(self.identifier)
        hasher.combine(self.genericTypes)
        return(hasher.finalize())
        }
        
    public var slots: Slots
        {
        self.symbols.values.compactMap{$0 as? Slot}
        }
        
    @discardableResult
    public override func slot(_ name: String,_ type: ArgonType) -> ArgonType
        {
        let slot = Slot(name: name,type: type)
        self.symbols[slot.name] = slot
        slot.setContainer(self)
        return(self)
        }
        
    public override func dump(indent: String)
        {
        print("\(indent)Class(\(self.name))")
        }
        
    public override func setSymbol(_ symbol: Symbol,atName: String)
        {
        self.symbols[atName] = symbol
        }
        
    public override func addSymbol(_ symbol: Symbol)
        {
        self.symbols[symbol.name] = symbol
        symbol.setContainer(self)
        }
        
    public override var valueBox: ValueBox
        {
        .class(self)
        }
        
    public override class func parse(using parser: ArgonParser)
        {
        let location = parser.token.location
        parser.nextToken()
        var name = ""
        if !parser.token.isIdentifier
            {
            name = Argon.nextIndex(named: "CLASS")
            parser.lodgeError(code: .identifierExpected,location: location)
            }
        else
            {
            if parser.token.identifier.isCompoundIdentifier
                {
                parser.lodgeError(code: .singleIdentifierExpected,location: location)
                }
            name = parser.token.identifier.description
            parser.token.setStyleElement(.colorClass)
            parser.nextToken()
            }
        let scope = ClassType(name: name)
        let constructor = scope.typeConstructor()
        parser.currentScope.addSymbol(constructor)
        var superclasses = ClassTypes()
        if parser.token.isLeftBrocket
            {
            parser.parseBrockets
                {
                var typeParameters = TypeParameters()
                repeat
                    {
                    parser.parseComma()
                    if parser.token.isIdentifier
                        {
                        typeParameters.append(TypeParameter(name: parser.token.identifier.lastPart,scope: scope))
                        }
                    parser.nextToken()
                    }
                while parser.token.isComma && !parser.token.isRightBrocket && !parser.token.isEnd
                constructor.setTypeParameters(typeParameters)
                }
            }
        if parser.token.isScope
            {
            superclasses = self.parseSuperclasses(using: parser)
            }
        scope.setSuperclasses(superclasses)
        var slots = Slots()
        parser.parseBraces
            {
            while parser.token.isSlotRelatedKeyword
                {
                slots.append(self.parseSlotDeclaration(using: parser))
                }
            self.parsePool(in: scope,using: parser)
            self.parseSection(in: scope,using: parser)
            }
        scope.setSlots(slots)
        }
    //
    //
    // Parse a POOL declaration in a Class
    // e.g.
    //
    // CLASS SomeClass
    //      {
    //      ...
    //      POOL(variableA::Integer,someVariable1::String,thisClass::Class = MAKE(SomeClass))
    //      }
    //
    //
    private static func parsePool(in scope: ClassType,using parser: ArgonParser)
        {
        let location = parser.token.location
        guard parser.token.isPool else
            {
            return
            }
        parser.nextToken()
        parser.parseParentheses
            {
            repeat
                {
                parser.parseComma()
                if !parser.token.isRightParenthesis && !parser.token.isEnd
                    {
                    var name: String = Argon.nextIndex(named: "POOLVAR")
                    if !parser.token.isIdentifier
                        {
                        parser.lodgeError(code: .identifierExpected,location: location)
                        }
                    else
                        {
                        name = parser.token.identifier.lastPart
                        parser.nextToken()
                        }
                    if !parser.token.isScope
                        {
                        parser.lodgeError(code: .scopeOperatorExpected,location: location)
                        }
                    else
                        {
                        parser.nextToken()
                        }
                    var expression:Expression?
                    if parser.token.isAssign
                        {
                        parser.nextToken()
                        expression = parser.parseExpression()
                        }
                    let variable = Variable(name: name, type: parser.parseType(), expression: expression)
                    variable.location = location
                    variable.addDeclaration(location)
                    scope.addPoolVariable(variable)
                    }
                }
            while parser.token.isComma && !parser.token.isEnd
            }
        }
    //
    //
    // Section defines all the identifiers of the groups that this class
    // belongs to. Let's say this class belong to the Weather\Clients groups
    // and to \\Some\Other\Group then the SECTION would be defined as follows
    //
    // SECTION(Weather\Clients,\\Some\Other\Group)
    //
    // In this case this creates a group called Weather and positions
    // this class wihin the Clients group which is a subgroup of of
    // Weather. Similarly \\Some\Other\Group creates a group called
    // Some and places in that group another group called Other and
    // within that group another group called Group and adss this class
    // into the the lst group i.e. Group. Classes and enumerations can
    // be members of multiple groups or none. The groups defined by the
    // SECTION keyword are purely organisational in nature and semantically
    // are not affected by the sections they are in.
    //
    //
    private static func parseSection(in scope: ClassType,using parser: ArgonParser)
        {
        guard parser.token.isSection else
            {
            return
            }
//        let location = parser.token.location
        parser.nextToken()
        var names = Identifiers()
        parser.parseParentheses
            {
            repeat
                {
                parser.parseComma()
                if parser.token.isIdentifier
                    {
                    names.append(parser.token.identifier)
                    parser.nextToken()
                    }
                }
            while parser.token.isComma && !parser.token.isEnd
            }
        scope.sections = names
        }
    //
    //
    // A slot is declared as follows
    //
    // [ VIRTUAL ] [ DYNAMIC ] [ READ | WRITE ] SLOT identifier ( [ :: type ] | [ = expression ] | [ :: type = expression ] ) [ READ { expressions } ] [ WRITE { expressions } ]
    //
    //
    private class func parseSlotDeclaration(using parser: ArgonParser) -> Slot
        {
        let location = parser.token.location
        let slot = Slot(name: "")
        if parser.token.isVirtual
            {
            slot.slotFlags.insert(.virtual)
            parser.nextToken()
            }
        if parser.token.isDynamic
            {
            slot.slotFlags.insert(.dynmaic)
            parser.nextToken()
            }
        if parser.token.isRead
            {
            slot.slotFlags.insert(.read)
            parser.nextToken()
            }
        else if parser.token.isWrite
            {
            slot.slotFlags.insert(.write)
            parser.nextToken()
            }
        if !parser.token.isSlot
            {
            parser.lodgeError(code: .slotExpectedAfterRead,message: "'SLOT' expected.",location: location)
            }
        else
            {
            parser.nextToken()
            }
        let identifier = parser.parseIdentifier(errorCode: .identifierExpected,message: "Identifier expected after 'SLOT'.")
        if identifier.isCompoundIdentifier
            {
            parser.lodgeError(code: .singleIdentifierExpected,message: "An identifier path is not allowed here.",location: location)
            }
        let name = identifier.lastPart
        var type: ArgonType = TypeSubstitutionSet.initialSet.newTypeVariable()
        if parser.token.isScope
            {
            parser.nextToken()
            type = parser.parseType()
            }
        else if slot.slotFlags.contains(.virtual)
            {
            parser.lodgeError(code: .vitualSlotMustSpecifyType,location: location)
            }
        var initialExpression: Expression?
        if parser.token.isAssign
            {
            if !slot.slotFlags.contains(.virtual)
                {
                parser.nextToken()
                initialExpression = parser.parseExpression(precedence: 0)
                }
            else
                {
                parser.lodgeError(code: .virtualSlotNotAllowedInitialExpression,location: location)
                }
            }
        var readBlock: Block?
        var writeBlock: Block?
        if slot.slotFlags.contains(.virtual)
            {
            if parser.token.isRead
                {
                parser.nextToken()
                readBlock = self.parseReadBlock(using: parser)
                }
            else
                {
                parser.lodgeError(code: .readBlockExpectedForVirtualSlot,location: location)
                }
            if slot.slotFlags.contains(.write)
                {
                if parser.token.isWrite
                    {
                    parser.nextToken()
                    writeBlock = self.parseWriteBlock(slotType: type,using: parser)
                    }
                else
                    {
                    parser.lodgeError(code: .writeBlockExpectedForVirtualSlot,location: location)
                    }
                }
            }
        slot.setName(name)
        slot.symbolType = type
        slot.setInitialExpression(initialExpression)
        slot.setReadBlock(readBlock)
        slot.setWriteBlock(writeBlock)
        return(slot)
        }
        
    private class func parseReadBlock(using parser: ArgonParser) -> Block
        {
        let location = parser.token.location
        let block = Block.parseBlock(using: parser)
        if !block.containsReturnStatement
            {
            parser.lodgeError(code: .returnExpectedInReadBlock,location: location)
            }
        return(block)
        }
        
    private class func parseWriteBlock(slotType: ArgonType,using parser: ArgonParser) -> Block
        {
        let block = Block()
        block.addLocal(PseudoVariable(name: "self"))
        block.addLocal(Variable(name: "newValue",type: slotType,expression: nil))
        Block.parseBlockInner(block: block, using: parser)
        return(block)
        }
        
    private class func parseSuperclasses(using parser: ArgonParser) -> ClassTypes
        {
        let location = parser.token.location
        parser.nextToken()
        var classTypes = ArgonTypes()
        repeat
            {
            parser.parseComma()
            let classType = parser.parseType()
            if !classType.isClassType
                {
                parser.lodgeError(code: .classExpectedButOtherSymbolFound,location: location)
                }
            else
                {
                classTypes.append(classType)
                }
            }
        while parser.token.isComma && !parser.token.isEnd
        return(classTypes.compactMap{$0 as? ClassType})
        }
        
    public func setSuperclasses(_ superclasses: ClassTypes)
        {
        self.superclasses = superclasses
        }
        
    public func setSlots(_ slots: Slots)
        {
        for slot in slots
            {
            self.addSymbol(slot)
            }
        }
        
    public override func inherits(from someClass: ClassType) -> Bool
        {
        for superclass in self.superclasses
            {
            if superclass == someClass
                {
                return(true)
                }
            if superclass.inherits(from: someClass)
                {
                return(true)
                }
            }
        return(false)
        }

    public func superclassSlots() -> Slots
        {
        var someSlots = Slots()
        for parent in self.superclasses.compactMap({$0 as? ClassType})
            {
            someSlots.append(contentsOf: parent.superclassSlots())
            }
        return(someSlots)
        }
        
    init(name: String,parent: Symbol? = nil)
        {
        super.init(name: name)
        }
        
    public required init(name: String,genericTypes: ArgonTypes)
        {
        super.init(name: name,genericTypes: genericTypes)
        }
        
    public override func accept(visitor: Visitor)
        {
        visitor.enter(class: self)
        for symbol in self.symbols.values
            {
            symbol.accept(visitor: visitor)
            }
        visitor.exit(class: self)
        }
        
    public override func lookupType(atName: String) -> ArgonType?
        {
        (self.lookupSymbol(atName: atName) as? ArgonType)?.symbolType
        }
        
    public override func lookupSymbol(atName: String) -> Symbol?
        {
        if let node = self.symbols[atName],!node.isMethod && !node.isFunction
            {
            return(node)
            }
        for someClass in self.superclasses
            {
            if let symbol = someClass.lookupSymbol(atName: atName)
                {
                return(symbol)
                }
            }
        for (key,variable) in self.poolVariables
            {
            if key == atName
                {
                return(variable)
                }
            }
        return(self.container?.lookupSymbol(atName: atName))
        }
        
    public override func lookupMethod(atName name: String) -> MultimethodType?
        {
        self.container?.lookupMethod(atName: name)
        }
        
    public func addPoolVariable(_ variable: Variable)
        {
        self.poolVariables[variable.name] = variable
        }
        
    public override func clone() -> Self
        {
        let someClass = ClassType(name: self.name,superclasses: self.superclasses as! ClassTypes)
        var newSymbols = SymbolDictionary()
        for (key,symbol) in self.symbols
            {
            newSymbols[key] = symbol
            }
        someClass.symbols = newSymbols
        someClass.poolVariables = self.poolVariables
        return(someClass as! Self)
        }
        
    public override func typeConstructor() -> ArgonType
        {
        return(TypeConstructor(name: self.name,constructedType: .class(self)))
        }
        
    public override var children: Symbols
        {
        self.slots
        }
        
    public override func configure(nodeView: SymbolViewCell)
        {
        nodeView.leftPane.stringValue = "\(Swift.type(of: self))(\(self.name))"
        nodeView.imageName = "IconClass"
        }
    }

public typealias ClassTypes = Array<ClassType>



