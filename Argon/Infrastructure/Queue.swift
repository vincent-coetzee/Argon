//
//  Queue.swift
//  Argon
//
//  Created by Vincent Coetzee on 18/05/2023.
//

import Foundation

public class Queue<T>
    {
    private var elements = Array<T>()
    
    public var count: Int
        {
        self.elements.count
        }
    
    public init()
        {
        }
        
    public init(elements: Array<T>)
        {
        self.elements = elements
        }
        
    public func write(_ element: T)
        {
        self.elements.insert(element,at: 0)
        }
        
    public func read() -> T?
        {
        if self.elements.isEmpty
            {
            return(nil)
            }
        return(self.elements.removeLast())
        }
        
    public func reset()
        {
        self.elements = []
        }
    }
