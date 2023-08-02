//
//  Type.swift
//  Argon
//
//  Created by Vincent Coetzee on 03/02/2023.
//

import Foundation

public class TypeNode: SyntaxTreeNode
    {
    public var isPlaceholderType: Bool
        {
        false
        }

    public override var isType: Bool
        {
        true
        }
        
    public static func newTypeVariable(name: String? = nil) -> TypeNode
        {
        let index = SyntaxTreeNode.nextIndex
        var theName: String? = name
        if theName.isNil
            {
            theName = "TypeVariable(\(index)"
            }
        return(TypeVariable(name: theName!,index: index))
        }
        
    public let generics: Array<TypeNode>
    
    public init(index: Int? = nil,name: String,generics: TypeNodes = [])
        {
        self.generics = generics
        super.init(index: index,name: name)
        }
        
    public init(name: String,generics: TypeNodes = [])
        {
        self.generics = generics
        super.init(name: name)
        }
        
    public init()
        {
        self.generics = []
        super.init(name: "")
        }
        
    public required init(coder: NSCoder)
        {
        self.generics = coder.decodeObject(forKey: "generics") as! TypeNodes
        super.init(coder: coder)
        }
        
    public override func encode(with coder: NSCoder)
        {
        coder.encode(self.generics,forKey: "generics")
        super.encode(with: coder)
        }
    
    }

public typealias TypeNodes = Array<TypeNode>

