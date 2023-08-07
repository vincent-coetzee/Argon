//
//  Class.swift
//  Argon
//
//  Created by Vincent Coetzee on 27/01/2023.
//

import Foundation

public class ClassType: StructuredType,Scope
    {
    public override var isClassType: Bool
        {
        true
        }
        
    public override var elementTypes: TypeNodes
        {
        self.slots.map{ $0.type }
        }
        
    public override var nodeType: NodeType
        {
        return(.class)
        }
        
    public private(set) var superclasses: TypeNodes = []
    public private(set) var slots: Slots = []
    public private(set) var mades = Methods()
    public private(set) var unmade: Method?
    
    public init(name: String,slots: Slots = [],superclasses: TypeNodes = [],generics: TypeNodes = TypeNodes())
        {
        self.slots = slots
        self.superclasses = superclasses
        super.init(name: name)
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
        
        
    public func addMade(_ method: Method)
        {
        self.mades.append(method)
        }
        
    public func setUnmade(_ method: Method)
        {
        self.unmade = method
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
    public func slot(_ name: String,_ type: TypeNode) -> ClassType
        {
        let slot = Slot(name: name,type: type)
        self.slots.append(slot)
        return(self)
        }
        
    public override func dump(indent: String)
        {
        print("\(indent)Class(\(self.name))")
        }
        
    public func addNode(_ node: SyntaxTreeNode)
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
            name = "UntitledClass"
            parser.lodgeIssue(code: .identifierExpected,location: location)
            }
        else
            {
            if parser.token.identifier.isCompoundIdentifier
                {
                parser.lodgeIssue(code: .singleIdentifierExpected,location: location)
                }
            name = parser.token.identifier.description
            parser.nextToken()
            }
        let scope = ClassType(name: name)
        var superclasses = TypeNodes()
        if parser.token.isScope
            {
            superclasses = self.parseSuperclasses(using: parser)
            }
        scope.setSuperclasses(superclasses)
        var slots = Slots()
        parser.parseBraces
            {
            var unmadeAdded = false
            while parser.token.isSlotRelatedKeyword
                {
                slots.append(self.parseSlotDeclaration(using: parser))
                }
            while !parser.token.isRightBrace
                {
                if parser.token.isMade
                    {
                    let made = self.parseMade(using: parser)
                    scope.addMade(made)
                    }
                else if parser.token.isUnmade
                    {
                    if unmadeAdded
                        {
                        parser.lodgeIssue(code: .unmadeAlreadyDefined,location: parser.token.location)
                        self.parseUnmade(using: parser)
                        }
                    else
                        {
                        scope.setUnmade(self.parseUnmade(using: parser))
                        unmadeAdded = true
                        }
                    }
                }
            }
        scope.setSlots(slots)
        }
        
    private class func parseMade(using parser: ArgonParser) -> Method
        {
        parser.nextToken()
        let parameters = parser.parseParameters()
        let block = Block()
        for parameter in parameters
            {
            block.addLocal(parameter)
            }
        Block.parseBlockInner(block: block,using: parser)
        let method = Method(name: "MADE")
        method.setParameters(parameters)
        method.setBlock(block)
        return(method)
        }
        
    @discardableResult
    private class func parseUnmade(using parser: ArgonParser) -> Method
        {
        parser.nextToken()
        let block = Block()
        Block.parseBlockInner(block: block,using: parser)
        let method = Method(name: "UNMADE")
        method.setBlock(block)
        return(method)
        }
        
    private class func parseSlotDeclaration(using parser: ArgonParser) -> Slot
        {
        let location = parser.token.location
        let slot = Slot(name: "")
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
        if parser.token.isDynamic
            {
            slot.isDynamicSlot = true
            parser.nextToken()
            }
        if parser.token.isVirtual
            {
            slot.isVirtualSlot = true
            parser.nextToken()
            }
        if !parser.token.isSlot
            {
            parser.lodgeIssue(code: .slotExpectedAfterRead,message: "'SLOT' expected.",location: location)
            }
        else
            {
            parser.nextToken()
            }
        var identifier = parser.parseIdentifier(errorCode: .identifierExpected,message: "Identifier expected after 'SLOT'.")
        if identifier.isCompoundIdentifier
            {
            parser.lodgeIssue(code: .singleIdentifierExpected,message: "An identifier path is not allowed here.",location: location)
            }
        let name = identifier.lastPart
        parser.nextToken()
        var type: TypeNode = TypeNode.newTypeVariable()
        if parser.token.isScope
            {
            parser.nextToken()
            type = parser.parseType()
            }
        else if slot.isVirtualSlot
            {
            parser.lodgeIssue(code: .vitualSlotMustSpecifyType,location: location)
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
                parser.lodgeIssue(code: .virtualSlotNotAllowedInitialExpression,location: location)
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
                parser.lodgeIssue(code: .readBlockExpectedForVirtualSlot,location: location)
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
                    parser.lodgeIssue(code: .writeBlockExpectedForVirtualSlot,location: location)
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
            parser.lodgeIssue(code: .returnExpectedInReadBlock,location: location)
            }
        return(block)
        }
        
    private class func parseWriteBlock(slotType: TypeNode,using parser: ArgonParser) -> Block
        {
        let block = Block()
        block.addLocal(Variable(name: "newValue",type: slotType,expression: nil))
        Block.parseBlockInner(block: block, using: parser)
        return(block)
        }
        
    private class func parseSuperclasses(using parser: ArgonParser) -> TypeNodes
        {
        let location = parser.token.location
        parser.nextToken()
        var superclasses = TypeNodes()
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
                    parser.lodgeIssue(code: .classExpectedButOtherSymbolFound,location: location)
                    }
                }
            else
                {
                let name = identifier.lastPart
                let type = ForwardReference(name: name)
                parser.addNode(type,atIdentifier: identifier)
                superclasses.append(type)
                }
            }
        while parser.token.isComma && !parser.token.isEnd
        return(superclasses)
        }
        
    public func setSuperclasses(_ superclasses: TypeNodes)
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
    }

public typealias ClassTypes = Array<ClassType>
