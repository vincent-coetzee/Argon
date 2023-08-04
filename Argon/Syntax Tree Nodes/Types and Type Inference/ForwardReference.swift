//
//  TypeReference.swift
//  Argon
//
//  Created by Vincent Coetzee on 23/07/2023.
//

import Foundation

public class ForwardReference: TypeNode
    {
    public enum Reference
        {
        case none
        case `class`(ClassType)
        case enumeration(EnumerationType)
        case aliasedType(AliasedType)
        case method(Method)
        case function(Function)
        }
        
    public var isNone: Bool
        {
        switch(self.reference)
            {
            case(.none):
                return(true)
            default:
                return(false)
            }
        }
        
    public var type: TypeNode?
        {
        switch(self.reference)
            {
            case(.none):
                return(nil)
            case(.class(let aClass)):
                return(aClass)
            case(.enumeration(let enumeration)):
                return(enumeration)
            case(.aliasedType(let aType)):
                return(aType)
            case(.method(let method)):
                return(method)
            case(.function(let function)):
                return(function)
            }
        }
        
    public var classType: ClassType?
        {
        switch(self.reference)
            {
            case(.class(let aClass)):
                return(aClass)
            default:
                return(nil)
            }
        }
        
    public var enumerationType: EnumerationType?
        {
        switch(self.reference)
            {
            case(.enumeration(let anEnum)):
                return(anEnum)
            default:
                return(nil)
            }
        }
        
    public var aliasedType: AliasedType?
        {
        switch(self.reference)
            {
            case(.aliasedType(let aType)):
                return(aType)
            default:
                return(nil)
            }
        }
        
    public var methodType: Method?
        {
        switch(self.reference)
            {
            case(.method(let method)):
                return(method)
            default:
                return(nil)
            }
        }
        
    public var functionType: Function?
        {
        switch(self.reference)
            {
            case(.function(let function)):
                return(function)
            default:
                return(nil)
            }
        }
        
    public private(set) var reference: Reference = .none
    
    public init(name: String,classType: ClassType)
        {
        self.reference = .class(classType)
        super.init(name: name)
        }
        
    public init(name: String)
        {
        super.init(name: name)
        }
        
    public required init(coder: NSCoder)
        {
        self.reference = coder.decodeReference(forKey: "reference")
        super.init(coder: coder)
        }
        
    public override func encode(with coder: NSCoder)
        {
        coder.encode(self.reference,forKey: "reference")
        super.encode(with: coder)
        }
    }
    
extension NSCoder
    {
    public func encode(_ reference: ForwardReference.Reference,forKey key: String)
        {
        switch(reference)
            {
            case(.none):
                self.encode(0,forKey: "\(key)_index")
            case(.class(let aClass)):
                self.encode(1,forKey: "\(key)_index")
                self.encode(aClass,forKey: "\(key)_class")
            case(.enumeration(let enumeration)):
                self.encode(2,forKey: "\(key)_index")
                self.encode(enumeration,forKey: "\(key)_enumeration")
            case(.aliasedType(let aType)):
                self.encode(3,forKey: "\(key)_index")
                self.encode(aType,forKey: "\(key)_type")
            case(.method(let method)):
                self.encode(4,forKey: "\(key)_index")
                self.encode(method,forKey: "\(key)_method")
            case(.function(let function)):
                self.encode(5,forKey: "\(key)_index")
                self.encode(function,forKey: "\(key)_function")
            }
        }
        
    public func decodeReference(forKey key: String) -> ForwardReference.Reference
        {
        let index = self.decodeInteger(forKey: "\(key)_index")
        switch(index)
            {
            case(0):
                return(.none)
            case(1):
                return(.class(self.decodeObject(forKey: "\(key)_class") as! ClassType))
            case(2):
                return(.enumeration(self.decodeObject(forKey: "\(key)_enumeration") as! EnumerationType))
            case(3):
                return(.aliasedType(self.decodeObject(forKey: "\(key)_type") as! AliasedType))
            case(4):
                return(.method(self.decodeObject(forKey: "\(key)_method") as! Method))
            case(5):
                return(.function(self.decodeObject(forKey: "\(key)_function") as! Function))
            default:
                fatalError("This should not happen. Invalid index value when decodingReference(forKey: '\(key)'")
            }
        }
    }

public typealias ForwardReferences = Array<ForwardReference>
