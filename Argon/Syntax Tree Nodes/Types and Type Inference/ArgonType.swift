//
//  Type.swift
//  Argon
//
//  Created by Vincent Coetzee on 03/02/2023.
//

import Foundation

//
//
// ArgonType is the top of the Type hierarchy in the Argon compiler. It inherits
// from SyntaxTreeNode primarily so that it can be shoved in places where a symbol
// equivalent is expected. A GenericInstanceType - and its lone subclass, ArrayInstanceType -
// are concrete instances of GenericTypes ( i.e. SomeType<A,B,C> ) that have concrete types
// in place of GenericVariables, that means they can be directly instantiated into
// objects without any additional parsing. GenericInstanceType and ArrayInstanceType
// respond to both baseType ( which returns the original type that this type refers to, for example
// there might be an AliasedType called TypeA that is an alias to say Type1 and in that case
// invoking baseType on TypeA will return Type1 ) and parentType. parentType returns the
// type that the GenericInstanceType is predicated on ( e.g. given there is a GenericType SomeType<Value,Key> then
// parentType returns SomeType it does not return the baseType - which could be different ).
//
//
// All types that are parsed are dereferenced from the global type repository, TypeRepository, so that
// every type in the system is canonical. By canonical we mean that a type defined as Array<Integer,SomeEnumeration>
// and used in more than one place will all reference the SAME instance of Array<Integer,SomeEnumeration>. Despite there
// being multiple uses there exists one and only one instance of the type in the entire compiler.
// Uniqueness is establish by means of the typeHash variable on ArgonType which ensures that a type defined
// in the same way always generates the same hash, which might not be true for any of the other hashes used in
// the system. Canonicalising types likes this greatly simplifies how type inference is handled when
// various types instantiate type variables. When a type is parsed it is canonicalised before being returned
// to the caller of the parseType method on ArgonParser.
//
//

public class ArgonType: SyntaxTreeNode
    {
    public static var typeType: ArgonType
        {
        ArgonModule.shared.typeType
        }
        
    public static var dateOffsetType: ArgonType
        {
        ArgonModule.shared.dateOffsetType
        }
        
    public static var timeOffsetType: ArgonType
        {
        ArgonModule.shared.timeOffsetType
        }
        
    public static var classType: ArgonType
        {
        ArgonModule.shared.classType
        }
        
    public static var floatType: ArgonType
        {
        ArgonModule.shared.floatType
        }
        
    public static var enumerationType: ArgonType
        {
        ArgonModule.shared.enumerationType
        }
        
    public static var monthType: ArgonType
        {
        ArgonModule.shared.monthType
        }
        
    public static var fileType: ArgonType
        {
        ArgonModule.shared.fileType
        }
        
    public static var bufferType: ArgonType
        {
        ArgonModule.shared.bufferType
        }
        
    public static var integerType: ArgonType
        {
        ArgonModule.shared.integerType
        }
        
    public static var stringType: ArgonType
        {
        ArgonModule.shared.stringType
        }
        
    public static var uIntegerType: ArgonType
        {
        ArgonModule.shared.uIntegerType
        }
        
    public static var booleanType: ArgonType
        {
        ArgonModule.shared.booleanType
        }
        
    public static var characterType: ArgonType
        {
        ArgonModule.shared.characterType
        }
        
    public static var symbolType: ArgonType
        {
        ArgonModule.shared.symbolType
        }
        
    public static var byteType: ArgonType
        {
        ArgonModule.shared.byteType
        }
        
    public static var dateType: ArgonType
        {
        ArgonModule.shared.dateType
        }
        
    public static var timeType: ArgonType
        {
        ArgonModule.shared.timeType
        }
        
    public static var dateTimeType: ArgonType
        {
        ArgonModule.shared.dateTimeType
        }
        
    public override var isGenericType: Bool
        {
        false
        }
        
    public var instanceSizeInBits: Int
        {
        self.instanceSizeInBytes * UInt8.bitWidth
        }
        
    public var instanceSizeInBytes: Int
        {
        MemoryLayout<UInt64>.size
        }
        
    public var typeHash: Int
        {
        var hasher = Hasher()
        hasher.combine(5381)
        hasher.combine("\(Swift.type(of: self))")
        hasher.combine(self.name)
        for generic in self.genericTypes
            {
            hasher.combine(generic.typeHash)
            }
        return(hasher.finalize())
        }
        
    public var isArrayType: Bool
        {
        false
        }
        
    public override var isType: Bool
        {
        true
        }
        
    public static func newTypeVariable(named name: String) -> TypeVariable
        {
        TypeSubstitutionSet.newTypeVariable(named: name)
        }
        
    public override var baseType: ArgonType
        {
        self
        }
        
    public override var tag: String
        {
        let inners = "<" + self.genericTypes.map{$0.tag}.joined(separator: ",") + ">"
        return(super.tag + inners)
        }
        
    public var section: String?
    
//    public private(set) var instanceType: GenericInstanceType.Type?
    
    public override init(index: Int? = nil,name: String)
        {
        super.init(index: index,name: name)
        }
        
    public override init(name: String)
        {
        super.init(name: name)
        }
        
    public init()
        {
        super.init(name: "")
        }
        
    public required init(coder: NSCoder)
        {
        super.init(coder: coder)
        }
        
    public override func encode(with coder: NSCoder)
        {
        super.encode(with: coder)
        }
        
    public static func <(lhs: ArgonType,rhs: ArgonType) -> Bool
        {
        if lhs.genericTypes.count != rhs.genericTypes.count
            {
            return(false)
            }
        let result = zip(lhs.genericTypes.sorted(),rhs.genericTypes.sorted()).reduce(true) {$0 && ($1.0 < $1.1) }
        if !result
            {
            return(false)
            }
        if lhs.container.isNil || rhs.container.isNil
            {
            return(false)
            }
        return(lhs.container! < rhs.container! && lhs.name < rhs.name)
         }
        
    //
    //
    // A TypeNode is == to another TypeNode if and only if
    //
    // The number of genericTypes is the same for each
    // That the actual generic types are all equal ( in order )
    // That the parents of each of the TypeNodes are the same
    // That the names of each TypeNode are the same
    //
    //
    public static func ==(lhs: ArgonType,rhs: ArgonType) -> Bool
        {
        if lhs.genericTypes.isEmpty && rhs.genericTypes.isEmpty
            {
            return(lhs.container == rhs.container && lhs.name == rhs.name)
            }
        if lhs.genericTypes.count != rhs.genericTypes.count
            {
            return(false)
            }
        let result = zip(lhs.genericTypes,rhs.genericTypes).reduce(true) { $0 && ($1.0 == $1.1) }
        if !result
            {
            return(false)
            }
        return(lhs.container == rhs.container && lhs.name == rhs.name)
        }
    //
    //
    // This type is identical to otherType in every single way,
    // This type's identifier is the same as otherType's identifier
    // This type's generics' identifiers are each identical to otherType's generics' identifiers
    //
    //
    public func isIdentical(to otherType: ArgonType) -> Bool
        {
        self == otherType
        }
    //
    //
    // This type's baseType is == to otherType's baseType
    //
    //
    public func isEquivalent(`to` otherType: ArgonType) -> Bool
        {
        self.baseType == otherType.baseType
        }
        
    public func inherits(from someClass: ClassType) -> Bool
        {
        false
        }
        
    @discardableResult
    public func slot(_ name: String,_ type: ArgonType) -> ArgonType
        {
        fatalError("This should not be invoked on ArgonType.")
        }
        
//    public func setInstanceType(_ instanceType: GenericInstanceType.Type?)
//        {
//        self.instanceType = instanceType
//        }
        
    public func setGenericTypes(_ types: ArgonTypes)
        {
        fatalError("Should not be invoked on a TypeNode")
        }
        
    public func addGenericType(_ type: ArgonType)
        {
        fatalError("Should not be invoked on a TypeNode")
        }
        
    public func instanciate(with types: ArgonTypes,in set: TypeSubstitutionSet) throws -> ArgonType
        {
        self
        }
    }

public typealias ArgonTypes = Array<ArgonType>

