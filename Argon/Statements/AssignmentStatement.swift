//
//  AssignmentExpression.swift
//  Argon
//
//  Created by Vincent Coetzee on 31/07/2023.
//

import Foundation

public class AssignmentStatement: Statement
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
        
    public static func parse(into block: Block,using parser: ArgonParser)
        {
        let identifier = parser.token.identifier
        let location = parser.token.location
        parser.nextToken()
        if !parser.token.isAssign
            {
            parser.lodgeIssue( code: .assignExpected, location: location)
            }
        else
            {
            parser.nextToken()
            }
        let left = IdentifierExpression(identifier: identifier)
        let right = parser.parseExpression(precedence: 0)
        let statement = AssignmentStatement(left: left,right: right)
        block.addStatement(statement)
        }
    }
