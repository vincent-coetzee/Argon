//
//  TypeConstraint.swift
//  Argon
//
//  Created by Vincent Coetzee on 15/10/2023.
//

import Foundation

public class TypeConstraint
    {
    public enum Relationship
        {
        case subclassOf
        case superclassOf
        case equal
        }
        
    public enum Origin
        {
        public var diagnosticString: String
            {
            switch(self)
                {
                case .symbol(let symbol):
                    return(symbol.diagnosticString)
                case .expression(let expression):
                    return(expression.diagnosticString)
                case .statement(let statement):
                    return(statement.diagnosticString)
                }
            }
            
        case symbol(Symbol)
        case expression(Expression)
        case statement(Statement)
        }
        
    public let lhs: ArgonType
    public let rhs: ArgonType
    public let relationship: Relationship
    private let origin: Origin
    
    public init(lhs: ArgonType,_ relationship: Relationship,rhs: ArgonType,origin: Origin)
        {
        self.lhs = lhs
        self.relationship = relationship
        self.rhs = rhs
        self.origin = origin
        }
        
    public func lodgeError(code: IssueCode,message: String? = nil,location: Location)
        {
        }
    }

public typealias TypeConstraints = Array<TypeConstraint>
