//
//  Stack.swift
//  Argon
//
//  Created by Vincent Coetzee on 17/04/2023.
//

import Foundation

public class Stack<T>:Collection
    {
    public var allElements:[T]
        {
        return(self.elements)
        }
        
    public func index(after i: Int) -> Int
        {
        return(self.elements.index(after:i))
        }
    
    public var startIndex: Int
        {
        return(self.elements.startIndex)
        }
    
    public var endIndex: Int
        {
        return(self.elements.endIndex)
        }
    
    private var elements:[T] = []
    
    public var isEmpty:Bool
        {
        return(self.elements.isEmpty)
        }
    
    public var count:Int
        {
        return(self.elements.count)
        }
    
    public func push(_ element:T)
        {
        self.elements.append(element)
        }
    
    @discardableResult
    public func pop() -> T
        {
        if self.elements.isEmpty
            {
            fatalError("Stack underflow")
            }
        return(self.elements.popLast()!)
        }
        
    @discardableResult
    public func popOrNil() -> T?
        {
        if self.elements.isEmpty
            {
            return(nil)
            }
        return(self.elements.popLast()!)
        }
        
    @discardableResult
    public func peek() -> T
        {
        if self.elements.isEmpty
            {
            fatalError("Stack underflow")
            }
        return(self.elements.last!)
        }
        
    public var nextIndex:Int
        {
        if self.elements.isEmpty
            {
            return(0)
            }
        return(self.elements.count)
        }
        
    public var topIndex:Int?
        {
        if self.elements.isEmpty
            {
            return(nil as Int?)
            }
        return(self.elements.count - 1)
        }
        
    public var top:T?
        {
        if self.elements.isEmpty
            {
            return(nil)
            }
        return(self.elements[self.elements.count - 1])
        }
        
    public func index(before index:Int) -> Int?
        {
        if index == 0
            {
            return(nil as Int?)
            }
        return(index - 1)
        }
        
    public subscript(_ index:Int) -> T
        {
        get
            {
            if index < 0 || index >= self.elements.count
                {
                fatalError("Invalid index \(index) to subscript")
                }
            return(self.elements[index])
            }
        set
            {
            if index < 0 || index >= self.elements.count
                {
                fatalError("Invalid index \(index) to subscript")
                }
            self.elements[index] = newValue
            }
        }
        
    public func entryMatching(_ matching: (T) -> Bool) -> T?
        {
        for index in stride(from:self.elements.count - 1,to: 0,by: -1)
            {
            let element = self.elements[index]
            if matching(element)
                {
                return(element)
                }
            }
        return(nil as T?)
        }
        
    public func reset()
        {
        self.elements = []
        }
    }

extension Stack where T:Equatable
    {
    public func contains(_ element:T) -> Bool
        {
        for anElement in self.elements
            {
            if anElement == element
                {
                return(true)
                }
            }
        return(false)
        }
    }

extension Stack where T == Scope
    {
    public func lookupSymbol(atIdentifier identifier: Identifier) -> Symbol?
        {
        if self.count == 0
            {
            return(nil)
            }
        return(self.top?.lookupSymbol(atIdentifier: identifier))
        }
        
    public func lookupSymbol(atName name: String) -> Symbol?
        {
        if self.count == 0
            {
            return(nil)
            }
        return(self.top?.lookupSymbol(atName: name))
        }
    }
