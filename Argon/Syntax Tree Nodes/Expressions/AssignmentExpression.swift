//
//  AssignExpression.swift
//  Argon
//
//  Created by Vincent Coetzee on 27/07/2023.
//

import Foundation

public class AssignmentExpression: Expression
    {
    public override var lValue: Expression?
        {
        self.left.lValue
        }
        
    public override var rValue: Expression?
        {
        self.right
        }
        
    public override var leftSide: Expression?
        {
        self.left
        }
        
    public override var rightSide: Expression?
        {
        self.right
        }
        
    private let left: Expression
    private let right: Expression
    private var variable: Variable?
    
    public init(left: Expression,right: Expression,variable: Variable? = nil)
        {
        self.variable = variable
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
        visitor.enter(assignmentExpression: self)
        self.left.accept(visitor: visitor)
        self.right.accept(visitor: visitor)
        visitor.exit(assignmentExpression: self)
        }
        
    public static override func parse(using parser: ArgonParser)
        {
        let location = parser.token.location
        let expression = parser.parseExpression()
        if let lValue = expression.lValue,let rValue = expression.rValue,lValue.isIdentifierExpression
            {
            if let node = parser.currentScope.lookupNode(atName: lValue.identifier.lastPart),node is Variable
                {
                if let left = expression.leftSide,let right = expression.rightSide
                    {
                    let statement = AssignmentStatement(left: left,right: right,variable: node as! Variable)
                    parser.currentScope.addNode(statement)
                    return
                    }
                }
            }
        parser.lodgeIssue(code: .invalidAssignmentExpression,location: location)
        }
    }
