//
//  PseudoVariable.swift
//  Argon
//
//  Created by Vincent Coetzee on 15/08/2023.
//

import Foundation

public class PseudoVariable: Variable
    {
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
