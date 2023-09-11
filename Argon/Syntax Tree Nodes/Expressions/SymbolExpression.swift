//
//  SymbolExpression.swift
//  Argon
//
//  Created by Vincent Coetzee on 09/09/2023.
//

import Foundation

public class SymbolExpression: Expression
    {
    private let symbol: String
    private let values: Expressions
    
    public init(symbol: String,values: Expressions = Expressions())
        {
        self.symbol = symbol
        self.values = values
        super.init()
        }
        
    public required init(coder: NSCoder)
        {
        self.symbol = coder.decodeObject(forKey: "symbol") as! String
        self.values = coder.decodeObject(forKey: "values") as! Expressions
        super.init(coder: coder)
        }
        
    public override func encode(with coder: NSCoder)
        {
        coder.encode(self.symbol,forKey: "symbol")
        coder.encode(self.values,forKey: "values")
        super.encode(with: coder)
        }
    }
