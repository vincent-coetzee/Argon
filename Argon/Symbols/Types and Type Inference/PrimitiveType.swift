//
//  SimpleType.swift
//  Argon
//
//  Created by Vincent Coetzee on 24/09/2023.
//

import Foundation

public class PrimitiveType: ArgonType
    {
    public override var baseType: ArgonType
        {
        self
        }
        
    public override var isPrimitiveType: Bool
        {
        true
        }
        
    public required init(name: String,superclasses: ClassTypes)
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
        
    public override func addSymbol(_ symbol: Symbol)
        {
        fatalError("addSymbol should never be invoked on a SimpleType.")
        }
        
    public override func typeConstructor() -> ArgonType
        {
        self
        }
    }
