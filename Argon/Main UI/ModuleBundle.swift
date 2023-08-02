//
//  ModuleBundle.swift
//  Argon
//
//  Created by Vincent Coetzee on 20/07/2023.
//

import Foundation

public class ModuleBundle
    {
    public var moduleHeaderFile: ModuleHeaderFile!
    public var moduleObjectFiles: ModuleObjectFiles!
    }

public class ModuleHeaderFile: NSObject,NSCoding
    {
    public var classes = ClassTypes()
    public var enumerations = EnumerationTypes()
    public var aliasedTypes = AliasedTypes()
    public var constants = Constants()
    public var methodSignatures = MethodSignatures()
    public var functionSignatures = FunctionSignatures()
    
    public required init(coder: NSCoder)
        {
        self.classes = coder.decodeObject(forKey: "classes") as! ClassTypes
        self.enumerations = coder.decodeObject(forKey: "enumerations") as! EnumerationTypes
        self.aliasedTypes = coder.decodeObject(forKey: "aliasedTypes") as! AliasedTypes
        self.constants = coder.decodeObject(forKey: "constants") as! Constants
        self.methodSignatures = coder.decodeObject(forKey: "methodSignatures") as! MethodSignatures
        self.functionSignatures = coder.decodeObject(forKey: "functionSignatures") as! FunctionSignatures
        }
        
    public func encode(with coder: NSCoder)
        {
        coder.encode(self.classes,forKey: "classes")
        coder.encode(self.enumerations,forKey: "enumerations")
        coder.encode(self.enumerations,forKey: "enumerations")
        coder.encode(self.constants,forKey: "constants")
        coder.encode(self.methodSignatures,forKey: "methodSignatures")
        coder.encode(self.functionSignatures,forKey: "functionSignatures")
        }
    }
    
public class ModuleObjectFile
    {
    }

public typealias ModuleObjectFiles = Array<ModuleObjectFile>

public class MethodSignature: NSObject,NSCoding
    {
    public required init(coder: NSCoder)
        {
        }
        
    public func encode(with coder: NSCoder)
        {
        }
    }
    
public typealias MethodSignatures = Array<MethodSignature>
    
public class FunctionSignature
    {
    public required init(coder: NSCoder)
        {
        }
        
    public func encode(with coder: NSCoder)
        {
        }
    }
    
public typealias FunctionSignatures = Array<FunctionSignature>
