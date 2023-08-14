//
//  AssignExpression.swift
//  Argon
//
//  Created by Vincent Coetzee on 27/07/2023.
//

import Foundation

public class AssignmentExpression: Expression
    {
    private let left: Expression
    private let right: Expression
    
    public init(left: Expression,right: Expression)
        {
        self.left = left
        self.right = right
        super.init()
        }
        
    public required init(coder: NSCoder)
        {
        self.left = coder.decodeObject(forKey: "left") as! Expression
        self.right = coder.decodeObject(forKey: "right") as! Expression
        super.init(coder: coder)
        }
        
    public override func encode(with coder: NSCoder)
        {
        coder.encode(self.left,forKey: "left")
        coder.encode(self.right,forKey: "right")
        super.encode(with: coder)
        }
        
    public override func accept(visitor: Visitor)
        {
        self.left.accept(visitor: visitor)
        self.right.accept(visitor: visitor)
        visitor.visit(assignmentExpression: self)
        }
    }
