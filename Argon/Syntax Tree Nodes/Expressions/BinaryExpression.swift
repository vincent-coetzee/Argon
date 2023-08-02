//
//  BinaryExpression.swift
//  Argon
//
//  Created by Vincent Coetzee on 26/07/2023.
//

import Foundation

public class BinaryExpression: Expression
    {
    public let left: Expression
    private let `operator`: TokenType
    public let right: Expression
    
    public init(left: Expression,right: Expression)
        {
        self.left = left
        self.right = right
        self.operator = .none
        super.init()
        }
        
    public init(left: Expression,operator: TokenType,right: Expression)
        {
        self.left = left
        self.operator = `operator`
        self.right = right
        super.init()
        }
        
    public required init(coder: NSCoder)
        {
        self.left = coder.decodeObject(forKey: "left") as! Expression
        self.operator = TokenType(rawValue: coder.decodeInteger(forKey: "operator"))!
        self.right = coder.decodeObject(forKey: "right") as! Expression
        super.init(coder: coder)
        }
        
    public override func encode(with coder: NSCoder)
        {
        coder.encode(self.left,forKey: "left")
        coder.encode(self.operator,forKey: "operator")
        coder.encode(self.right,forKey: "right")
        super.encode(with: coder)
        }
    }
