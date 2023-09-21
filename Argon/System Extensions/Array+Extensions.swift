//
//  Array+Extensions.swift
//  Argon
//
//  Created by Vincent Coetzee on 31/01/2023.
//

import Foundation

extension Array
    {
    public var isNotEmpty: Bool
        {
        !self.isEmpty
        }
        
    public var second: Element?
        {
        guard self.count > 1 else
            {
            return(nil)
            }
        return(self[1])
        }
        
    public func appending(_ element: Element) -> Array
        {
        var temp = self
        temp.append(element)
        return(temp)
        }
        
    public func removing(_ element: Element) -> Array where Element: Equatable
        {
        var temp = self
        var index = 0
        for thisElement in self
            {
            if element == thisElement
                {
                temp.remove(at: index)
                }
            index += 1
            }
        return(temp)
        }
    }
