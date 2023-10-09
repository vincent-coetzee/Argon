//
//  Slot.swift
//  Argon
//
//  Created by Vincent Coetzee on 27/01/2023.
//

import Foundation

public struct SlotFlags: OptionSet
    {
    public static let virtual = SlotFlags(rawValue: 1 << 0)
    public static let dynmaic = SlotFlags(rawValue: 1 << 1)
    public static let read = SlotFlags(rawValue: 1 << 2)
    public static let write = SlotFlags(rawValue: 1 << 3)
    
    public var rawValue: Int
    
    public init(rawValue: Int)
        {
        self.rawValue = rawValue
        }
    }
    
public class Slot: Symbol
    {
    public override var hash: Int
        {
        var hasher = Hasher()
        hasher.combine("SLOT")
        hasher.combine(self.identifier)
        hasher.combine(self.symbolType)
        return(hasher.finalize())
        }
        
    public override var symbolType: ArgonType
        {
        get
            {
            self._symbolType
            }
        set
            {
            self._symbolType = newValue
            }
        }
        
    public var slotFlags = SlotFlags(rawValue: 0)
    
    public private(set) var initialExpression: Expression?
    public private(set) var readBlock: Block?
    public private(set) var writeBlock: Block?
    private var _symbolType: ArgonType = TypeSubstitutionSet.initialSet.newTypeVariable()
    
    public init(name: String,type: ArgonType? = nil)
        {
        super.init(name: name)
        self.symbolType = type ?? ArgonModule.shared.errorType
        }
        
    required public init(coder: NSCoder)
        {
        self.slotFlags = SlotFlags(rawValue: coder.decodeInteger(forKey: "slotFlags"))
        self.initialExpression = coder.decodeObject(forKey: "initialExpression") as? Expression
        self.readBlock = coder.decodeObject(forKey: "readBlock") as? Block
        self.writeBlock = coder.decodeObject(forKey: "writeBlock") as? Block
        self._symbolType = coder.decodeObject(forKey: "_symbolType") as! ArgonType
        super.init(coder: coder)
        }
        
    public override func encode(with coder: NSCoder)
        {
        coder.encode(self._symbolType,forKey: "_symbolType")
        coder.encode(self.slotFlags.rawValue,forKey: "slotFlags")
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
        
    public override var astLabel: String
        {
        "\(self.name) :: \(self.symbolType.name)"
        }
    }

public typealias Slots = Array<Slot>
