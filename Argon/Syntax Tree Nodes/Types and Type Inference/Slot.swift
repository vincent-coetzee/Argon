//
//  Slot.swift
//  Argon
//
//  Created by Vincent Coetzee on 27/01/2023.
//

import Foundation

public class Slot: SyntaxTreeNode
    {
    public var isReadWriteSlot = false
    public var isDynamicSlot = false
    public private(set) var initialExpression: Expression?
    public var isVirtualSlot = false
    public private(set) var readBlock: Block?
    public private(set) var writeBlock: Block?
    
    public init(name: String,type: ArgonType? = nil)
        {
        super.init(name: name)
        self.setType(type)
        }
        
    required public init(coder: NSCoder)
        {
        self.isReadWriteSlot = coder.decodeBool(forKey: "isReadWriteSlot")
        self.isDynamicSlot = coder.decodeBool(forKey: "isDynamicSlot")
        self.isVirtualSlot = coder.decodeBool(forKey: "isVirtualSlot")
        self.initialExpression = coder.decodeObject(forKey: "initialExpression") as? Expression
        self.readBlock = coder.decodeObject(forKey: "readBlock") as? Block
        self.writeBlock = coder.decodeObject(forKey: "writeBlock") as? Block
        super.init(coder: coder)
        }
        
    public override func encode(with coder: NSCoder)
        {
        coder.encode(self.isReadWriteSlot,forKey: "isReadWriteSlot")
        coder.encode(self.isDynamicSlot,forKey: "isDynamicSlot")
        coder.encode(self.isVirtualSlot,forKey: "isVirtualSlot")
        coder.encode(self.initialExpression,forKey: "initialExpression")
        coder.encode(self.readBlock,forKey: "readBlock")
        coder.encode(self.writeBlock,forKey: "writeBlock")
        super.encode(with: coder)
        }
        
    public func setInitialExpression(_ expression: Expression?)
        {
        self.initialExpression = expression
        }
        
    public func setReadBlock(_ block: Block?)
        {
        self.readBlock = block
        }
        
    public func setWriteBlock(_ block: Block?)
        {
        self.writeBlock = block
        }
        
    public override func accept(visitor: Visitor)
        {
        self.initialExpression?.accept(visitor: visitor)
        self.readBlock?.accept(visitor: visitor)
        self.writeBlock?.accept(visitor: visitor)
        visitor.visit(slot: self)
        }
    }

public typealias Slots = Array<Slot>
