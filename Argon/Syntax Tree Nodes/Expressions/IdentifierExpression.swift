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
    
    public override var identifier: Identifier
        {
        self._identifier
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
    }
