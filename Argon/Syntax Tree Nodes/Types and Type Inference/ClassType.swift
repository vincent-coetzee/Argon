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
        self.slots.map{ $0.type }
        }
        
    public override var nodeType: NodeType
        {
        return(.class)
        }
        
    public private(set) var superclasses: ClassTypes = []
    public private(set) var slots: Slots = []
    public private(set) var forms = Methods()
    public private(set) var deform: MethodType?
    
    public init(name: String,slots: Slots = [],superclasses: ClassTypes = [],generics: ArgonTypes = ArgonTypes())
        {
        self.slots = slots
        self.superclasses = superclasses
        super.init(name: name)
        self.setGenericTypes(generics)
        }
        
    public init(name: String)
        {
        super.init(name: name)
        }
        
    public required init(coder: NSCoder)
        {
        self.slots = coder.decodeObject(forKey: "slots") as! Slots
        super.init(coder: coder)
        }
        
    public override func encode(with coder: NSCoder)
        {
        coder.encode(self.slots,forKey: "slots")
        super.encode(with: coder)
        }
        
    
    public func addForm(_ method: MethodType)
        {
        self.forms.append(method)
        }
        
    public func setDeform(_ method: MethodType)
        {
        self.deform = method
        }

    public override var typeHash: Int
        {
        self.hash
        }
        
    public override var hash: Int
        {
        var hasher = Hasher()
        hasher.combine("CLASS")
        hasher.combine(self.parent)
        hasher.combine(self.name)
        for aType in self.genericTypes
            {
            hasher.combine(aType)
            }
        return(hasher.finalize())
        }
        
    public override func lookupNode(atName: String) -> SyntaxTreeNode?
        {
        for slot in self.slots
            {
            if slot.name == atName
                {
                return(slot)
                }
            }
        return(nil)
        }
    
    @discardableResult
    public func slot(_ name: String,_ type: ArgonType) -> ClassType
        {
        let slot = Slot(name: name,type: type)
        self.slots.append(slot)
        return(self)
        }
        
    public override func dump(indent: String)
        {
        print("\(indent)Class(\(self.name))")
        }
        
    public override func addNode(_ node: SyntaxTreeNode)
        {
        let slot = node as! Slot
        self.slots.append(slot)
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
        parser.currentScope.addNode(scope)
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
                        typeVariables.append(SubstitutionSet.newTypeVariable(named: parser.token.identifier.lastPart))
                        }
                    parser.nextToken()
                    }
                while parser.token.isComma && !parser.token.isRightBrocket && !parser.token.isEnd
                }
            }
        scope.setGenericTypes(typeVariables)
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
            while parser.token.isForm
                {
                let form = self.parseForm(in: scope,using: parser)
                scope.addForm(form)
                }
            if parser.token.isDeform
                {
                scope.setDeform(self.parseDeform(in: scope,using: parser))
                }
            }
        scope.setSlots(slots)
        let metaclass = MetaclassType(class: scope)
        scope.setType(metaclass)
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
        var type: ArgonType = SubstitutionSet.newTypeVariable()
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
        slot.setType(type)
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
        self.slots = slots
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
        
    public override func accept(visitor: Visitor)
        {
        visitor.enter(class: self)
        for slot in self.slots
            {
            slot.accept(visitor: visitor)
            }
        visitor.exit(class: self)
        }
    }

public typealias ClassTypes = Array<ClassType>
