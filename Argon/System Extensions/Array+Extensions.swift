//
//  Array+Extensions.swift
//  Argon
//
//  Created by Vincent Coetzee on 31/01/2023.
//

import Foundation

extension Array
    {
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
    }
