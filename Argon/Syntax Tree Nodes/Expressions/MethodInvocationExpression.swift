//
//  MethodInvocationExpression.swift
//  Argon
//
//  Created by Vincent Coetzee on 26/07/2023.
//

import Foundation

public class MethodInvocationExpression: Expression
    {
    private var method: Method?
    private let methodName: String
    private let arguments: Arguments
    
    public init(methodName: String,arguments: Arguments)
        {
        self.methodName = methodName
        self.arguments = arguments
        super.init()
        }
        
    public required init(coder: NSCoder)
        {
        self.method = coder.decodeObject(forKey: "method") as? Method
        self.methodName = coder.decodeObject(forKey: "methodName") as! String
        self.arguments = coder.decodeObject(forKey: "arguments") as! Arguments
        super.init(coder: coder)
        }
        
    public override func encode(with coder: NSCoder)
        {
        coder.encode(self.method,forKey: "method")
        coder.encode(self.methodName,forKey: "methodName")
        coder.encode(self.arguments,forKey: "arguments")
        super.encode(with: coder)
        }
        
    public override func accept(visitor: Visitor)
        {
        visitor.visit(methodInvocationExpression: self)
        }
    }
