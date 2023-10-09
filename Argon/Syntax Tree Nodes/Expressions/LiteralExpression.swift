//
//  LiteralNode.swift
//  Argon
//
//  Created by Vincent Coetzee on 23/07/2023.
//

import Foundation

public class LiteralExpression: Expression
    {
    private var value: ValueBox = .none
    
    public override var symbolType: ArgonType
        {
        self.value.symbolType
        }
        
    public required init(coder: NSCoder)
        {
        self.value = coder.decodeValueBox(forKey: "value")
        super.init(coder: coder)
        }
        
    public init(value: Bool)
        {
        self.value = .boolean(value)
        super.init()
        }
        
    public init(value: ValueBox)
        {
        self.value = value
        super.init()
        }
        
    public init(value: String)
        {
        self.value = .string(value)
        super.init()
        }
        
    public init(value: Argon.Integer)
        {
        self.value = .integer(value)
        super.init()
        }
        
    public init(value: Argon.Float)
        {
        self.value = .float(value)
        super.init()
        }
        
    public init(value: ClassType)
        {
        self.value = .class(value)
        super.init()
        }
        
    public init(value: EnumerationType)
        {
        self.value = .enumeration(value)
        super.init()
        }
        
    public init(value: MethodType)
        {
        self.value = .method(value)
        super.init()
        }
        
    public init(value: FunctionType)
        {
        self.value = .function(value)
        super.init()
        }
        
//    public init(enumeration: EnumerationType,enumerationCase: EnumerationCase)
//        {
//        self.value = .enumerationInstance(enumeration,enumerationCase)
//        super.init()
//        }
        
    public override func encode(with coder: NSCoder)
        {
        coder.encode(self.value,forKey: "value")
        super.encode(with: coder)
        }
        
    public override func accept(visitor: Visitor)
        {
        visitor.visit(literalExpression: self)
        }
    }
        
