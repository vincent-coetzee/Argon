//
//  StructuredType.swift
//  Argon
//
//  Created by Vincent Coetzee on 05/07/2023.
//

import Foundation

public class StructuredType: ArgonType
    {
    public override var baseType: ArgonType
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
    public override var genericTypes: ArgonTypes
        {
        self._genericTypes
        }
    //
    //
    // The generics instance variable should never be accessed directly. We have
    // several classes in the TypeNode hierarchy that return their genericTypes and
    // in this case the genericTypes are just the generics. The problem is that there
    // are some classes in the TypeNode hirarchy that proxy for other classes - such
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
    private var _genericTypes = ArgonTypes()
    
    public var elementTypes: ArgonTypes
        {
        fatalError("This should have been overridden")
        }
        
    public required init(name: String,genericTypes: ArgonTypes = [])
        {
        self._genericTypes = genericTypes
        super.init(name: name)
        }
        
    public required init(coder: NSCoder)
        {
        self._genericTypes = coder.decodeObject(forKey: "_genericTypes") as! ArgonTypes
        super.init(coder: coder)
        }
        
    public override func encode(with coder: NSCoder)
        {
        coder.encode(self._genericTypes,forKey: "_genericTypes")
        super.encode(with: coder)
        }
        
    public override func setGenericTypes(_ types: ArgonTypes)
        {
        self._genericTypes = types
        }
        
    public override func addGenericType(_ type: ArgonType)
        {
        self._genericTypes.append(type)
        }
        
    public override func clone() -> Self
        {
        let aType = Self(name: self.name,genericTypes: self._genericTypes)
        return(aType)
        }
    }
