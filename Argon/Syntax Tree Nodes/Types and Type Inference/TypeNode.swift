//
//  Type.swift
//  Argon
//
//  Created by Vincent Coetzee on 03/02/2023.
//

import Foundation

public class TypeNode: SyntaxTreeNode
    {
    public static var integerType: TypeNode
        {
        ArgonModule.shared.integerType
        }
        
    public static var stringType: TypeNode
        {
        ArgonModule.shared.stringType
        }
        
    public static var uIntegerType: TypeNode
        {
        ArgonModule.shared.uIntegerType
        }
        
    public static var booleanType: TypeNode
        {
        ArgonModule.shared.booleanType
        }
        
    public static var characterType: TypeNode
        {
        ArgonModule.shared.characterType
        }
        
    public static var symbolType: TypeNode
        {
        ArgonModule.shared.symbolType
        }
        
    public static var byteType: TypeNode
        {
        ArgonModule.shared.byteType
        }
        
    public static var dateType: TypeNode
        {
        ArgonModule.shared.dateType
        }
        
    public static var timeType: TypeNode
        {
        ArgonModule.shared.timeType
        }
        
    public static var dateTimeType: TypeNode
        {
        ArgonModule.shared.dateTimeType
        }
        
    public override var isGenericType: Bool
        {
        !self.generics.isEmpty
        }
        
    public override var isTypeNode: Bool
        {
        false
        }
        
    public override var isType: Bool
        {
        true
        }
        
    public override var baseType: TypeNode
        {
        self
        }
    //
    //
    // This instance variable should always be used to access the generics
    // of any type nodes to ensure that the correct values are returned.
    // The generics var may not always be correct.
    //
    //
    public var genericTypes: TypeNodes
        {
        self.generics
        }
    //
    //
    // The generics instance variable should never be accessed directly. We have
    // several classes in the TypeNode hierarchy that return their genericTypes and
    // in this case the genericTypes are just the generics. The problem is that there
    // are some classes in the TypeNode hirarchy the proxy for other classes - such
    // as the AliasedType class - this means that all type specific queries sent to
    // classes such as AliasedType have to be rerouted to the underlying class. This
    // means that any attemopt to access details from a type must be done through
    // the "baseType" instance var ( which will produce the most basic type that
    // can answer the questions ) and accessing of genericTypes must be done through
    // the "genericTypes" instance variable rather than accessing the generics variable
    // directly.
    //
    //
    //
    private var generics: Array<TypeNode>
    
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
        
    public func setGenericTypes(_ types: TypeNodes)
        {
        self.generics = types
        }
        
    public func addGenericType(_ type: TypeNode)
        {
        self.generics.append(type)
        }
        
    public static func newTypeVariable(name: String? = nil) -> TypeVariable
        {
        let index = SyntaxTreeNode.nextIndex
        var theName: String? = name
        if theName.isNil
            {
            theName = "TypeVariable(\(index)"
            }
        return(TypeVariable(name: theName!,index: index))
        }
        
    public func inherits(from someClass: Class) -> Bool
        {
        false
        }
    }

public typealias TypeNodes = Array<TypeNode>

