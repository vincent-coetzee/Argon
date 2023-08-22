//
//  Type.swift
//  Argon
//
//  Created by Vincent Coetzee on 2022/11/22.
//

import Foundation

public class SyntaxTreeNode: NSObject,NSCoding,Scope,Visitable
    {
    public static func ==(lhs: SyntaxTreeNode,rhs: SyntaxTreeNode) -> Bool
        {
        lhs.identifier == rhs.identifier
        }
        
    public static func isEqual(lhs: SyntaxTreeNode,rhs: SyntaxTreeNode) -> Bool
        {
        lhs.identifier == rhs.identifier
        }
        
    public var isType: Bool
        {
        false
        }
        
    public var parentModules: Modules
        {
        self.parent?.parentModules ?? Modules()
        }
        
    public var encoding: String
        {
        fatalError("Encoding called on SyntaxTreeNode and should not be.")
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
        
    public var identifier: Identifier
        {
        self.parent.isNil ? Identifier(string: self.name) : self.parent!.identifier + name
        }
        
    public private(set) var references = NodeReferences()
    public private(set) var name: String
    public private(set) var index: Int?
    public private(set) var parent: Parent?
    public var isSystemNode: Bool = false
    public private(set) var type: TypeNode!
    public private(set) var issues = CompilerIssues()
    
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
        self.name = coder.decodeObject(forKey: "name") as! String
        self.index = coder.decodeInteger(forKey: "index")
        self.parent = coder.decodeParent(forKey: "parent")
        self.issues = coder.decodeObject(forKey: "issues") as! CompilerIssues
        self.references = coder.decodeNodeReferences(forKey: "references")
        self.isSystemNode = coder.decodeBool(forKey: "isSystemNode")
        }
        
    public func addIssue(code: ErrorCode,message: String? = nil,location: Location)
        {
        self.issues.append(CompilerIssue(code: code,message: message,location: location))
        }
        
    public func removeChildNode(_ node: SyntaxTreeNode)
        {
        fatalError("removeChildNode called on SyntaxTreeNode and should not be")
        }
        
    public func removeFromParent()
        {
        self.parent?.removeNode(self)
        }
        
    public func encode(with coder: NSCoder)
        {
        coder.encode(self.name,forKey: "name")
        coder.encode(self.index,forKey: "indeX")
        coder.encode(self.parent,forKey: "parent")
        coder.encode(self.references,forKey: "references")
        coder.encode(self.issues,forKey: "issues")
        coder.encode(self.isSystemNode,forKey: "isSystemNode")
        }
        
    @discardableResult
    public func addDeclaration(_ location: Location) -> Self
        {
        self.references.append(.declaration(location))
        return(self)
        }
        
    public func addReference(_ location: Location)
        {
        self.references.append(.reference(location))
        }
        
    public func setName(_ name: String)
        {
        self.name = name
        }
        
    public func setType(_ type: TypeNode?)
        {
        self.type = type
        }
        
    public func setParent(_ symbol: SyntaxTreeNode?)
        {
        guard symbol.isNotNil else
            {
            self.parent = Parent.none
            return
            }
        self.parent = .symbol(symbol!)
        }
        
    public func setParent(_ expression: Expression)
        {
        self.parent = .expression(expression)
        }
        
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
        
    public var baseType: TypeNode
        {
        fatalError("baseType invoked on SyntaxTreeNode which is not allowed.")
        }
        
    public var isMethod: Bool
        {
        false
        }
        
    public var isTypeNode: Bool
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
        fatalError("This should have been overriden but it wasn't.")
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
