//
//  PseudoVariable.swift
//  Argon
//
//  Created by Vincent Coetzee on 15/08/2023.
//

import Foundation

//
//
// A PseudoVariable is a value such as "self","nil" or "super"
// referenced in the code. They need special handling which is why
// they are uniqued and exported as static constants. Having only a single
// isntance of the variables in the compiler assists in compiling
// the references away because that's what needs to happen due
// to the special handling they need.
//
//
public class PseudoVariable: Variable
    {
    public static func `self`(type: ArgonType) -> Self
        {
        let variable = PseudoVariable(name: "self")
        variable.symbolType = type
        return(variable as! Self)
        }
        
    public static let `nil`:PseudoVariable =
        {
        let variable = PseudoVariable(name: "self")
        return(variable)
        }()
        
    public override init(name: String)
        {
        super.init(name: name)
        }
        
    public required init(coder: NSCoder)
        {
        super.init(coder: coder)
        }
        
    public override func encode(with coder: NSCoder)
        {
        super.encode(with: coder)
        }
    }
