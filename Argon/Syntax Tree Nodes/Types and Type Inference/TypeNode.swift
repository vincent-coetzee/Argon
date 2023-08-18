//
//  Type.swift
//  Argon
//
//  Created by Vincent Coetzee on 03/02/2023.
//

import Foundation

public class TypeNode: SyntaxTreeNode
    {
    //
    // Encodings are needed to allow for the emission of method names that accommodate multimethods.
    // Multimethods often have the same name but differ only in the types of the arguments and return
    // types. For this reason therefore an encoding mechanism is needed for method names to allow
    // a standard code generator and linker to function in the presense of multimethods. When
    // method names are generated they make use of an encoding algorithm that generates unique names
    // for multimethods with the same name.
    //
    // Encodings are defined as follows :-
    //
    // Integer8             A
    // Integer16            B
    // Integer32            C
    // Integer64            D
    // UInteger8            E
    // UInteger16           F
    // UInteger32           G
    // UInteger64           H
    // Float16              I
    // Float32              J
    // Float64              K
    // Date                 L
    // Time                 M
    // DateTime             N
    // Slot                 O
    // Byte                 P
    // Character            Q
    // Integer              R
    // String               S
    // UInteger             T
    // Float                U
    // Void                 V
    // Set                  W
    // Dictionary           X
    // List                 Y
    // Array                Z
    // Function             a
    // Class                b
    // Method               c
    // Enumeration          d
    // GenericTypeInstance  e
    // ArrayTypeInstance    f
    // Index.none           l
    // Index.discrete       m
    // Index.enumeration    n
    // Index.integer        o
    // Index.subType        p
    // SubType              q
    // ValueBox             x
    // Tuple                r
    // AliasedType          s
    // Pointer              t
    // Metaclass            u
    // Module               v
    //
    // Count = 0            w
    // Count = 1            x
    // Count = 2            y
    // Count = 3            z
    // Count = 4            0
    // Count = 5            1
    // Count = 6            2
    // Count = 7            3
    // Count = 8            4
    // Count = 9            5
    // Count = 10           6
    // Count = 11           7
    // Count = 12           8
    // Count = 13           9
    //
    // For objects such as ArrayTypeInstance, GenericTypeInstance, Pointer, Class, Enumeration and Metaclass
    // the encoding letter is output first for example for classes "b" followed by the name of the object for example "Customer" and then is
    // terminated using underscore to mark the end of the name so for the Customer class the encoding would be "bCustomer_". In some cases such as with
    // Integers, Floats, Strings, Basic Types and Unsigned Integers a single letter encoding is used instead of the normal class type encoding because
    // such types are very common therefore it makes sense to save space by using single letter encodings. Any encoding that
    // uses the name of an object in the encoding is terminated with an underscore "_". For those encodings that involve sequences of parameters and
    // result types such as for Functions and Methods, an encoded parameter count will follow the encoded name of the Function or Method. Note that
    // the encoded length does NOT include the count for the result type, the result type is assuemd to follow the counted list parameters. Due to
    // to the nature of the Argon language the parameters do not include the names of the parameters but only the types. For example a method
    // called "doTheThing" that takes a string argument and an instance of a class called "CalculatedThing" and returns an enumeration called
    // "SomeEnumeration" will be encoded as follows :-
    //
    //              Method encoding      -> c
    //              Method name          -> doTheThing
    //              Name terminator      -> _
    //       Encoded Argument Count      -> x
    //              First Argument Type  -> s
    //              Argument Terminator  -> _
    //              Second Argument Type -> bCalculatedThing_
    //              Second Terminator    -> _
    //              Return Type          -> dSomeEnumeration_
    //           Return Type Terminator  -> _
    //
    // So the following encoding results -> "cdoTheThing_xs_bCalculatedThing__dSomeEnumeration__"
    //
    
    public static var countEncodings: Array<String>
        {
        ["l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
        }
        
    public static var floatType: TypeNode
        {
        ArgonModule.shared.floatType
        }
        
    public static var monthType: TypeNode
        {
        ArgonModule.shared.monthType
        }
        
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
        
    public override var encoding: String
        {
        self._encoding!
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
    private var generics: Array<TypeNode>
    private var _encoding: String?
    public private(set) var instanceType: GenericTypeInstance.Type?
    
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
        self._encoding = coder.decodeObject(forKey: "_encoding") as? String
        super.init(coder: coder)
        }
        
    public override func encode(with coder: NSCoder)
        {
        coder.encode(self._encoding,forKey: "_encoding")
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
        
    public func setEncoding(_ encoding: String?)
        {
        self._encoding = encoding
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
        
        
    public func setInstanceType(_ instanceType: GenericTypeInstance.Type?)
        {
        self.instanceType = instanceType
        }
    }

public typealias TypeNodes = Array<TypeNode>

