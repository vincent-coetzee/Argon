//
//  IdentifierExpression.swift
//  Argon
//
//  Created by Vincent Coetzee on 26/07/2023.
//

import Foundation

public class IdentifierExpression: Expression
    {
    public private(set) var identifierValue = ValueBox.none
    
    public override var description: String
        {
        self._identifier.lastPart
        }
        
    public override var identifier: Identifier
        {
        self._identifier
        }
    
    public override var isIdentifierExpression: Bool
        {
        true
        }
        
    public override var lValue: Expression
        {
        self
        }
        
    private let _identifier:Identifier
    
    public required init(coder: NSCoder)
        {
        self._identifier = coder.decodeObject(forKey: "_identifier") as! Identifier
        super.init(coder: coder)
        }
        
    public init(identifier: Identifier)
        {
        self._identifier = identifier
        super.init(name: "")
        }
        
    public func setIdentifierValue(_ value: ValueBox)
        {
        self.identifierValue = value
        }
        
    public override func encode(with coder: NSCoder)
        {
        coder.encode(self._identifier,forKey: "_identifier")
        super.encode(with: coder)
        }
        
    public override func accept(visitor: Visitor)
        {
        visitor.visit(identifierExpression: self)
        }
    }

public class NilExpression: Expression
    {
    }
