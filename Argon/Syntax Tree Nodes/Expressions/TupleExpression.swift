//
//  TupleExpression.swift
//  Argon
//
//  Created by Vincent Coetzee on 12/09/2023.
//

import Foundation

public class TupleExpression: Expression
    {
    public override var symbolType: ArgonType!
        {
        get
            {
            guard let someType = self._symbolType else
                {
                let tupleType = TupleType()
                tupleType.setGenericTypes(self.expressions.map{$0.symbolType})
                self._symbolType = tupleType
                return(tupleType)
                }
            return(someType)
            }
        set
            {
            fatalError()
            }
        }
        
    private let expressions: Expressions
    private var _symbolType: ArgonType?
    
    public init(expressions: Expressions)
        {
        self.expressions = expressions
        super.init()
        }
        
    public required init(coder: NSCoder)
        {
        self.expressions = coder.decodeObject(forKey: "expressions") as! Expressions
        super.init(coder: coder)
        }
        
    public override func encode(with coder: NSCoder)
        {
        coder.encode(self.expressions,forKey: "expressions")
        super.encode(with: coder)
        }
    }
