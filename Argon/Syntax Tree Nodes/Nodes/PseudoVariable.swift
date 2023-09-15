//
//  PseudoVariable.swift
//  Argon
//
//  Created by Vincent Coetzee on 15/08/2023.
//

import Foundation

public class PseudoVariable: Variable
    {
    public static func `self`(type: ArgonType) -> Self
        {
        let variable = PseudoVariable(name: "self")
        variable.setType(type)
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
