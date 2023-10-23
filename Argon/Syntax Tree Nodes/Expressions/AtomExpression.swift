//
//  SymbolExpression.swift
//  Argon
//
//  Created by Vincent Coetzee on 09/09/2023.
//

import Foundation

public class AtomExpression: Expression
    {
    private let atom: String
    private let values: Expressions
    
    public init(atom: String,values: Expressions = Expressions())
        {
        self.atom = atom
        self.values = values
        super.init()
        }
        
    public required init(coder: NSCoder)
        {
        self.atom = coder.decodeObject(forKey: "atom") as! String
        self.values = coder.decodeObject(forKey: "values") as! Expressions
        super.init(coder: coder)
        }
        
    public override func encode(with coder: NSCoder)
        {
        coder.encode(self.atom,forKey: "atom")
        coder.encode(self.values,forKey: "values")
        super.encode(with: coder)
        }
    }
