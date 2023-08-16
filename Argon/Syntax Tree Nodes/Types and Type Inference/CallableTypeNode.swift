//
//  ExecutableTypeNode.swift
//  Argon
//
//  Created by Vincent Coetzee on 03/08/2023.
//

import Foundation

public class CallableTypeNode: TypeNode
    {
    public private(set) var parameters = Parameters()
    public private(set) var returnType: TypeNode?
    
    public init(name: String)
        {
        super.init(name: name)
        }
        
    public required init(coder: NSCoder)
        {
        self.parameters = coder.decodeObject(forKey: "parameters") as! Parameters
        self.returnType = coder.decodeObject(forKey: "returnType") as? TypeNode
        super.init(coder: coder)
        }
        
    public override func encode(with coder: NSCoder)
        {
        coder.encode(self.parameters,forKey: "parameters")
        coder.encode(self.returnType,forKey: "returnType")
        super.encode(with: coder)
        }
        
    public func setParameters(_ parameters: Parameters)
        {
        self.parameters = parameters
        }
        
    public func addParameter(_ parameter: Parameter)
        {
        self.parameters.append(parameter)
        }
        
    public func setReturnType(_ returnType: TypeNode?)
        {
        self.returnType = returnType
        }
    }
