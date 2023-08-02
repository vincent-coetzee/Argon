//
//  NSCoder+Extensions.swift
//  Argon
//
//  Created by Vincent Coetzee on 14/01/2023.
//

import Foundation

public extension NSCoder
    {
    func decodeParent(forKey key: String) -> Parent?
        {
        if self.decodeBool(forKey: key + "isNil")
            {
            return(nil)
            }
        switch(self.decodeInteger(forKey: key + "index"))
            {
            case(0):
                return(Parent.none)
            case(1):
                let symbol = self.decodeObject(forKey: key + "symbol") as! SyntaxTreeNode
                return(.symbol(symbol))
            case(2):
                let expression = self.decodeObject(forKey: key + "expression") as! Expression
                return(.expression(expression))
            default:
                fatalError("Invalid index in decodeParent")
            }
        }
        
    func encode(_ value: Parent?,forKey key: String)
        {
        if value.isNil
            {
            self.encode(true,forKey: key + "isNil")
            return
            }
        self.encode(false,forKey: key  + "isNil")
        switch(value!)
            {
            case .none:
                self.encode(0,forKey: key + "index")
            case .symbol(let symbol):
                self.encode(1,forKey: key + "index")
                self.encode(symbol,forKey: key + "symbol")
            case .expression(let expression):
                self.encode(2,forKey: key + "index")
                self.encode(expression,forKey: key + "expression")
            }
        }
    }
