//
//  SimpleType.swift
//  Argon
//
//  Created by Vincent Coetzee on 24/09/2023.
//

import Foundation

public class PrimitiveClassType: ClassType
    {
    public required init(name: String,superclasses: ClassTypes)
        {
        super.init(name: name,superclasses: superclasses)
        self.symbolTable = nil
        }
        
    public required init(coder: NSCoder)
        {
        super.init(coder: coder)
        self.symbolTable = nil
        }
        
    public override func encode(with coder: NSCoder)
        {
        self.symbolTable = nil
        super.encode(with: coder)
        }
        
    public override func instanciate(withTypes: ArgonTypes) throws -> ArgonType
        {
        let message = "A primitive type '\(self.name)' can not be used as a generic type."
        throw(CompilerError(code: .primitiveTypeNotAGenericType, message: message))
        }
        
    public override func addSymbol(_ symbol: SyntaxTreeNode)
        {
        fatalError("addSymbol should never be invoked on a SimpleType.")
        }
    }
