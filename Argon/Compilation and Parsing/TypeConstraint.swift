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
        case lessThan
        case greaterThan
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
                case .block(let block):
                    return(block.diagnosticString)
                }
            }
            
        case symbol(Symbol)
        case expression(Expression)
        case block(Block)
        }
        
    public let lhs: ArgonType
    public let rhs: ArgonType
    public let relationship: Relationship
    private let origin: Origin
    public let issueReporter: IssueReporter
    
    public init(issueReporter: IssueReporter,lhs: ArgonType,_ relationship: Relationship,rhs: ArgonType,origin: Origin)
        {
        self.issueReporter = issueReporter
        self.lhs = lhs
        self.relationship = relationship
        self.rhs = rhs
        self.origin = origin
        }
        
    public func lodgeError(code: IssueCode,message: String? = nil,location: Location)
        {
        self.issueReporter.lodgeError(code: code, message: message, location: location)
        }
    }

public typealias TypeConstraints = Array<TypeConstraint>
