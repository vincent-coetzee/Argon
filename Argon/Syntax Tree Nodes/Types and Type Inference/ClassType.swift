//
//  Class.swift
//  Argon
//
//  Created by Vincent Coetzee on 27/01/2023.
//

import Foundation

public class ClassType: StructuredType
    {
    public override var isClass: Bool
        {
        true
        }
        
    public override var elementTypes: ArgonTypes
        {
        self.slots.map{ $0.symbolType }
        }
        
    public override var nodeType: NodeType
        {
        return(.class)
        }
        
    public private(set) var initializers = Methods()
    public private(set) var deinitializer: MethodType?
    private var poolVariables = Dictionary<String,Variable>()
    private var symbols = SyntaxTreeNodes()
    private var superclasses = ArgonTypes()
    
    public init(name: String,slots: Slots = [],superclasses: ClassTypes = [],genericTypes: ArgonTypes = ArgonTypes())
        {
        self.superclasses = superclasses
        super.init(name: name)
        self.setGenericTypes(genericTypes)
        }
        
    public init(name: String)
        {
        super.init(name: name)
        }
        
    public required init(coder: NSCoder)
        {
        self.superclasses = coder.decodeObject(forKey: "superclasses") as! ClassTypes
//        self.initializers = coder.decodeObject(forKey: "initializers") as! Methods
//        self.deinitializer = coder.decodeObject(forKey: "deinitializer") as? MethodType
        self.symbols = coder.decodeObject(forKey: "symbols") as! SyntaxTreeNodes
        super.init(coder: coder)
        }
        
    public override func encode(with coder: NSCoder)
        {
//        coder.encode(self.initializers,forKey: "initializers")
//        coder.encode(self.deinitializer,forKey: "deinitializer")
        coder.encode(self.symbols,forKey: "symbols")
        coder.encode(self.superclasses,forKey: "superclasses")
        super.encode(with: coder)
        }
        
//    public func addInitializer(_ method: MethodType)
//        {
//        self.initializers.append(method)
//        }
//        
//    public func setDeinitializer(_ method: MethodType)
//        {
//        self.deinitializer = method
//        }

    public override var typeHash: Int
        {
        self.hash
        }
        
    public override var hash: Int
        {
        var hasher = Hasher()
        hasher.combine("CLASS")
        hasher.combine(self.container)
        hasher.combine(self.name)
        hasher.combine(self.superclasses)
        hasher.combine(self.slots)
        for aType in self.genericTypes
            {
            hasher.combine(aType)
            }
        return(hasher.finalize())
        }
        
    public var slots: Slots
        {
        self.symbols.compactMap{$0 as? Slot}
        }
        
    @discardableResult
    public override func slot(_ name: String,_ type: ArgonType) -> ArgonType
        {
        let slot = Slot(name: name,type: type)
        self.symbols.append(slot)
        slot.setContainer(self)
        return(self)
        }
        
    public override func dump(indent: String)
        {
        print("\(indent)Class(\(self.name))")
        }
        
    public override func addSymbol(_ symbol: SyntaxTreeNode)
        {
        self.symbols.append(symbol)
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
            parser.nextToken()
            }
        let scope = ClassType(name: name)
        parser.currentContext.addSymbol(scope)
        var superclasses = ClassTypes()
        var typeVariables = TypeVariables()
        if parser.token.isLeftBrocket
            {
            parser.parseBrockets
                {
                repeat
                    {
                    parser.parseComma()
                    if parser.token.isIdentifier
                        {
                        typeVariables.append(TypeSubstitutionSet.newTypeVariable(named: parser.token.identifier.lastPart))
                        }
                    parser.nextToken()
                    }
                while parser.token.isComma && !parser.token.isRightBrocket && !parser.token.isEnd
                }
            }
        scope.setGenericTypes(typeVariables)
        for node in typeVariables
            {
            scope.addSymbol(node)
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
//            while parser.token.isForm
//                {
//                let form = self.parseForm(in: scope,using: parser)
//                scope.addInitializer(form)
//                }
//            if parser.token.isDeform
//                {
//                scope.setDeinitializer(self.parseDeform(in: scope,using: parser))
//                }
            self.parsePool(in: scope,using: parser)
            self.parseSection(in: scope,using: parser)
            }
        scope.setSlots(slots)
        scope.setSymbolType(ArgonModule.shared.classType)
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
    // A SECTION contains the name of a group that this Class belongs to. e.g. if you
    // have several classes that form part of the list of all  Client classes in the module
    // SECTION would be declared as
    //
    // SECTION(Weather Clients)
    //
    // SECTION contents i.e. "Weather Clients" in this case are scanned as a continuous string
    // contained between parentheses. Any legitimate character - including whitespace - can be placed in the content field and
    // will be scanned into the content portion of the section. SECTION contents are scanned like this so that
    // there is no need to constantly quote the SECTION contents. Each Class can be a member of one and only
    // one SECTION.
    //
    //
    private static func parseSection(in scope: ClassType,using parser: ArgonParser)
        {
        guard parser.token.isSection else
            {
            return
            }
        let location = parser.token.location
        parser.nextToken()
        parser.parseParentheses
            {
            if !parser.token.isTextToken
                {
                parser.lodgeError(code: .textExpectedInSection,location: location)
                }
            scope.section = parser.token.textValue
            parser.nextToken()
            }
        }
        
    private class func parseForm(`in` aClass: ClassType,using parser: ArgonParser) -> MethodType
        {
        parser.nextToken()
        let parameters = parser.parseParameters()
        let block = Block()
        for parameter in parameters
            {
            block.addLocal(parameter)
            }
        block.addLocal(PseudoVariable.`self`(type: aClass))
        parser.parseBraces
            {
            Block.parseBlockInner(block: block,using: parser)
            }
        let method = MethodType(name: "FORM")
        method.setParameters(parameters)
        method.setBlock(block)
        return(method)
        }
        
    @discardableResult
    private class func parseDeform(`in` aClass: ClassType,using parser: ArgonParser) -> MethodType
        {
        parser.nextToken()
        let block = Block()
        block.addLocal(PseudoVariable.`self`(type: aClass))
        parser.parseBraces
            {
            Block.parseBlockInner(block: block,using: parser)
            }
        let method = MethodType(name: "DEFORM")
        method.setBlock(block)
        return(method)
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
            slot.isVirtualSlot = true
            parser.nextToken()
            }
        if parser.token.isDynamic
            {
            slot.isDynamicSlot = true
            parser.nextToken()
            }
        slot.isReadWriteSlot = true
        if parser.token.isRead
            {
            slot.isReadWriteSlot = false
            parser.nextToken()
            }
        else if parser.token.isWrite
            {
            slot.isReadWriteSlot = true
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
        var type: ArgonType = TypeSubstitutionSet.newTypeVariable()
        if parser.token.isScope
            {
            parser.nextToken()
            type = parser.parseType()
            }
        else if slot.isVirtualSlot
            {
            parser.lodgeError(code: .vitualSlotMustSpecifyType,location: location)
            }
        var initialExpression: Expression?
        if parser.token.isAssign
            {
            if !slot.isVirtualSlot
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
        if slot.isVirtualSlot
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
            if slot.isReadWriteSlot
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
        slot.setSymbolType(type)
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
        var superclasses = ClassTypes()
        repeat
            {
            if parser.token.isComma
                {
                parser.nextToken()
                }
            let identifier = parser.parseIdentifier(errorCode: .superclassIdentifierExpected)
            if let node = parser.lookupNode(atIdentifier: identifier)
                {
                if let classType = node as? ClassType
                    {
                    superclasses.append(classType)
                    }
                else
                    {
                    parser.lodgeError(code: .classExpectedButOtherSymbolFound,location: location)
                    }
                }
            else
                {
                parser.lodgeError(code: .undefinedClass,location: location)
                }
            }
        while parser.token.isComma && !parser.token.isEnd
        return(superclasses)
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

    init(name: String,parent: SyntaxTreeNode? = nil)
        {
        super.init(name: name)
        }
        
    public override func accept(visitor: Visitor)
        {
        visitor.enter(class: self)
        for symbol in self.symbols
            {
            symbol.accept(visitor: visitor)
            }
        visitor.exit(class: self)
        }
        
    public override func lookupSymbol(atName: String) -> SyntaxTreeNode?
        {
        for node in self.symbols
            {
            if node.name == atName && !(node.isMethod || node.isFunction)
                {
                return(node)
                }
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
        
    public override func lookupMethods(atName name: String) -> Methods
        {
        self.container?.lookupMethods(atName: name) ?? Methods()
        }
        
    public func addPoolVariable(_ variable: Variable)
        {
        self.poolVariables[variable.name] = variable
        }
        
    public override func instanciate(withTypes types: ArgonTypes) throws -> ArgonType
        {
        fatalError()
        }
    }

public typealias ClassTypes = Array<ClassType>
