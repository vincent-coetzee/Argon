//
//  Enumeration.swift
//  Argon
//
//  Created by Vincent Coetzee on 27/01/2023.
//

import Foundation

public class EnumerationType: StructuredType
    {
    public override var valueBox: ValueBox
        {
        .enumeration(self)
        }
        
    public override var nodeType: NodeType
        {
        return(.enumeration)
        }
        
    public private(set) var cases: EnumerationCases = []
    public private(set) var defaultCase: EnumerationCase?
    public private(set) var rawType: TypeNode
    
    public init(name: String,cases: EnumerationCases = [],defaultCase: EnumerationCase? = nil,rawType: TypeNode)
        {
        self.cases = cases
        self.defaultCase = defaultCase
        self.rawType = rawType
        super.init(name: name)
        }
        
    public required init(coder: NSCoder)
        {
        self.cases = coder.decodeObject(forKey: "cases") as! EnumerationCases
        self.defaultCase = coder.decodeObject(forKey: "defaultCase") as? EnumerationCase
        self.rawType = coder.decodeObject(forKey: "rawType") as! TypeNode
        super.init(coder: coder)
        }
        
    public override func encode(with coder: NSCoder)
        {
        coder.encode(self.cases,forKey: "cases")
        coder.encode(self.defaultCase,forKey: "defaultCase")
        coder.encode(self.rawType,forKey: "rawType")
        super.encode(with: coder)
        }
        
    public override var isEnumerationType: Bool
        {
        true
        }
        
    public func `case`(atSymbol symbol: Argon.Symbol) -> EnumerationCase?
        {
        for aCase in self.cases
            {
            if aCase.name == symbol
                {
                return(aCase)
                }
            }
        return(nil)
        }
        
    public override func dump(indent: String)
        {
        print("\(indent)Enumeration(\(self.name))")
        }
    }

public typealias EnumerationTypes = Array<EnumerationType>
