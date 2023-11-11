//
//  PseudoVariableExpression.swift
//  Argon
//
//  Created by Vincent Coetzee on 11/11/2023.
//

import Foundation

public class PseudoVariableExpression: Expression
    {
    internal enum PseudoVariable: Int
        {
        case `self`
        case `super`
        }
        
    private let pseudoVariable: PseudoVariable
    
    init(pseudoVariable: PseudoVariable)
        {
        self.pseudoVariable = pseudoVariable
        super.init(name: "\(pseudoVariable)")
        }
        
    public required init(coder: NSCoder)
        {
        self.pseudoVariable = PseudoVariable(rawValue: coder.decodeInteger(forKey: "pseudoVariable"))!
        super.init(coder: coder)
        }
        
    public override func encode(with coder: NSCoder)
        {
        coder.encode(self.pseudoVariable.rawValue,forKey: "pseudoVariable")
        super.encode(with: coder)
        }
    }
