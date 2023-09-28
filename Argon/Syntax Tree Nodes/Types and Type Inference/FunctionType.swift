//
//  FunctionType.swift
//  Argon
//
//  Created by Vincent Coetzee on 21/09/2023.
//

import Foundation

public class FunctionType: InvokableType
    {
    public override var baseType: ArgonType
        {
        if self._functionType.isNil
            {
            self._functionType = FunctionType(name: self.name,cName: self.cName)
            self._functionType!.setGenericTypes(self.parameterTypes.appending(self.returnType))
            }
        return(self._functionType!)
        }
        
    public var signature: MethodSignature
        {
        MethodSignature(name: self.name,parameterTypes: [])
        }
        
    public override var isFunction: Bool
        {
        return(true)
        }
        
    private var _functionType: FunctionType?
    private var cName: String = ""
    
    public init(name: String,cName: String)
        {
        self.cName = cName
        super.init(name: name)
        }
        
    public required init(coder: NSCoder)
        {
        self.cName = coder.decodeObject(forKey: "cName") as! String
        super.init(coder: coder)
        }
        
    public override func encode(with coder: NSCoder)
        {
        coder.encode(self.cName,forKey: "cName")
        super.encode(with: coder)
        }
        
    public override func accept(visitor: Visitor)
        {
        visitor.enter(function: self)
        visitor.exit(function: self)
        }
    }
