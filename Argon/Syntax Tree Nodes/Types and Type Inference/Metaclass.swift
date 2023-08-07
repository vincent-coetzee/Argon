//
//  Metaclass.swift
//  Argon
//
//  Created by Vincent Coetzee on 07/08/2023.
//

import Foundation

public class Metaclass: Class
    {
    public init(`class`: Class)
        {
        super.init(name: `class`.name + " class")
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
