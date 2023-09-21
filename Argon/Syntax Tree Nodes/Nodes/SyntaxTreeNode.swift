//
//  Type.swift
//  Argon
//
//  Created by Vincent Coetzee on 2022/11/22.
//

import Foundation

//
//
// The SyntaxTreeNode class forms the ultimate root class of semantic classes
// such as e.g. Modules, Types, Expressions, Constants, Variables and Blocks and Statements.
// The reason they all descend from this class is so that these things can be
// type safely inserted anywhere into the ASTs.
//
// TODO: Figure out how to encode Modules to allow reuse in separate object files
// TODO: Ensure name mangling handles unique symbols spread across object fils even if symbols are in different instance of the same Module
// TODO: Fix name mangling
//
//
public class SyntaxTreeNode: NSObject,NSCoding,Scope,Visitable,Comparable
    {
    public static func ==(lhs: SyntaxTreeNode,rhs: SyntaxTreeNode) -> Bool
        {
        lhs.parent == rhs.parent && lhs.name == rhs.name
        }
        
    public static func isEqual(lhs: SyntaxTreeNode,rhs: SyntaxTreeNode) -> Bool
        {
        lhs.parent == rhs.parent && lhs.name == rhs.name
        }
        
    public static func <(lhs: SyntaxTreeNode,rhs: SyntaxTreeNode) -> Bool
        {
        let types1 = lhs.genericTypes.sorted()
        let types2 = rhs.genericTypes.sorted()
        let result = zip(types1,types2).reduce(true) { $0 && $1.0 < $1.1 }
        if !result
            {
            return(false)
            }
        return(lhs.name < rhs.name)
        }
    //
    //
    // This instance variable should always be used to access the generics
    // of any type nodes to ensure that the correct values are returned.
    // The generics var may not always be correct.
    //
    //
    public var genericTypes: ArgonTypes
        {
        []
        }
        
    public var isType: Bool
        {
        false
        }
        
    public var isIntrinsic: Bool
        {
        false
        }
        
    public var parentModules: Modules
        {
        self.parent!.parentModules
        }
        
    public override var hash: Int
        {
        self.identifier.hashValue
        }
        
    public var rootModule: RootModule
        {
        self.parent!.rootModule
        }
        
    public var argonModule: ArgonModule
        {
        self.rootModule.argonModule
        }
        
    public var nodeType: NodeType
        {
        return(.none)
        }
        
    public var valueBox: ValueBox
        {
        .none
        }
        
    public var isRootModule: Bool
        {
        false
        }
        
    public var isArgonModule: Bool
        {
        false
        }
        
    public var identifier: Identifier
        {
        return(self.parent?.identifier ?? Identifier(string: "\\"))
        }
    //
    //
    // A tag is a string representation of the identity of a node. It is identical to the string form
    // of the identifier except in the cases where the receiver is a TypeNode and the TypeNode has
    // generic types. In that case the tag will contain identifier based references to the generic types.
    // The implementation of TypeNode's tag makes use of this node's implementation.
    //
    //
    public var tag: String
        {
        self.identifier.description
        }
        
    public private(set) var references = NodeReferences()
    public private(set) var name: String
    public private(set) var index: Int?
    public private(set) var parent: SyntaxTreeNode?
    public var isSystemNode: Bool = false
    public private(set) var type: ArgonType!
    public private(set) var processingFlags = ProcessingFlags()
    public var location: Location?
    
    init(index: Int? = nil,name: String)
        {
        self.name = name
        self.index = index.isNil ? Argon.nextIndex : index!
        }
    
    public init(name: String)
        {
        self.name = name
        self.index = Argon.nextIndex
        }
        
    public required init(coder: NSCoder)
        {
        self.type = coder.decodeObject(forKey: "type") as? ArgonType
        self.name = coder.decodeObject(forKey: "name") as! String
        self.index = coder.decodeInteger(forKey: "index")
        self.parent = coder.decodeObject(forKey: "parent") as? SyntaxTreeNode
        self.references = coder.decodeNodeReferences(forKey: "references")
        self.isSystemNode = coder.decodeBool(forKey: "isSystemNode")
        self.processingFlags = ProcessingFlags(rawValue: UInt64(coder.decodeInteger(forKey: "processingFlags")))
        }
        
    public func removeChildNode(_ node: SyntaxTreeNode)
        {
        fatalError("removeChildNode called on SyntaxTreeNode and should not be")
        }
        
//    public func removeFromParent()
//        {
//        self.parent.removeNode(self)
//        self.parent = .none
//        }
        
    public func encode(with coder: NSCoder)
        {
        coder.encode(self.type,forKey: "type")
        coder.encode(self.name,forKey: "name")
        coder.encode(self.index,forKey: "indeX")
        coder.encode(self.parent,forKey: "parent")
        coder.encode(self.references,forKey: "references")
        coder.encode(self.isSystemNode,forKey: "isSystemNode")
        coder.encode(self.processingFlags.rawValue,forKey: "processingFlags")
        }
        
    @discardableResult
    public func addDeclaration(_ location: Location) -> Self
        {
        self.references.append(.declaration(location))
        return(self)
        }
        
//    internal func mangleName(_ aName: String) -> String
//        {
//        var typeNames = ""
//        if !self.genericTypes.isEmpty
//            {
//            typeNames = "\(self.genericTypes.count)x" + self.genericTypes.map{$0.mangledName}.joined(separator: "")
//            }
//        guard let someName = ArgonModule.encoding(for: aName) else
//            {
//            return("\(self.name.count)\(self.name)x\(typeNames)")
//            }
//        return(someName + typeNames)
//        }
        
    public func addReference(_ location: Location)
        {
        self.references.append(.reference(location))
        }
        
    public func setName(_ name: String)
        {
        self.name = name
        }
        
    public func setType(_ type: ArgonType?)
        {
        self.type = type
        }
        
    public func setParent(_ symbol: SyntaxTreeNode?)
        {
        self.parent = symbol
        }
        
//    public func setParent(_ symbol: NodeContainer?)
//        {
//        guard symbol.isNotNil else
//            {
//            self.parent = Parent.none
//            return
//            }
//        if symbol is SyntaxTreeNode
//            {
//            self.parent = .symbol(symbol as! SyntaxTreeNode)
//            return
//            }
//        fatalError("Attempt to assign \(symbol!) of type \(Swift.type(of: symbol)) as a parent.")
//        }
//        
//    public func setParent(_ expression: Expression)
//        {
//        self.parent = .expression(expression)
//        }
        
    public func setIndex(_ index: Int)
        {
        self.index = index
        }
        
    public func dump(indent: String)
        {
        print("\(indent)Symbol(\(self.name))")
        }
        
    public var isEnumeration: Bool
        {
        false
        }
        
    public var isFunction: Bool
        {
        false
        }
        
    public var baseType: ArgonType
        {
        fatalError("baseType invoked on SyntaxTreeNode which is not allowed.")
        }
        
    public var isMethod: Bool
        {
        false
        }
        
    public var isGenericType: Bool
        {
        false
        }
        
    public var isModule: Bool
        {
        false
        }
        
    public var isClass: Bool
        {
        false
        }
        
    public var module: Module
        {
        self.parent!.module
        }
        
    public func accept(visitor: Visitor)
        {
        self.processingFlags.insert(visitor.processingFlag)
        }
        
        
    public func become<T>(_ newKind: T.Type) -> T?
        {
        guard self is T else
            {
            return(nil)
            }
        return(self as! T)
        }

    public class func parse(using: ArgonParser)
        {
        fatalError("This should not be called on SyntaxTreeNode")
        }
        
    public func lookupNode(atIdentifier identifier: Identifier) -> SyntaxTreeNode?
        {
        if identifier.isEmpty
            {
            return(nil)
            }
        if identifier.isRooted
            {
            return(self.rootModule.lookupNode(atIdentifier: identifier.cdr))
            }
        if let node = self.lookupNode(atName: identifier.car!)
            {
            if identifier.cdr.isEmpty
                {
                return(node)
                }
            else
                {
                return(node.lookupNode(atIdentifier: identifier.cdr))
                }
            }
        return(nil)
        }
        
    public func addNode(_ node: SyntaxTreeNode)
        {
        fatalError("Attempt to add node to a SyntaxTreeNode whihc is not permissable.")
        }
        
    public func lookupMethods(atIdentifier identifier: Identifier) -> Methods
        {
        if identifier.isEmpty
            {
            return(Methods())
            }
        if identifier.isRooted
            {
            return(self.rootModule.lookupMethods(atIdentifier: identifier.cdr))
            }
        if let node = self.lookupNode(atName: identifier.car!)
            {
            if identifier.cdr.count == 1
                {
                return(node.lookupMethods(atName: identifier.lastPart))
                }
            else
                {
                return(node.lookupMethods(atIdentifier: identifier.cdr))
                }
            }
        return(Methods())
        }
        
    public func lookupNode(atName: String) -> SyntaxTreeNode?
        {
        nil
        }
        
    public func lookupMethods(atName: String) -> Methods
        {
        Methods()
        }
    }

public typealias SyntaxTreeNodes = Array<SyntaxTreeNode>
//
//public protocol NodeContainer
//    {
//    func addNode(_ node: SyntaxTreeNode)
//    func lookupNode(atName: String) -> SyntaxTreeNode?
//    }
