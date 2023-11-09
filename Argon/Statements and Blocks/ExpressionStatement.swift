//
//  ExpressionStatement.swift
//  Argon
//
//  Created by Vincent Coetzee on 28/10/2023.
//

import Foundation

public class ExpressionStatement: Statement
    {
    public override var description: String
        {
        self.expression.description
        }
        
    private let expression: Expression
    
    init(expression: Expression)
        {
        self.expression = expression
        super.init()
        }
        
    public required init(coder: NSCoder)
        {
        self.expression = coder.decodeObject(forKey: "expression") as! Expression
        super.init(coder: coder)
        }
        
    public override func encode(with coder: NSCoder)
        {
        coder.encode(self.expression,forKey: "expression")
        super.encode(with: coder)
        }
        
    public override func configure(nodeView: SymbolViewCell)
        {
        nodeView.leftPane.stringValue = "\(Swift.type(of: self)) \(self.description)"
        nodeView.imageName = "IconNodeElement"
        }
    }
