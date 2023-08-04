//
//  Type.swift
//  Argon
//
//  Created by Vincent Coetzee on 2022/11/22.
//

import Foundation

fileprivate var _NextSymbol = 1

public class SyntaxTreeNode: NSObject,NSCoding
    {
    public static func ==(lhs: SyntaxTreeNode,rhs: SyntaxTreeNode) -> Bool
        {
        lhs.identifier == rhs.identifier
        }
        
    public static func isEqual(lhs: SyntaxTreeNode,rhs: SyntaxTreeNode) -> Bool
        {
        lhs.identifier == rhs.identifier
        }
        
    public static var nextIndex: Int
        {
        let index = _NextSymbol
        _NextSymbol += 1
        return(index)
        }
        
    public var isType: Bool
        {
        false
        }
        
    public override var hash: Int
        {
        self.identifier.hashValue
        }
        
    public var rootModule: RootModule
        {
        self.module.rootModule
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
        return(self.module.identifier + self.name)
        }

    public var module: Module
        {
        self._module
        }
        
    public private(set) var references = NodeReferences()
    public private(set) var name: String
    public private(set) var index: Int?
    public private(set) var parent: Parent?
    public var isSystemNode: Bool = false
    private var _module: Module!
    public var assignedType: TypeNode?
    public private(set) var issues = CompilerIssues()
    
    init(index: Int? = nil,name: String)
        {
        self.name = name
        self.index = _NextSymbol
        _NextSymbol += 1
        }
        
    public init(name: String)
        {
        self.name = name
        self.index = _NextSymbol
        _NextSymbol += 1
        }
        
    public init(identifier: Identifier)
        {
        self.index = _NextSymbol
        _NextSymbol += 1
        self.name = identifier.description
        }
        
    public required init(coder: NSCoder)
        {
        self.name = coder.decodeObject(forKey: "name") as! String
        self.index = coder.decodeInteger(forKey: "index")
        self.parent = coder.decodeParent(forKey: "parent")
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
        }
        
    public func addDeclaration(_ location: Location)
        {
        self.references.append(.declaration(location))
        }
        
    public func addReference(_ location: Location)
        {
        self.references.append(.reference(location))
        }
        
    public func setName(_ name: String)
        {
        self.name = name
        }
        
    public func setModule(_ module: Module)
        {
        self._module = module
        }
        
    public func setParent(_ symbol: SyntaxTreeNode?)
        {
        if symbol.isNil
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
        
    public func dump(indent: String)
        {
        print("\(indent)Symbol(\(self.name))")
        }
        
    public var isEnumerationType: Bool
        {
        false
        }
        
    public var isModule: Bool
        {
        false
        }
        
    public var isClassType: Bool
        {
        false
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
        fatalError("parse(usingParser:) called on SyntaxTreeNode and should not be")
        }
        
    public func replaceType(atIndex: Int,with: TypeNode)
        {
        }
    }

public typealias SyntaxTreeNodes = Array<SyntaxTreeNode>
//
//public protocol NodeContainer
//    {
//    func addNode(_ node: SyntaxTreeNode)
//    func lookupNode(atName: String) -> SyntaxTreeNode?
//    }
